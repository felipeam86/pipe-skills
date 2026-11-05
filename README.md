# pipe-skills

A Claude Code plugin that runs a spec-to-ship pipeline on Linear or on GitHub Issues. An issue is the specification. Claude implements it in validated, committed steps, has a fresh reviewer check the work until the review is clean, and stops at the merge gate. When you are ready, Claude squash-merges the work and closes the issue. It can also work through a whole `Todo` queue on its own, one issue after another.

The plugin also has the working-style skills that the pipeline relies on: give an opinion without changing anything, interview you for a spec, keep documents at their final state, and turn corrections into lasting rules.

## Install

```
/plugin marketplace add felipeam86/pipe-skills
/plugin install pipe-skills@pipe-skills
```

## Setup

Run `/pipe-skills:setup` in the project. It asks for Linear or GitHub Issues, checks what the tracker needs, fixes what it can after your go, and writes the line of the project `CLAUDE.md` that names where the work lives. On Linear, that line names one project, or one initiative whose projects are the outcomes of the work. Both trackers use the `gh` CLI when the repository has a GitHub remote.

## Skills

The pipeline:

| Skill | What it does | Example |
|---|---|---|
| `setup` | Makes a project ready: the tracker line in `CLAUDE.md`, and the team with its project or initiative, or the GitHub project, with its states and priority. | `/pipe-skills:setup` |
| `prd` | Files an issue that is the specification of its own implementation in the outcome it serves, or a new outcome, or updates one after the plan changes. | `/pipe-skills:prd file an issue for the CSV export we just discussed` |
| `assess` | Judges whether one `Backlog` or `Todo` issue still matches the code and its goal, and gives a verdict with the evidence. Changes nothing. | `/pipe-skills:assess #42` |
| `implement` | Implements one issue in a worktree, commits each validated step, reviews with fresh reviewers until a round finds no blocker and no in-scope bug, and stops at the merge gate. | `/pipe-skills:implement ACM-42` or `/pipe-skills:implement #42` |
| `review` | Reviews a pull request or a branch, and gives a merge verdict first. | `/pipe-skills:review 118` |
| `ship` | Rebases, squash-merges, closes the issue, files only the follow-ups that earn an issue, and cleans up the branch and the worktree. | `/pipe-skills:ship ACM-42` |
| `sweep` | Runs `assess` on every `Backlog` and `Todo` issue, or on the issues you name, reports the verdicts, and applies only the ones you approve: a review comment, a rewrite, a close, or a cancel. | `/pipe-skills:sweep` or `/pipe-skills:sweep #42` |
| `autonomous-loop` | Implements and ships the issues you name, or every issue of one project in `Todo` state, with no stop for you, from the highest priority, one fresh subagent per issue. It skips an issue that `assess` finds not current, and changes nothing on it. | `/pipe-skills:autonomous-loop` |

Working style:

| Skill | What it does | Example |
|---|---|---|
| `advise` | Gives an opinion or a plan, and changes no file. | `/pipe-skills:advise is this cache layer worth it?` |
| `interview` | Interviews you in depth to write a specification. | `/pipe-skills:interview the onboarding redesign` |
| `final-state` | Edits a document, an issue, or a comment so that it states only the settled decision, removes traces of previous ones, and keeps the rationale. | `/pipe-skills:final-state docs/design.md` |
| `promote-rule` | Turns a correction you just made into a durable rule, at the level it governs. | `/pipe-skills:promote-rule` |

## How the skills fit together

One piece of work moves through the states of its issue in the tracker. Each arrow names who acts, and the skill when one runs. `setup` is not on the chart, because it runs once before the first issue, and `promote-rule` is not on it, because it can run at any time, when you correct Claude. `assess` alone is not on it, because it changes nothing. The model behind the chart, and the rules that TLC checks on it, are in `docs/statecharts`.

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
    s7: Skipped, verdict in the loop report
    s8: Verdicts shown to you
  }
  state "In Progress" as s9 {
    s10: Building in steps
    s11: Rewriting the plan
    s12: Under review
    s13: Stopped, reported to you
    s14: Warned the review is not clean
  }
  state "Backlog" as s15 {
    s16: Judged not worth it
    s17: Verdicts shown to you
  }
  state "Canceled" as s18 {
    s19: Canceled
  }
  state "Done" as s20 {
    s21: Closed, the code already does it
    s22: Merged and closed
  }
  state "In Review" as s23 {
    s24: At the merge gate
  }
  [*] --> s1
  s1 --> s2: you ask for an opinion (/advise)
  s1 --> s3: you run /prd
  s1 --> s4: you ask for an interview (/interview)
  s2 --> s3: you run /prd
  s2 --> s4: you ask for an interview (/interview)
  s3 --> s6: you give the go, Claude files the issue
  s4 --> s3: you run /prd
  s6 --> s10: /autonomous-loop takes it, /assess says current or you run /implement
  s6 --> s16: the subagent judges it not worth its cost
  s6 --> s7: /autonomous-loop skips it, /assess says not current
  s6 --> s8: you run /sweep, /assess judges it
  s10 --> s11: a discovery changes the plan
  s10 --> s12: the steps are committed, a fresh reviewer starts
  s16 --> s6: you move it back to Todo
  s16 --> s10: you run /implement
  s16 --> s17: you run /sweep, /assess judges it
  s7 --> s10: /autonomous-loop takes it, /assess says current or you run /implement
  s7 --> s16: the subagent judges it not worth its cost
  s7 --> s8: you run /sweep, /assess judges it
  s8 --> s6: you reject it or you approve current or drifted
  s8 --> s19: you approve superseded or obsolete
  s8 --> s21: you approve done
  s11 --> s10: the issue is rewritten (/final-state)
  s12 --> s10: the review finds a blocker or an in-scope bug
  s12 --> s24: the review is clean
  s12 --> s13: a blocker comes back, or 10 rounds pass
  s17 --> s16: you reject it or you approve current or drifted
  s17 --> s19: you approve superseded or obsolete
  s17 --> s21: you approve done
  s24 --> s22: the subagent ships it [in /autonomous-loop] or you run /ship and give the go
  s13 --> s22: the subagent ships it [in /autonomous-loop]
  s13 --> s14: you run /ship
  s14 --> s22: you give the go anyway
  classDef purple fill:#f1e8ff,stroke:#7c4dcc,color:#3d2370
  classDef blue fill:#e6f0ff,stroke:#2f6fd6,color:#173a73
  classDef orange fill:#fff0e0,stroke:#e07a10,color:#7a3f05
  classDef yellow fill:#fff8d6,stroke:#c9a400,color:#5c4b00
  classDef teal fill:#def7f3,stroke:#1a9e8f,color:#0b4f47
  classDef tan fill:#f5ecdc,stroke:#a6793a,color:#5a3e14
  class s1 purple
  class s2 purple
  class s3 blue
  class s4 purple
  class s6 blue
  class s7 blue
  class s8 tan
  class s10 orange
  class s11 orange
  class s12 yellow
  class s13 orange
  class s14 orange
  class s16 blue
  class s17 tan
  class s19 tan
  class s21 tan
  class s22 teal
  class s24 yellow
```

Colors: purple = talk, blue = specify, orange = build, yellow = review, teal = ship, tan = sweep.

## Review bar

A reviewer finds more edge cases in each round. The pipeline ends the loop when a review finds no blocker and no in-scope bug, not when it finds nothing, and it stops after 10 rounds or when a blocker comes back after its fix. A re-review checks the earlier findings and reports only new ones. The reviewer classes each finding as a blocker, in scope (same root cause as the issue, or in the code it touches), or out of scope (a different root cause). Claude fixes the blockers and the in-scope findings in the same branch, and keeps the out-of-scope findings for `ship`, which files a follow-up issue only for a reproduced bug or a feature of high value with a new root cause.

## Credits

- `interview` is the [interview prompt](https://x.com/trq212/status/2005315275026260309) by Thariq Shihipar.
- Many of the ideas behind this plugin are hevily inspired by [Matt Pocock](https://github.com/mattpocock/skills) and [Lauren Tan](https://github.com/cursor/plugins/tree/main/pstack).

The plugin is under the MIT License, see `LICENSE`.
