---
name: sweep
description: Assess every Backlog and Todo issue of a project, or the issues the user names, with one fresh subagent for each issue, report the verdicts, and apply only the verdicts the user approves, as a review comment, a rewrite, a close, or a cancel. Use only when the user runs /pipe-skills:sweep, or says "sweep the backlog", "check the backlog for stale issues", or "apply the verdict of ABC-123".
disable-model-invocation: true
---

# Sweep the backlog

You are the orchestrator. You do not judge an issue yourself. The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says.

Post no comment and change nothing in the tracker before the user approves the rows. This holds also when the user names one issue.

## Scope

- The issues the user names, in `Backlog` or `Todo`; name each other one and say that it is out of scope. Else every issue of **List the backlog**, in the scope of the tracker line.
- The reference branch `<ref>` is the branch you stand on. Pull it once, here, with `git pull --ff-only`, so that the subagents do not pull at the same time. When the pull fails, say so, and check the branch as it is.
- Skip an issue that did not change since its last review: its last comment is the review comment of `pipe-skills:assess`, that comment names `<ref>` as its branch, `git merge-base --is-ancestor <sha> <ref>` succeeds, the comment holds the hash that **Hash the description** gives now, and `git log <sha>..<ref> -- <paths>`, with the SHA and the paths of that comment, finds no commit. A review on another branch says nothing about `<ref>`. The hash catches an edit of the description, and the last comment catches a word of the user, which the edit date cannot tell apart from the review comment. Never skip an issue that the user names.
- State the scope in one line: the number of issues to assess, and the skipped issues with the date of their last review.

## Assess

Start one fresh subagent for each issue with the Agent tool, at most eight at a time, with the model of this session and the prompt below. Do not fork, so that each subagent starts clean. It only reads, so it needs no worktree. When one ends without its report, ask it for the report with SendMessage.

> Assess the issue `<identifier>` of `<root>`. Read `${CLAUDE_PLUGIN_ROOT}/skills/assess/SKILL.md` and the tracker file `<tracker file>`, and follow them. The reference branch is `<ref>`, already pulled: do not pull. Change no file and nothing in the tracker. End with this report and nothing more: the verdict and one line of reason; **The code says**, at most five bullets, each with its proof; **Your call**, one question or `none`; **Proposed change**, with the full new text of each section that changes for `drifted`; the checked commit SHA; the checked paths.

## Report

Report the verdicts in the conversation, in the form that suits the case: one numbered row for each issue (identifier, title, verdict, reason, proposed change) when the issues are many, and the full report of each issue when they are few. Put first the rows with a question for the user. Then ask which rows to apply, and wait. The user can approve a row, reject it, or change its verdict.

## Apply

For each approved row only, run **Apply a verdict** of `pipe-skills:assess`, which ends with the review comment that the skip rule reads. A rejected row gets nothing. Report each row that you applied, with its link, and each row that failed with its reason.
