---
name: autonomous-implement
description: Implement a Linear issue and ship it with no stop for the user. Runs `implement` and then `ship`, and replaces each point where they ask or wait with a recorded decision. Use only when the user runs /autonomous-implement or says "implement and ship ABC-123 on your own".
disable-model-invocation: true
---

# Implement and ship a Linear issue autonomously

This skill does not repeat `implement` or `ship`. Both sit beside this skill: `../implement/SKILL.md` and `../ship/SKILL.md`, relative to the base directory of this skill. It runs them in sequence and overrides only the points where they ask the user or wait for a go. Every other rule of those two skills applies as written.

The call of this skill is the authorization to push, to open and merge the pull request, to set the issue to `Done`, and to delete the branch and the worktree, for this one issue only. It does not authorize a version bump, a tag, or a release target.

## 1. Implement

Read `implement` and follow it, with these overrides:

- **An unclear plan.** Do not stop for `advise`. When the issue settles the goal but not a choice, take the option that changes the least and that you can reverse most easily, record it in a comment on the issue with `save_comment` (the choice, the options you rejected, and why), and continue. Stop only when the issue does not state what to build: then change nothing, and report why.
- **A choice before you start.** Do not ask. Decide by the same rule, and record it the same way.
- **The review rounds.** This replaces the limit of three rounds of `implement` step 4, which stops a review that converges. The bar of step 4 stays as written: fix every blocker and every real bug or feature of high value in the branch, and drop the rest. Continue to review while the rounds converge: every blocker of the last round is fixed and validated, and no new review reports again a blocker that an earlier fix claimed to repair. A fix that no reviewer has read never ships, so the commit that fixes the last blockers always gets one more round. Stop at the merge gate when a blocker comes back after its fix, or when round five still finds a blocker. A limit of three rounds stops good work: three rounds can find five different blockers, each fix validated, and leave the last fix unread.
- **The merge gate.** Add the merge-gate comment as `implement` says, and do not stop there. Continue to step 2 only when the last review returns no blocker. When the review rounds stop with a blocker open, stop at the merge gate, leave the issue `In Review`, and report.

## 2. Ship

`ship` has `disable-model-invocation: true`, so the Skill tool cannot load it. Read its file and follow it, with these overrides:

- **Confirm.** Do not wait for a go. State the plan in the report instead.
- **Rebase.** Rebase without a go when the branch holds only the commits of this run. When it holds a commit of another author, stop and report.
- **Pull request.** Mark the draft ready with `gh pr ready <n>`. Watch the required checks with one background watcher (`gh pr checks <n> --watch`), never with a foreground sleep. Merge only when they pass. When a check fails, fix it in the worktree, commit, push, and watch again, at most three times; then stop and report.
- **Target branch.** Pull the target branch from its remote, when one exists, before the squash merge.

These `ship` guards stay hard stops, because they protect work that this run did not make: an uncommitted change in the worktree or on the target branch, and a local commit that the merge does not hold. Stop, show what you found, and propose the repair.

## 3. Report

One report at the end, and none on the way. Give:

- The result first: shipped, stopped at the merge gate, or stopped before the work.
- The decisions you made in place of the user, each with a link to its issue comment.
- What you built, and what the validation showed.
- What the reviews found, the Linear issues you filed or added a case to, and the count of deferred findings that stay only in the comment.
- The merge commit, the closed issue, and the removed worktree.
