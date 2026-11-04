---
name: autonomous-loop
description: Implement and ship every `Todo` issue of a Linear project, one at a time, from the highest priority to the lowest, and from the oldest to the newest within one priority. The orchestrator keeps a clean context: each issue runs in its own subagent, in its own worktree, through `autonomous-implement`. Use only when the user runs /autonomous-loop or says "implement the whole Todo queue on your own".
disable-model-invocation: true
---

# Implement the Todo queue of a Linear project

You are the orchestrator. You do not read code, write code, or review it. You hold the queue, start one subagent per issue, and keep a short ledger of the results. Every issue runs through `autonomous-implement`, whose rules apply as written.

Use the tools of the Linear MCP server. Load them with ToolSearch first.

## 1. Build the queue

- Linear team and project: the argument of the user, or else the project `CLAUDE.md`. If neither names them, stop and ask.
- Target branch: the branch the user is on now. Read it once, and give it to every subagent.
- Repository root: `git rev-parse --show-toplevel`.
- Skill file: the absolute path of `../autonomous-implement/SKILL.md`, relative to the base directory of this skill. A subagent does not know where the plugin lives, so give it this path.
- Record the start time of the run.
- `list_issues` for the project in the state `Todo`, every page. Sort by priority, highest first: `Urgent`, `High`, `Medium`, `Low`, and `No priority` last. Linear stores them as 1, 2, 3, 4 and 0, so 0 does not sort first. Within one priority, sort by `createdAt`, oldest first. This list, frozen now, is the queue. An issue created after the start of the run is not in it: it is often a deferred finding that a subagent filed, and the user has not read it yet.

State the queue to the user in one line per issue, then start. Do not wait for a go.

## 2. Run one issue at a time

Run the issues in sequence, never in parallel: each one merges into the target branch, and the next one must start from that merge.

For each issue in the queue:

1. **Check it again.** `get_issue`. Skip it when its state is no longer `Todo`. Skip it for now when an issue that blocks it is not `Done`.
2. **Start a fresh subagent.** Use the Agent tool with `subagent_type: "general-purpose"` and `isolation: "worktree"`. Never use `fork`: a fork inherits this context, and the issue must start clean. Give it the prompt below and nothing else.
3. **Wait for its notification.** End the turn. Do not poll, and do not sleep.
4. **Record the result** in the ledger: the issue, the result, the pull request, the merge commit, the decisions, the issues filed. Keep only the short report of the subagent.
5. **Remove its worktree** with `git worktree remove <path>` and `git worktree prune`, when the harness did not remove it.

After the last issue, take the skipped blocked issues once more, in the same order, when their blockers are now `Done`.

### Prompt for the subagent

> Implement and ship the Linear issue `<ABC-123>` of the repository `<root>`. Read `<skill file>` and follow it. The Skill tool cannot load it, so read the file. The target branch is `<target>`.
>
> A follow-up issue is a cost: the user must read it, and the next run of the loop implements it. Fix every real bug and every feature of high value that a review finds in this branch, and file a new issue only by the three rules of `ship` step 6.
>
> You run in an isolated worktree that the harness made for you. It replaces the worktree of `implement` step 1: do not call EnterWorktree. In this worktree, run `git fetch origin` and create the branch that `gitBranchName` names from `origin/<target>`.
>
> In `ship`, skip step 8 and step 9. Do not remove your worktree, and do not check out or pull the target branch in `<root>`: the user works there. The orchestrator removes your worktree.
>
> Do not report to the user. End with this report and nothing more, in short plain sentences, at most ten lines: result (`shipped`, `stopped at merge gate`, `stopped before work`, or `stopped by guard`), the reason when it stopped, the pull request URL, the merge commit, the decisions you made with their comment links, the Linear issues you filed or added a case to, and the path of your worktree.

## 3. Handle each result and continue

A result that is not `shipped` belongs to its issue, not to the loop. Record it and go to the next issue.

- **Stopped at the merge gate, or before the work.** The issue stays as the subagent left it, with its reason in a comment. The next issue starts from the target branch without it.
- **Stopped by a guard**, or a tool failed: the repository, `gh`, the Linear MCP, or the CI. Start one new subagent for the same issue. When the second one stops for the same reason, record it and go to the next issue.
- **The same tool failure stops three issues in sequence.** The failure is in the environment, not in the issues, and every issue that follows meets it too. This is the one case where the loop ends before the queue is empty.

The loop ends when the queue is empty.

## 4. Report

One report at the end. Give:

- The count first: shipped, stopped, skipped.
- One line per issue, in queue order: the identifier, the result, the pull request, the merge commit.
- The decisions that the subagents made in place of the user, with the links to their comments.
- The issues that the subagents filed or added a case to, which the next run will pick up when they are in `Todo`.
- For each issue that did not ship: the reason, and the repair you propose. When the loop ended before the queue was empty, say which failure ended it.
- The local target branch in `<root>` is behind its remote. Pull it only when it holds no change of the user; otherwise say that it is behind.
