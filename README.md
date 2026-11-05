# pipe-skills

A Claude Code plugin that runs a spec-to-ship pipeline on Linear or on GitHub Issues. An issue is the specification. Claude implements it in validated, committed steps, has a fresh reviewer check the work until the review is clean, and stops at the merge gate. When you are ready, Claude squash-merges the work and closes the issue. It can also work through a whole `Todo` queue on its own, one issue after another.

The plugin also has the working-style skills that the pipeline relies on: give an opinion without changing anything, interview you for a spec, keep documents at their final state, and turn corrections into lasting rules.

## Install

```
/plugin marketplace add felipeam86/pipe-skills
/plugin install pipe-skills@pipe-skills
```

## Setup

One line in the project `CLAUDE.md` names where the work lives. The tracker file of each tracker holds what the skills do with it.

- Linear, in `trackers/linear.md`: the [Linear MCP server](https://linear.app/docs/mcp), connected and authenticated with `claude mcp add --transport http linear-server https://mcp.linear.app/mcp`, and the `gh` CLI when the repository has a GitHub remote.

  ```
  - Track work in the Linear project **Acme Web** of the team `ACM`.
  ```

- GitHub Issues, in `trackers/github.md`: the `gh` CLI with the `project` scope (`gh auth refresh -h github.com -s project`), and a GitHub project whose `Status` field holds the states that `trackers/github.md` names.

  ```
  - Track work in GitHub Issues, on the GitHub project **Roadmap** of `acme`.
  ```

## Skills

The pipeline:

| Skill | What it does | Example |
|---|---|---|
| `prd` | Files an issue or milestone that is the specification of its own implementation, or updates one after the plan changes. | `/pipe-skills:prd file an issue for the CSV export we just discussed` |
| `implement` | Implements one issue in a worktree, commits each validated step, reviews with fresh reviewers until a round finds no blocker and no in-scope bug, and stops at the merge gate. | `/pipe-skills:implement ACM-42` or `/pipe-skills:implement #42` |
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

## How the skills fit together

One piece of work moves through the states of its issue in the tracker. Each arrow names who acts, and the skill when one runs. `promote-rule` is not on the chart, because it can run at any time, when you correct Claude. The model behind the chart, and the rules that TLC checks on it, are in `docs/statecharts`.

```mermaid
---
title: "One piece of work, from idea to merge"
---
stateDiagram-v2
  state "No issue yet" as s0 {
    s1: Idea
    s2: Getting an opinion
    s3: Draft shown to you
    s4: Being interviewed
  }
  state "Todo" as s5 {
    s6: Waiting
  }
  state "In Progress" as s7 {
    s8: Building in steps
    s9: Rewriting the plan
    s10: Under review
    s11: Stopped, reported to you
    s12: Warned the review is not clean
  }
  state "Backlog" as s13 {
    s14: Judged not worth it
  }
  state "In Review" as s15 {
    s16: At the merge gate
  }
  state "Done" as s17 {
    s18: Merged and closed
  }
  [*] --> s1
  s1 --> s2: you ask for an opinion (/advise)
  s1 --> s3: you run /prd
  s1 --> s4: you ask for an interview (/interview)
  s2 --> s3: you run /prd
  s2 --> s4: you ask for an interview (/interview)
  s3 --> s6: you give the go, Claude files the issue
  s4 --> s3: you run /prd
  s6 --> s8: /autonomous-loop takes it or you run /implement
  s6 --> s14: the subagent judges it not worth its cost
  s8 --> s9: a discovery changes the plan
  s8 --> s10: the steps are committed, a fresh reviewer starts
  s14 --> s6: you move it back to Todo
  s14 --> s8: you run /implement
  s9 --> s8: the issue is rewritten (/final-state)
  s10 --> s8: the review finds a blocker or an in-scope bug
  s10 --> s16: the review is clean
  s10 --> s11: a blocker comes back, or 10 rounds pass
  s16 --> s18: the subagent ships it [in /autonomous-loop] or you run /ship and give the go
  s11 --> s18: the subagent ships it [in /autonomous-loop]
  s11 --> s12: you run /ship
  s12 --> s18: you give the go anyway
  classDef purple fill:#f1e8ff,stroke:#7c4dcc,color:#3d2370
  classDef blue fill:#e6f0ff,stroke:#2f6fd6,color:#173a73
  classDef orange fill:#fff0e0,stroke:#e07a10,color:#7a3f05
  classDef yellow fill:#fff8d6,stroke:#c9a400,color:#5c4b00
  classDef teal fill:#def7f3,stroke:#1a9e8f,color:#0b4f47
  class s1 purple
  class s2 purple
  class s3 blue
  class s4 purple
  class s6 blue
  class s8 orange
  class s9 orange
  class s10 yellow
  class s11 orange
  class s12 orange
  class s14 blue
  class s16 yellow
  class s18 teal
```

Colors: purple = talk, blue = specify, orange = build, yellow = review, teal = ship.

## Review bar

A reviewer finds more edge cases in each round. The pipeline ends the loop when a review finds no blocker and no in-scope bug, not when it finds nothing, and it stops after 10 rounds or when a blocker comes back after its fix. A re-review checks the earlier findings and reports only new ones. The reviewer classes each finding as a blocker, in scope (same root cause as the issue, or in the code it touches), or out of scope (a different root cause). Claude fixes the blockers and the in-scope findings in the same branch, and keeps the out-of-scope findings for `ship`, which files a follow-up issue only for a reproduced bug or a feature of high value with a new root cause.

## Credits

- `interview` is the [interview prompt](https://x.com/trq212/status/2005315275026260309) by Thariq Shihipar.
- Many of the ideas behind this plugin are hevily inspired by [Matt Pocock](https://github.com/mattpocock/skills) and [Lauren Tan](https://github.com/cursor/plugins/tree/main/pstack).

The plugin is under the MIT License, see `LICENSE`.
