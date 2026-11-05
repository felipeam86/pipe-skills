---
name: prd
description: Create an outcome (a milestone, or a Linear project of an initiative), or an issue that is the specification for its own implementation, or update one after the plan changes, in Linear or GitHub Issues. For a project whose CLAUDE.md names where it tracks work. Use when the user says "create an issue for this effort", "push this as an issue", "update issue ABC-123", "update issue #42", "track this in an issue", or runs /pipe-skills:prd in such a project.
disable-model-invocation: false
---

# Issue as PRD

An issue is the specification for its implementation: the design and the plan live in the issue, not in a document in the repository.

The project `CLAUDE.md` names where it tracks work. Read the tracker file for it, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and run each operation below as that file says. If the project `CLAUDE.md` names no tracker, stop and offer `/pipe-skills:setup`.

An outcome holds issues, and the tracker file says what an outcome is. Order issues with "blocked by" relations. Link issues as children of a parent issue only when the group is itself a piece of work with its own success criteria, with the parent link of the tracker file.

## Draft first

Show the draft before you file. Read the outcomes with their descriptions, put each issue in the outcome whose goal it serves, and name that outcome in the draft with a one-line reason. Propose a new outcome only for a goal that no outcome covers, with its own success criteria and more than one issue. Ask the user when two outcomes fit, when none fits, or when the work covers more than one. List each open decision with the options and your recommendation, and ask whether the scope is complete. File only after the user's go.

## Outcome

Sections: **Description** (one line), **Goal**, **Business impact**, **Success criteria**, **Risks**. Set the target date. Its issues are its plan.

## Issue

The case, written when the issue is planned: **Description** (one line), **Goal**, **Business impact**, **Success criteria** (how you prove it), **Risks**.

The design, added when the work starts: **State** (what exists today), **Options** (when there is more than one path), **Plan** (the steps in order, which `pipe-skills:implement` commits one at a time), **Context** (what else a reader needs).

Drop a section that holds nothing. File the issue in its outcome, assigned to the user, in state `Todo`, with its priority and its "blocked by" relations, so that `pipe-skills:autonomous-loop` takes the issues in the correct order. Give the identifier and the URL, and offer to run `pipe-skills:implement`.

## Update

When the plan changes, rewrite the description to the current proposal only, with `pipe-skills:final-state`, and add a comment with the change and its reason.

## Close

`/pipe-skills:ship` closes the issue after the merge. To close it by hand, first ask the user: "do you think we are ready to close this issue?"

Write each paragraph or bullet as one line, with real newlines, not `\n` escapes.
