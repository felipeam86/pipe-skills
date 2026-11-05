---
name: assess
description: Judge whether one Linear or GitHub issue in Backlog or Todo still matches the code and its goal, and give a verdict with the evidence and the change to make. Changes nothing. For a project whose CLAUDE.md names where it tracks work. Use when the user says "is ABC-123 still relevant?", "assess #42", "has this issue drifted?", "is this PRD stale?", or runs /pipe-skills:assess in such a project.
disable-model-invocation: false
---

# Assess an issue

An issue that waits can drift from the code that it specifies. Give a verdict on one issue in `Backlog` or `Todo`, with the evidence. Change no file except by the pull of the reference branch, post no comment, and change nothing in the tracker: the session or the skill that ran you applies the verdict after the user approves it, as **Apply a verdict** says. For an issue in another state, say that it is out of scope, and stop.

The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says.

## Read

- **Read an issue**, with its comments and the date it was created, and **Find the blockers**.
- The base of the check comes from the last review comment (below). Its SHA is the base when its branch is `<ref>` and `git merge-base --is-ancestor <sha> <ref>` succeeds. Else its date is the base, because a review on another branch, or a SHA that the repository no longer holds, says nothing about the commits of `<ref>`. Without a review comment, the base is the date the issue was created.
- The reference branch `<ref>` is the branch you stand on, because the user runs you from the branch that the issue builds on, which can differ from the default branch of the remote. A skill that runs you can name another one. First pull it with `git pull --ff-only`, unless the skill that runs you already did, so that it holds the new commits of its remote. When the pull fails, say so, and check the branch as it is.

## Evidence

Each check gives facts with their proof: a path, a commit SHA, a pull request, or an issue.

1. **Names.** Each file, directory, function, command, or module that the issue names as existing still exists, with `git ls-files` and `git grep` on `<ref>`. A path that the plan says to create is missing until the work is done, and that is not drift. When the issue names nothing, search by the concepts of its goal, and say that the evidence is weaker.
2. **Changes.** The commits since the base on the named paths: `git log <sha>..<ref> -- <paths>`, or `git log --since=<YYYY-MM-DD> <ref> -- <paths>`. Read each one, and say what it changed in the facts of **State** and in the steps of **Plan**.
3. **Work already done.** Read the code against the **Success criteria**. Search the merged pull requests (`gh pr list --state merged --search <terms>` with a GitHub remote) and the closed issues for the same goal.
4. **Goal.** When the issue has an outcome, it is still open (**List the outcomes**). Each blocker is still open, or it was closed or canceled.
5. **Overlap.** An open issue of **List the backlog** with the same goal.

## Verdict

Give one verdict:

| Verdict | When | Proposed change |
|---|---|---|
| `current` | The issue still matches the code. | A review comment only. |
| `drifted` | The goal holds, but a fact or a step is wrong. | The new text of each section that changes. |
| `done` | The code already meets the success criteria. | Close, with the commit or the pull request that did the work. |
| `superseded` | Another issue or a design change replaces it. | Cancel, with the issue that replaces it. |
| `obsolete` | The goal no longer applies. | Cancel, with the reason. |
| `ask` | The code cannot decide between two verdicts. | One question for the user. |

The code can prove drift, but it cannot prove that the user still wants the goal. Keep these two parts apart: **The code says** holds only facts with their proof, and **Your call** holds the question that only the user can answer, or `none`. Give `obsolete` only on a fact, such as a removed module or a closed outcome. When only the business value is in doubt, give `ask`.

## Report

Start with the verdict and one line of reason. Then **The code says**, **Your call**, **Proposed change**, and the checked commit SHA with the paths you checked. Run alone, end with one question: may the session apply the proposed change and post the review comment? Run by another skill, give the report in the form that its prompt asks for.

## Apply a verdict

These steps never run in your own run. A session or `pipe-skills:sweep` runs them, only after the user's go:

1. Run the change of the verdict:
   - `current`: no change.
   - `drifted`: rewrite the description with the proposed text and `pipe-skills:final-state`, as the Update of `pipe-skills:prd` says.
   - `done`: **Close**.
   - `superseded`: **Cancel**, as a duplicate when the other issue holds the same work.
   - `obsolete`: **Cancel**.
   - `ask`: the verdict that the user's answer gives.
2. Then add the review comment, last, so that the next check reads its base from it. For `drifted`, it is also the comment of the change and its reason.

## Review comment

The hash comes from **Hash the description** after the change:

```
**Assessed** <YYYY-MM-DD>: `<verdict>`, on `<ref>` at `<sha>`, description `<hash>`.
Paths: `<path>`, `<path>`.
<the code says, as bullets>
<the user's decision, quoted, when there was a question>
```
