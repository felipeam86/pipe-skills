---
name: assess
description: Judge whether one Linear or GitHub issue in Backlog or Todo still matches the code and its goal, and give a verdict with the evidence and the change to make. Changes nothing. For a project whose CLAUDE.md names where it tracks work. Use when the user says "is ABC-123 still relevant?", "assess #42", "has this issue drifted?", "is this PRD stale?", or runs /pipe-skills:assess in such a project.
disable-model-invocation: false
---

# Assess an issue

An issue that waits can drift from the code that it specifies. Give a verdict on one issue in `Backlog` or `Todo`, with the evidence. Change no file, post no comment, and change nothing in the tracker: `pipe-skills:sweep` applies a verdict after the user approves it. For an issue in another state, say that it is out of scope, and stop.

The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says.

## Read

- **Read an issue**, with its comments and the date it was created, and **Find the blockers**.
- The base of the check is the commit SHA of the last review comment of `pipe-skills:sweep`, which starts with `**Assessed**`. Without one, the base is the date the issue was created.
- The checked branch `<default>` is the default branch of the remote: `origin/HEAD`, or `origin/<name>` with the name from `git remote show origin` when `origin/HEAD` is missing. Run `git fetch origin` first, unless the skill that runs you already did. Without a remote, check the local default branch.

## Evidence

Each check gives facts with their proof: a path, a commit SHA, a pull request, or an issue.

1. **Names.** Each file, directory, function, command, or module that the issue names as existing still exists, with `git ls-files` and `git grep` on `<default>`. A path that the plan says to create is missing until the work is done, and that is not drift. When the issue names nothing, search by the concepts of its goal, and say that the evidence is weaker.
2. **Changes.** The commits since the base on the named paths: `git log <sha>..<default> -- <paths>`, or `git log --since=<YYYY-MM-DD> <default> -- <paths>`. Read each one, and say what it changed in the facts of **State** and in the steps of **Plan**.
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

Start with the verdict and one line of reason. Then **The code says**, **Your call**, **Proposed change**, and the checked commit SHA with the paths you checked. Run alone, end with the offer to apply the verdict with `/pipe-skills:sweep <identifier>`. Run by another skill, give the report in the form that its prompt asks for.
