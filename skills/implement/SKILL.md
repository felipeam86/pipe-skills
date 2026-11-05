---
name: implement
description: Implement a Linear or GitHub issue end to end. Sets up the worktree and branch, works in committed steps, keeps the issue at its final state, reviews with a fresh reviewer until the review is clean, and stops at the merge gate. For a project whose CLAUDE.md names where it tracks work. Use when the user says "implement issue ABC-123", "implement issue #42", "work on ABC-123", "build this issue", or runs /pipe-skills:implement in such a project.
disable-model-invocation: false
---

# Implement an issue

The issue is the specification. The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says.

## Set up

- Read the issue with its comments, and every `CLAUDE.md` that governs the files it touches.
- The target branch is the branch the user is on.
- Create the worktree with EnterWorktree and the worktree name of the tracker file as its `name`. Name the branch, then run `git fetch origin` and check it out in the worktree: `git checkout -B <branch> origin/<branch>` when it is on the remote, so that the commits of an earlier run stay, else `git checkout -B <branch> origin/<target>`. Without a remote, `git checkout -B <branch> <target>`, or keep the local branch when it exists. Set the issue to `In Progress`.
- With a GitHub remote, push each commit of the run, a step or a fix, so that the reviewer, the merge, and a later run see it. After the first push, when the branch has no pull request, open a draft pull request whose title starts with the issue identifier, because GitHub refuses a pull request with no commit, and link it to the issue. Without a remote, the issue holds the record.

## Work in steps

For each step of the plan: implement it, validate it by the rule of the repository, and commit it with a message that starts with the issue identifier and says what the validation found.

When a discovery changes the plan, rewrite the issue description and the pull request description to the current proposal with the `pipe-skills:final-state` skill, and put the change and its reason in an issue comment.

## Review

Start a fresh reviewer subagent on the most capable model you have, with the `pipe-skills:review` skill. Give it the issue identifier and the pull request number, or the worktree path, the branch and the target branch.

You decide what this branch fixes. Fix every blocker, and every in-scope finding unless its cost is too high for its value. Do not fix out-of-scope findings: keep them for the merge-gate comment. Drop a finding you disagree with, and say why in one line. Commit the fixes and start a new reviewer.

Repeat until a review finds no blocker and no in-scope bug. Stop and report when a blocker comes back after its fix, or after 10 rounds.

## Merge gate

Do not merge. Set the issue to `In Review`, and add a comment with the branch, the target branch, the final verdict, the out-of-scope findings, and the in-scope findings you did not fix with their reason. Report the verdict first, what you built, what the validation showed, and whether a reviewer read the last commit.
