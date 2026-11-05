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
  - Track work in the Linear project **Acme Web** of the team `ACM`.
  ```

## Skills

The pipeline:

| Skill | What it does | Example |
|---|---|---|
| `prd` | Files a Linear issue or milestone that is the specification of its own implementation, or updates one after the plan changes. | `/pipe-skills:prd file an issue for the CSV export we just discussed` |
| `implement` | Implements one issue in a worktree, commits each validated step, reviews with fresh reviewers until a round finds no blocker and no in-scope bug, and stops at the merge gate. | `/pipe-skills:implement ACM-42` |
| `review` | Reviews a pull request or a branch, and gives a merge verdict first. | `/pipe-skills:review 118` |
| `ship` | Rebases, squash-merges, closes the issue, files only the follow-ups that earn an issue, and cleans up the branch and the worktree. | `/pipe-skills:ship ACM-42` |
| `autonomous-loop` | Implements and ships the issues you name, or every issue of the project in `Todo` state, with no stop for you, from the highest priority, one fresh subagent per issue. | `/pipe-skills:autonomous-loop` |

Working style:

| Skill | What it does | Example |
|---|---|---|
| `advise` | Gives an opinion or a plan, and changes no file. | `/pipe-skills:advise is this cache layer worth it?` |
| `interview` | Interviews you in depth to write a specification. | `/pipe-skills:interview the onboarding redesign` |
| `final-state` | Edits a document, an issue, or a comment so that it states only the settled decision, removes traces of previous ones, and keeps the rationale. | `/pipe-skills:final-state docs/design.md` |
| `promote-rule` | Turns a correction you just made into a durable rule, at the level it governs. | `/pipe-skills:promote-rule` |

## Review bar

A reviewer finds more edge cases in each round. The pipeline ends the loop when a review finds no blocker and no in-scope bug, not when it finds nothing, and it stops after 10 rounds or when a blocker comes back after its fix. A re-review checks the earlier findings and reports only new ones. The reviewer classes each finding as a blocker, in scope (same root cause as the issue, or in the code it touches), or out of scope (a different root cause). Claude fixes the blockers and the in-scope findings in the same branch, and keeps the out-of-scope findings for `ship`, which files a follow-up issue only for a reproduced bug or a feature of high value with a new root cause.

## Credits

- `interview` is the [interview prompt](https://x.com/trq212/status/2005315275026260309) by Thariq Shihipar.
- Many of the ideas behind this plugin are hevily inspired by [Matt Pocock](https://github.com/mattpocock/skills) and [Lauren Tan](https://github.com/cursor/plugins/tree/main/pstack).

The plugin is under the MIT License, see `LICENSE`.
