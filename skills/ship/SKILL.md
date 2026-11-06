---
name: ship
description: Close out a Linear or GitHub issue whose branch is merged or ready to merge. Rebase, squash merge, set the issue to Done, file only the out-of-scope findings that earn an issue, remove the worktree, delete the branch, and refresh the local git state. For a project whose CLAUDE.md names where it tracks work. Use when the user says "I merged it", "update my local git", "clean up the worktree", "wrap this up", "close this out", or runs /pipe-skills:ship in such a project.
disable-model-invocation: true
---

# Ship an issue

The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says. Read the branch and the target branch from the user's argument, else from the merge-gate comment on the issue, else from `gh pr view`.

Read the final verdict in the merge-gate comment. When it is not ready, or no merge-gate comment exists, say so in the plan and do not merge without a go from the user.

Run the merge, the cleanup and the checkout from the main checkout, not from the worktree, because git refuses a branch that another worktree holds.

Report the state and the plan first. Wait for a go before a step that can lose work: an unpushed commit, an uncommitted change, or a rebase. Then run the steps that still apply:

1. Rebase the branch onto the target branch, if it is behind.
2. Squash merge: mark a draft pull request ready with `gh pr ready <n>`, then `gh pr merge <n> --squash --subject "<identifier>: <issue title> (#<n>)"`. Without a pull request, `git merge --squash <branch>` and a commit titled `<identifier>: <issue title>` whose body keeps the step messages.
3. Close the issue, and add a comment with the merge commit and the findings that the merge-gate comment lists.
4. File a follow-up issue only for an out-of-scope finding that is a reproduced bug, a broken `CLAUDE.md` rule, or a feature of high value. Before you file, add the case to an open issue with the same cause, if there is one. File nothing when the closed issue is itself a follow-up. Start each new issue with `Deferred from the review of <identifier>.` and link it to the closed issue.
5. Leave the worktree with ExitWorktree when the session is in it, remove it, and run `git worktree prune`.
6. Leave the local repository equal to the remote: the target branch at `origin/<target>`, and no local branch, remote branch, or stale remote-tracking ref of the shipped branch. Never lose a commit that the merge does not hold, and never touch an uncommitted change of the user. Without a remote, delete the local branch and check out the target branch.

Report the merge commit, the closed issue, the issues you filed or added a case to, and what step 6 could not clean, with the reason. Never use `--no-verify`, and never force-push a shared branch.
