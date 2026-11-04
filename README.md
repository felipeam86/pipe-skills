# pipe-skills

A Claude Code plugin that runs a spec-to-ship pipeline on Linear. A Linear issue is the specification. Claude implements it in validated, committed steps, has a fresh reviewer check the work until the review is clean, and stops at the merge gate. When you are ready, Claude squash-merges the work and closes the issue. It can also work through a whole `Todo` queue on its own, one issue after another.

The plugin also has the working-style skills that the pipeline relies on: give an opinion without changing anything, interview you for a spec, keep documents at their final state, and turn corrections into lasting rules.

## Install

```
/plugin marketplace add <owner>/pipe-skills
/plugin install pipe-skills@pipe-skills
```

## Setup

- The [Linear MCP server](https://linear.app/docs/mcp), connected and authenticated: `claude mcp add --transport http linear-server https://mcp.linear.app/mcp`.
- The `gh` CLI, authenticated, when the repository has a GitHub remote. Without a remote, the pipeline works on local branches, and the Linear issue holds the record.
- One line in the project `CLAUDE.md` that names where the work lives:

  ```
  - Track work in the Linear project **Acme Web** of the team `ACM`, never in GitHub issues.
  ```

## Skills

The pipeline:

| Skill | What it does | Example |
|---|---|---|
| `prd` | Files a Linear issue or milestone that is the specification of its own implementation, or updates one after the plan changes. | `/pipe-skills:prd file an issue for the CSV export we just discussed` |
| `implement` | Implements one issue in a worktree, commits each validated step, reviews with fresh reviewers (at most three rounds), and stops at the merge gate. | `/pipe-skills:implement ACM-42` |
| `review` | Reviews a pull request or a branch, and gives a merge verdict first. | `/pipe-skills:review 118` |
| `ship` | Rebases, squash-merges, closes the issue, files only the follow-ups that earn an issue, and cleans up the branch and the worktree. | `/pipe-skills:ship ACM-42` |
| `autonomous-implement` | Implements and ships one issue with no stop for the user (at most five review rounds), and records each decision that it makes for you as an issue comment. | `/pipe-skills:autonomous-implement ACM-42` |
| `autonomous-loop` | Implements and ships every `Todo` issue of a project, from the highest priority, one fresh subagent per issue. | `/pipe-skills:autonomous-loop` |

Working style:

| Skill | What it does | Example |
|---|---|---|
| `advise` | Gives an opinion or a plan, and changes no file. | `/pipe-skills:advise is this cache layer worth it?` |
| `interview` | Interviews you in depth to write a specification. | `/pipe-skills:interview the onboarding redesign` |
| `final-state` | Edits a document, an issue, or a comment so that it states only the settled decision, and keeps the rationale. | `/pipe-skills:final-state docs/design.md` |
| `promote-rule` | Turns a correction you just made into a durable rule, at the level it governs. | `/pipe-skills:promote-rule` |

## Review bar

A reviewer finds more edge cases in each round. The pipeline ends the loop when a review finds no real bug, not when it finds nothing. Claude fixes every blocker, every real bug, and every feature of high value in the same branch. It drops the rest with a one-line reason, and it files a follow-up issue only for a reproduced bug or a feature of high value that has a new root cause.

## Credits

- `interview` is the [interview prompt](https://x.com/trq212/status/2005315275026260309) by Thariq Shihipar.
- Many of the ideas behind this plugin come from [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock and [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan.

The plugin is under the MIT License, see `LICENSE`.
