---
name: autonomous-loop
description: Implement and ship Linear or GitHub issues with no stop for the user, one at a time, each in a fresh subagent and its own worktree. Takes the issues the user names, or else every Todo issue of one project, from the highest priority and the oldest. Use only when the user runs /pipe-skills:autonomous-loop or says "implement the whole Todo queue on your own" or "implement and ship ABC-123 on your own" or "implement and ship #42 on your own".
disable-model-invocation: true
---

# Implement and ship a queue of issues

You are the orchestrator. You do not read, write, or review code. The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says.

## Queue

- The issues the user names. Else the queue of the project that the argument or the project `CLAUDE.md` names: every `Todo` issue, in the order of the tracker file. When the queue of the tracker file needs a project that the argument does not name, list the outcomes and stop before you start.
- Freeze the queue at the start. An issue created during the run is often a follow-up that the user has not read yet.
- Read the target branch (the branch the user is on) and the repository root.

State the queue in one line per issue, then start. The call of this skill authorizes, for the issues in the queue only, to push, merge, close the issue, and delete the branch and the worktree. It does not authorize a version bump, a tag, or a release.

## Run

One issue at a time, because each one merges into the target branch before the next starts. For each issue:

1. Skip it when it is no longer `Todo`, or when it has an open blocker.
2. Start a fresh subagent with the Agent tool: `isolation: "worktree"`, the model of this session, and the prompt below. Do not fork, so that the subagent starts clean.
3. End the turn and wait for its notification. When it ends without its report, ask it for the report with SendMessage.
4. Record its report, and remove its worktree when the harness did not. A worktree that the Agent tool made is locked: remove it with `git worktree remove -f -f`.

A result other than `shipped` does not stop the loop. When a guard or a tool stops a subagent, start one more subagent for the same issue. When the same failure stops three issues in a row, the failure is in the environment: end the loop. At the end, take the skipped issues once more when they have no open blocker now.

### Subagent prompt

> Implement and ship the issue `<identifier>` of `<root>`, with no stop for the user. The target branch is `<target>`. Read `${CLAUDE_PLUGIN_ROOT}/skills/implement/SKILL.md` and `${CLAUDE_PLUGIN_ROOT}/skills/ship/SKILL.md`, and the tracker file `<tracker file>`, and follow them with these changes:
>
> - First decide whether the issue is worth its cost. When it is not, change no file, explain why in an issue comment, set the issue to `Backlog` so that no later loop takes it again, and report `skipped: not worth it`.
> - You already run in a worktree. Do not call EnterWorktree: name the branch as the tracker file says, and check it out as the implement skill says.
> - Never ask the user. When the issue leaves a choice open, take the option that changes the least and is easiest to reverse, and record it in an issue comment. Stop only when the issue does not say what to build.
> - Fix every blocker and every in-scope finding in the branch, and file a new issue only by step 4 of the ship skill.
> - Ship without waiting for a go. Rebase when the branch holds only your commits. Mark the pull request ready, watch its checks with one background watcher, and fix a failed check at most three times. Do not remove your worktree, and do not check out or pull the target branch in `<root>`.
> - When the environment fails (a login, a registry, a credential), stop and name the command that fixes it.
>
> End with this report and nothing more, at most ten lines: the result (`shipped`, `skipped: not worth it`, `stopped at merge gate`, `stopped before work`, or `stopped by guard`), the reason when it did not ship, the pull request, the merge commit, the decisions you recorded, the issues you filed or added a case to, and your worktree path.

## Report

The counts first: shipped, skipped, stopped. Then one line per issue with its result, pull request and merge commit; the decisions the subagents recorded; the issues they filed; and for each issue that did not ship, the reason and the repair you propose. Say whether the local target branch in `<root>` is behind its remote, and pull it only when it holds no change of the user.
