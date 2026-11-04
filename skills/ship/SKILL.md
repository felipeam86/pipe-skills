---
name: ship
description: Close out a Linear issue whose branch is merged or ready to merge. Rebase, squash merge, set the issue to Done, file only the deferred findings that earn an issue, delete the branch, remove the worktree, and refresh the local git state. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "I merged it", "update my local git", "clean up the worktree", "wrap this up", "close this out", or runs /ship in such a project.
disable-model-invocation: true
---

# Ship a Linear issue

One command for the close-out sequence that follows `implement`.

Use the tools of the Linear MCP server. Load them with ToolSearch first.

## Derive, never assume

Read every value from the repository and from the issue. Do not hold a branch name, a repository name, or a worktree path in this file.

- Issue: the identifier the user gives, or the one in the branch name.
- Branch and target branch: the merge-gate comment that `implement` adds to the issue. With a pull request, `gh pr view <n> --json baseRefName,headRefName` is the authority. The target is often not `main`.
- Pull request: the attachment on the issue, if there is one.
- Linear team and project, for new issues: the project `CLAUDE.md`.
- Worktree: `git worktree list`.

## Sequence

Run only the steps that still apply. Report the state first, then act.

1. **Read the state.** `get_issue` and `list_comments` on the issue, `git worktree list`, `git status` in the worktree, and `git log <target>..<branch>`. With a pull request, also `gh pr view <n> --json number,title,state,baseRefName,headRefName,mergedAt,body`.
2. **Confirm.** State the plan in one line per step, with the real issue, branch and worktree names. Wait for a go if any step destroys work: an unpushed commit, a dirty worktree, or a rebase.
3. **Rebase** the branch onto the target branch, if it is not merged yet and is behind.
4. **Squash merge.** One issue becomes one commit on the target branch. Never merge with a merge commit.
   - With a pull request: `gh pr merge <n> --squash`.
   - With no pull request: on the target branch, `git merge --squash <branch>`, then commit with the title `<ABC-123>: <issue title>` and a body that keeps the step messages of the branch, since they are the record of the work.
5. **Close the issue.** Set its state to `Done` with `save_issue`, and add a comment with the merge commit.
6. **Record the deferred findings.** Record every finding that is still open in the comment of step 5. A follow-up issue costs a reading and a loop, so the comment is the default, and an issue is the exception. File an issue only for a finding that passes all three rules:
   - **It earns an issue.** It is a real bug that you reproduced, a break of a rule of the project `CLAUDE.md`, or a feature of high value that the user would ask for. An edge case that no one reproduced, a cosmetic choice, or a case of a choice that the issue already made stays in the comment only.
   - **It is a new root cause.** Read the open issues of the project first. When one has the same cause, add the new case to it, and do not file. Findings of this review that share a cause become one issue.
   - **The closed issue is not itself a follow-up.** When the description of the closed issue says that it came from the review of another issue, file nothing: its findings stay in the comment for the user to read.
   File in the same team and project, link the issue to the closed issue, and start its description with `Deferred from the review of <ABC-123>.`, which the third rule reads. Without these rules, follow-ups breed follow-ups: four follow-ups of one issue filed six more about rare browser-state edge cases, three of the six had one cause, and a cleanup closed eight of twenty filed issues.
7. **Delete the branch**, local, and remote when it exists.
8. **Remove the worktree.** `git worktree remove <path>` and then `git worktree prune`.
9. **Refresh the local state.** Check out the target branch. If a remote exists, pull it and prune the remote references.
10. **Report.** Give the merge commit, the closed issue, the removed worktree, the new issues you filed, and the issues you added a case to.

## Guards

- Never use `--no-verify`.
- Never force-push a shared branch.
- If the local state holds a commit that the merge does not, stop. State what you found, propose the repair, and wait for a decision.
- If the worktree holds an uncommitted change, stop and show it.
- If the target branch holds an uncommitted change, stop and show it before the squash merge.
