---
name: ship
description: Close out a Linear issue whose branch is merged or ready to merge. Rebase, squash merge, set the issue to Done, file only the out-of-scope findings that earn an issue, remove the worktree, delete the branch, and refresh the local git state. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "I merged it", "update my local git", "clean up the worktree", "wrap this up", "close this out", or runs /pipe-skills:ship in such a project.
disable-model-invocation: true
---

# Ship a Linear issue

Use the tools of the Linear MCP server; load them with ToolSearch first. Read the branch and the target branch from the user's argument, else from the merge-gate comment on the issue, else from `gh pr view`.

Read the final verdict in the merge-gate comment. When it is not ready, or no merge-gate comment exists, say so in the plan and do not merge without a go from the user.

Run the merge, the cleanup and the checkout from the main checkout, not from the worktree, because git refuses a branch that another worktree holds.

Report the state and the plan first. Wait for a go before a step that can lose work: an unpushed commit, an uncommitted change, or a rebase. Then run the steps that still apply:

1. Rebase the branch onto the target branch, if it is behind.
2. Squash merge: `gh pr merge <n> --squash`, or without a pull request `git merge --squash <branch>` and a commit titled `<ABC-123>: <issue title>` whose body keeps the step messages.
3. Set the issue to `Done`, and add a comment with the merge commit and the findings that the merge-gate comment lists.
4. File a follow-up issue only for an out-of-scope finding that is a reproduced bug, a broken `CLAUDE.md` rule, or a feature of high value. Before you file, add the case to an open issue with the same cause, if there is one. File nothing when the closed issue is itself a follow-up. Start each new issue with `Follow-up from the review of <ABC-123>.` and link it to the closed issue.
5. Leave the worktree with ExitWorktree when the session is in it, remove it, and run `git worktree prune`. Then delete the branch, local and remote.
6. Check out the target branch, and pull it when a remote exists.

Report the merge commit, the closed issue, and the issues you filed or added a case to. Never use `--no-verify`, and never force-push a shared branch.
