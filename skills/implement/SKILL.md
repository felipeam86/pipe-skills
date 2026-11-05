---
name: implement
description: Implement a Linear issue end to end. Sets up the worktree and branch, works in committed steps, keeps the issue at its final state, reviews with a fresh reviewer until the review is clean, and stops at the merge gate. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "implement issue ABC-123", "work on ABC-123", "build this issue", or runs /pipe-skills:implement in such a project.
disable-model-invocation: false
---

# Implement a Linear issue

The issue is the specification. Use the tools of the Linear MCP server; load them with ToolSearch first.

## Set up

- Read the issue with `get_issue` and `list_comments`, and every `CLAUDE.md` that governs the files it touches.
- The target branch is the branch the user is on.
- Create the worktree with EnterWorktree and the issue identifier as its `name`, then run `git fetch origin` and `git checkout -B <gitBranchName> origin/<target>` in it. Set the issue to `In Progress`.
- With a GitHub remote, push the branch, open a draft pull request, and attach it to the issue with `create_attachment`. Without one, the issue holds the record.

## Work in steps

For each step of the plan: implement it, validate it by the rule of the repository, and commit it with a message that starts with the issue identifier and says what the validation found.

When a discovery changes the plan, rewrite the issue description and the pull request description to the current proposal with the `pipe-skills:final-state` skill, and put the change and its reason in an issue comment.

## Review

Start a fresh reviewer subagent on the most capable model you have, with the `pipe-skills:review` skill. Give it the issue identifier and the pull request number, or the worktree path, the branch and the target branch.

You decide what this branch fixes. Fix every blocker, and every in-scope finding unless its cost is too high for its value. Do not fix out-of-scope findings: keep them for the merge-gate comment. Drop a finding you disagree with, and say why in one line. Commit the fixes and start a new reviewer.

Repeat until a review finds no blocker and no in-scope bug. Stop and report when a blocker comes back after its fix, or after 10 rounds.

## Merge gate

Do not merge. Set the issue to `In Review`, and add a comment with the branch, the target branch, the final verdict, the out-of-scope findings, and the in-scope findings you did not fix with their reason. Report the verdict first, what you built, what the validation showed, and whether a reviewer read the last commit.
