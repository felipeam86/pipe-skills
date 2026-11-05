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
- Run `git fetch origin` once, here, so that the subagents do not fetch at the same time. `<default>` is the branch that `pipe-skills:assess` checks.
- Skip an issue that did not change since its last review: its last comment starts with `**Assessed**`, that comment holds the hash that **Hash the description** gives now, and `git log <sha>..<default> -- <paths>`, with the SHA and the paths of that comment, finds no commit. The hash catches an edit of the description, and the last comment catches a word of the user, which the edit date cannot tell apart from the review comment. Never skip an issue that the user names.
- State the scope in one line: the number of issues to assess, and the skipped issues with the date of their last review.

## Assess

Start one fresh subagent for each issue with the Agent tool, at most eight at a time, with the model of this session and the prompt below. Do not fork, so that each subagent starts clean. It only reads, so it needs no worktree. When one ends without its report, ask it for the report with SendMessage.

> Assess the issue `<identifier>` of `<root>`. Read `${CLAUDE_PLUGIN_ROOT}/skills/assess/SKILL.md` and the tracker file `<tracker file>`, and follow them. The origin is already fetched: do not fetch. Change no file and nothing in the tracker. End with this report and nothing more: the verdict and one line of reason; **The code says**, at most five bullets, each with its proof; **Your call**, one question or `none`; **Proposed change**, with the full new text of each section that changes for `drifted`; the checked commit SHA; the checked paths.

## Report

Report the verdicts in the conversation, in the form that suits the case: one numbered row for each issue (identifier, title, verdict, reason, proposed change) when the issues are many, and the full report of each issue when they are few. Put first the rows with a question for the user. Then ask which rows to apply, and wait. The user can approve a row, reject it, or change its verdict.

## Apply

For each approved row only:

1. Run the change of its verdict:
   - `current`: no change.
   - `drifted`: rewrite the description with the proposed text and `pipe-skills:final-state`, as the Update of `pipe-skills:prd` says.
   - `done`: **Close**.
   - `superseded`: **Cancel**, as a duplicate when the other issue holds the same work.
   - `obsolete`: **Cancel**.
   - `ask`: the verdict that the user's answer gives.
2. Then add the review comment, which the skip rule reads. For `drifted`, it is also the comment of the change and its reason. Its hash comes from **Hash the description** after the change, so that the skip rule reads the text the same way:

```
**Assessed** <YYYY-MM-DD>: `<verdict>`, on `<default>` at `<sha>`, description `<hash>`.
Paths: `<path>`, `<path>`.
<the code says, as bullets>
<the user's decision, quoted, when the row had a question>
```

A rejected row gets nothing. Report each row that you applied, with its link, and each row that failed with its reason.
