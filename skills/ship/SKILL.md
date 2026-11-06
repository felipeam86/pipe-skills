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
5. Leave the worktree with ExitWorktree when the session is in it, remove it, and run `git worktree prune`. Then delete the branch:
   - Local: `git branch -D <branch>`, because a squash merge leaves the branch unmerged for git. Delete it only when `git rev-list <head>..<branch>` is empty, where `<head>` is the `headRefOid` of the pull request, or the commit you merged without one. Else keep the branch and report its commits that the merge does not hold.
   - Remote: `git push origin --delete <branch>` when `git ls-remote --heads origin <branch>` still lists it, because GitHub or another person can delete it first.
6. Update the local git state from the main checkout, when a remote exists. Run `git fetch --prune origin`, which also removes the ref `origin/<branch>` of a remote branch that someone else deleted. Then bring the target branch to `origin/<target>` by fast-forward only:
   - When the main checkout is on the target branch, or is on another branch with no uncommitted change, check out the target branch and run `git pull --ff-only`. Git refuses an update that overwrites an uncommitted change, so the change stays.
   - When the main checkout is on another branch and has uncommitted changes, keep that branch, and run `git fetch origin <target>:<target>`, which fast-forwards a branch that no checkout holds.
   - When the fast-forward fails because the target branch diverged from its remote, do not merge, rebase, or reset. Report the commits on each side.

   Without a remote, check out the target branch.
7. Check the end state, and report each check with its result:
   - With a remote, `git rev-parse <target>` and `git rev-parse origin/<target>` give the same commit.
   - `git branch --list <branch>` gives nothing, and with a remote, `git branch -r --list origin/<branch>` and `git ls-remote --heads origin <branch>` give nothing.
   - List the local branches whose upstream is gone, which `git branch -vv` marks `: gone]`. Do not delete them: such a branch can hold work that is not on the remote.

   When a check fails, name the step that left it and the reason.

Report the merge commit, the closed issue, the issues you filed or added a case to, and the checks of step 7. Never use `--no-verify`, and never force-push a shared branch.
