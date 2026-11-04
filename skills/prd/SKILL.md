---
name: prd
description: Create a Linear milestone, or a Linear issue that is the specification for its own implementation, or update one after the plan changes. For a project whose CLAUDE.md names a Linear team and project. Use when the user says "create an issue for this effort", "push this as an issue", "update issue ABC-123", "track this in an issue", or runs /prd or /issue-prd in such a project.
disable-model-invocation: false
---

# Linear issue as PRD

A Linear issue is the specification for its implementation. The design and the plan live in the issue itself. Never commit a separate design document to the repository, and never file a GitHub issue for the same work.

Use the tools of the Linear MCP server. Load them with ToolSearch first.

## Where the issue goes

The project `CLAUDE.md` names the Linear team and the Linear project. Read them from there. If it names none, ask the user, and offer to add the line to that `CLAUDE.md`.

## Two levels: milestones and issues

A Linear project holds milestones, and each milestone holds issues. An issue is the unit of work and the specification that `implement` executes. Never use sub-issues. A relation between issues states an order: "blocked by" when one issue cannot start or finish before another. The milestone groups the issues; a parent issue is used only when the group is itself a piece of work with its own success criteria. A flat list with explicit order keeps one place for each plan, where a tree hides the plan of a child under the case of its parent.

## Create a milestone

Write these sections in the milestone description, and set its target date.

- **Description** — one line.
- **Goal** — 1–2 sentences: the outcome that the milestone proves.
- **Business impact** — why the work matters to the business.
- **Success criteria** — the measurable definition of done.
- **Risks** — the foreseeable risks and blockers.

Its issues are its method, so a milestone has no plan section.

## Create an issue

Write these sections in the description, in two parts. Drop a section only when it holds nothing.

The case, written when the issue is planned:

- **Description** — one line, so the issue reads in a list.
- **Goal** — 1–2 sentences: the hypothesis or the outcome we expect to prove.
- **Business impact** — why the work matters to the business. One line is enough for a technical issue.
- **Success criteria** — the measurable definition of done and how it is proved: a KPI, an AUC delta, a test, a rehearsal on real compute.
- **Risks** — the foreseeable risks, and what blocks us now. A blocker that is another issue is a "blocked by" relation, not text.

The design, written when the work starts. A discovery issue may have none.

- **State** — what exists today in the code, the data or earlier work.
- **Options** — the paths we can take, and the one we propose. Drop it when there is one path.
- **Plan** — the steps, in order. `implement` commits one step at a time.
- **Context** — everything else you hold that a reader needs. Include what you carry in memory from earlier sessions.

An issue filed at planning time holds the case only. Write its design with an update when someone picks it up.

Before you file it, ask whether the scope is complete. The user often adds one more item after reading a draft, so show the draft first for anything large.

File it with `save_issue`: the team and the project from `CLAUDE.md`, the milestone, `assignee: "me"`, state `Todo`, and its "blocked by" relations. Give the user the identifier and the URL.

## Update

A change to the plan updates the issue at once. Two steps, always both:

1. **Rewrite the description** with `save_issue` to the current state of the proposal only. No rationale for the change. No trace of what it replaced. A reader who arrives today must see one clean proposal.
2. **Add a comment** with `save_comment` that holds the change and the thinking behind it. This is where the history lives.

## Close

Set the state to `Done` by hand after the branch merges into its target. Nothing closes the issue for you.

Before you close, ask the user. The wording is "do you think we are ready to close this issue?", not a statement. `ship` closes it as part of its sequence, because the user invokes it.

## Writing rules

- Never hard-wrap a line. Write each paragraph or bullet as one line, and let the editor wrap it.
- Send real newlines in the markdown, not `\n` escapes.
- Keep the reasoning and the plan. Remove the decision history. See `final-state`.
- Bullets, not a two-column table of pros and cons.
