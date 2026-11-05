---
name: prd
description: Create a Linear milestone, or a Linear issue that is the specification for its own implementation, or update one after the plan changes. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "create an issue for this effort", "push this as an issue", "update issue ABC-123", "track this in an issue", or runs /pipe-skills:prd in such a project.
disable-model-invocation: false
---

# Linear issue as PRD

A Linear issue is the specification for its implementation: the design and the plan live in the issue, not in a document in the repository. Use the tools of the Linear MCP server; load them with ToolSearch first.

The project `CLAUDE.md` names the Linear team and project. If it names none, ask the user, and offer to add the line.

A project holds milestones, and a milestone holds issues. Do not use sub-issues: order issues with "blocked by" relations, and use a parent issue only when the group is itself a piece of work with its own success criteria.

## Draft first

Show the draft before you file. List each open decision with the options and your recommendation, and ask whether the scope is complete. File only after the user's go.

## Milestone

Sections: **Description** (one line), **Goal**, **Business impact**, **Success criteria**, **Risks**. Set the target date. Its issues are its plan.

## Issue

The case, written when the issue is planned: **Description** (one line), **Goal**, **Business impact**, **Success criteria** (how you prove it), **Risks**.

The design, added when the work starts: **State** (what exists today), **Options** (when there is more than one path), **Plan** (the steps in order, which `pipe-skills:implement` commits one at a time), **Context** (what else a reader needs).

Drop a section that holds nothing. File with `save_issue`: the team, the project, the milestone, `assignee: "me"`, state `Todo`, and its "blocked by" relations. Give the identifier and the URL, and offer to run `pipe-skills:implement`.

## Update

When the plan changes, rewrite the description to the current proposal only, with `pipe-skills:final-state`, and add a comment with the change and its reason.

## Close

`/pipe-skills:ship` closes the issue after the merge. To close it by hand, first ask the user: "do you think we are ready to close this issue?"

Write each paragraph or bullet as one line, with real newlines, not `\n` escapes.
