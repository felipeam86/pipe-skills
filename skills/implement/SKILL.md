---
name: implement
description: Implement a Linear issue end to end. Sets up the worktree and branch, works in committed steps, keeps the issue at its final state, reviews with a fresh reviewer until the review is clean, and stops at the merge gate. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "implement issue ABC-123", "work on ABC-123", "build this issue", or runs /implement or /implement-issue in such a project.
disable-model-invocation: false
---

# Implement a Linear issue

The loop from a written Linear issue to a branch that is ready to merge.

The issue is the specification. The branch, and its pull request when there is one, is the proposal. Both state the design that holds now, never the one they replaced.

Use the tools of the Linear MCP server. Load them with ToolSearch first.

## Pull request or local branch

Read `git remote -v` first.

- **A GitHub remote exists.** Push the branch and open a draft pull request early, so the description can hold the current state from the first step. Attach its URL to the issue with `create_attachment`.
- **No remote.** There is no pull request. The Linear issue holds the record, and the reviewer reads the branch diff against its target.

## 1. Set up

- Read the issue in full: `get_issue` for the description and `gitBranchName`, `list_comments` for the history. Read every `CLAUDE.md` that governs the files it touches.
- If the plan in the issue is not clear enough to implement, stop and use `advise`. Do not guess a specification.
- Derive the target branch from the repository, not from a constant. It is the branch the user is on, and it may not be `main`.
- Create a worktree for the issue, inside the repository, on the branch that `gitBranchName` names. Use EnterWorktree.
- Set the issue state to `In Progress`.

Ask the user before you start only when a choice would change the work in a way the issue does not settle. Otherwise start.

## 2. Work in steps

Take the plan from the issue, one step at a time.

For each step:

1. Implement it.
2. Validate it, by the rule the repository states for that kind of artefact. Run the notebook. Look at the chart. Run the tests. Open the view. Read the artefact back.
3. Commit it, with a message that starts with the issue identifier (`ABC-123: …`) and says what you did and what the validation found. These messages become the record on the target branch, so the failed first attempt and its correction belong here.

Do not batch the steps into one commit at the end.

## 3. Keep the record at its final state

Two triggers, and only these two.

**A discovery contradicts the issue**, or the plan changes. Then, at that moment:
- Rewrite the issue description with `save_issue` to the current proposal only. No rationale for the change, no trace of what it replaced.
- Add a comment with `save_comment` that holds the change and the thinking behind it.
- Rewrite the pull request description the same way, if there is one.

**A step is done and the plan holds.** Then write nothing. A progress tick is noise.

Use `final-state` for the rewrites. The description is the clean present; the comment is the history.

## 4. Review with a reviewer that did not write the code

When the plan is complete, review. Never review your own work from the context that produced it.

- Spawn a fresh reviewer subagent on the most capable model you have. Give it the issue identifier and the pull request number, or, with no pull request, the worktree path, the branch and the target branch. Nothing else. It must read the issue and the diff itself.
- The reviewer applies the `review` contract: verdict first, then blockers, then defer, then notes. It proves each finding concrete before it reports it.
- Fix in this branch, at once, every blocker and every deferred finding that is a real bug or a feature of high value. This is the default for a deferred finding, not the exception: a follow-up issue costs a reading and a loop, and the context to fix it is here now. For example, a link that kept the saved filters that hid its own content, and a load failure stuck on "loading…", are fixed in the branch.
- Drop every other finding, and say in one line why it does not matter. An edge case that no real data and no likely input reaches, a cosmetic choice, or a matter of wording is dropped, whatever the reviewer graded it.
- For a finding you reject, say why in one line, from the code. Do not accept a finding because a reviewer stated it, and do not drop one because it is inconvenient.
- Commit the fixes and review again, with a new reviewer.

Repeat until a review returns no blocker and no real bug. Stop after three rounds whatever the result, and report what is still open. A loop that cannot converge is a signal, not a failure to hide.

The bar holds when the user lifts the limit of rounds or asks you to act on every finding: each round of fixes invites a new round of edge cases, so the loop ends when a review finds no real bug, not when it finds nothing. After eleven rounds, reviewers still report shapes that no data has.

## 5. Stop at the merge gate

Do not merge. Set the issue state to `In Review`, and add one comment to the issue with the branch, the target branch, the final review verdict and the deferred findings that are still open. `ship` reads this comment. Then report:

- The verdict, first.
- What you built, in a few lines.
- What the validation showed, with the evidence.
- What the reviews found, what you fixed in the branch, and what you dropped.

## Guards

- One issue, one worktree, one branch, at most one pull request.
- Do not widen the scope. An idea that the issue does not name, and that no review raised, is not a commit. It becomes a new Linear issue in the same project only when it is a real bug or a feature of high value. Otherwise it stays in the merge-gate comment.
- Do not narrow it either. If a step is blocked, finish every other step and say plainly which one you left and why.
- Delegate the wide reading to subagents, so the main context stays clean. Do the writes yourself, in sequence.
