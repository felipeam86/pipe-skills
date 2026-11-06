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
| `assess` | Judges whether one `Backlog` or `Todo` issue still matches the code and its goal, and gives a verdict with the evidence. It changes nothing: after your go, the session applies the verdict and posts the review comment. | `/pipe-skills:assess #42` |
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

One piece of work moves through the states of its issue in the tracker. Each arrow names who acts, and the skill when one runs. Three charts show the three ways to drive the work. `setup` is not on the charts, because it runs once before the first issue, and `promote-rule` is not on them, because it can run at any time, when you correct Claude. The charts come from one model, and TLC checks its rules on all the paths together; the model and the rules are in `docs/statecharts`.

Colors: purple = talk, blue = specify, orange = build, yellow = review, teal = ship, tan = sweep.

### By hand

The main workflow, with the main skills: from an idea to an issue, then to a merge.

```mermaid
---
title: "The main workflow, by hand"
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
  state "In Review" as s13 {
    s14: At the merge gate
  }
  state "Done" as s15 {
    s16: Merged and closed
  }
  [*] --> s1
  s1 --> s2: you ask for an opinion (/advise)
  s1 --> s3: you run /prd
  s1 --> s4: you ask for an interview (/interview)
  s2 --> s3: you run /prd
  s2 --> s4: you ask for an interview (/interview)
  s3 --> s6: you give the go, Claude files the issue
  s4 --> s3: you run /prd
  s6 --> s8: you run /implement
  s8 --> s9: a discovery changes the plan
  s8 --> s10: the steps are committed, a fresh reviewer starts
  s9 --> s8: the issue is rewritten (/final-state)
  s10 --> s8: the review finds a blocker or an in-scope bug
  s10 --> s14: the review is clean
  s10 --> s11: a blocker comes back, or 10 rounds pass
  s14 --> s16: you run /ship and give the go
  s11 --> s12: you run /ship
  s12 --> s16: you give the go anyway
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
  class s14 yellow
  class s16 teal
```

### With `autonomous-loop`

The loop takes each `Todo` issue without you. It checks the issue with `assess` first, and it ships without your go.

```mermaid
---
title: "The work of /autonomous-loop"
---
stateDiagram-v2
  state "No issue yet" as s0 {
    s1: Written with /prd
  }
  state "Todo" as s2 {
    s3: Waiting
    s4: Skipped, verdict in the loop report
  }
  state "In Progress" as s5 {
    s6: Building in steps
    s7: Rewriting the plan
    s8: Under review
    s9: Stopped, reported to you
  }
  state "Backlog" as s10 {
    s11: Judged not worth it
  }
  state "In Review" as s12 {
    s13: At the merge gate
  }
  state "Done" as s14 {
    s15: Merged and closed
  }
  [*] --> s1
  s1 --> s3: you give the go, Claude files the issue
  s3 --> s4: /autonomous-loop skips it, /assess says not current
  s6 --> s7: a discovery changes the plan
  s6 --> s8: the steps are committed, a fresh reviewer starts
  s11 --> s3: you move it back to Todo
  s7 --> s6: the issue is rewritten (/final-state)
  s8 --> s6: the review finds a blocker or an in-scope bug
  s8 --> s13: the review is clean
  s8 --> s9: a blocker comes back, or 10 rounds pass
  s13 --> s15: the subagent ships it [in /autonomous-loop]
  s9 --> s15: the subagent ships it [in /autonomous-loop]
  s2 --> s6: /autonomous-loop takes it, /assess says current
  s2 --> s11: the subagent judges it not worth its cost
  classDef blue fill:#e6f0ff,stroke:#2f6fd6,color:#173a73
  classDef orange fill:#fff0e0,stroke:#e07a10,color:#7a3f05
  classDef yellow fill:#fff8d6,stroke:#c9a400,color:#5c4b00
  classDef teal fill:#def7f3,stroke:#1a9e8f,color:#0b4f47
  class s1 blue
  class s3 blue
  class s4 blue
  class s6 orange
  class s7 orange
  class s8 yellow
  class s9 orange
  class s11 blue
  class s13 yellow
  class s15 teal
```

### With `assess` or `sweep`

A waiting issue is checked against the code, and nothing changes before your go.

```mermaid
---
title: "A waiting issue under /assess or /sweep"
---
stateDiagram-v2
  state "No issue yet" as s0 {
    s1: Written with /prd
  }
  state "Todo" as s2 {
    s3: Waiting
    s4: Skipped, verdict in the loop report
    s5: Verdicts shown to you
  }
  state "Backlog" as s6 {
    s7: Judged not worth it
    s8: Verdicts shown to you
  }
  state "Canceled" as s9 {
    s10: Canceled
  }
  state "Done" as s11 {
    s12: Closed, the code already does it
  }
  [*] --> s1
  s1 --> s3: you give the go, Claude files the issue
  s3 --> s7: the subagent judges it not worth its cost
  s3 --> s4: /autonomous-loop skips it, /assess says not current
  s3 --> s5: you run /assess or /sweep
  s7 --> s3: you move it back to Todo
  s7 --> s8: you run /assess or /sweep
  s4 --> s7: the subagent judges it not worth its cost
  s4 --> s5: you run /assess or /sweep
  s5 --> s3: you reject it or you approve current or drifted
  s5 --> s10: you approve superseded or obsolete
  s5 --> s12: you approve done
  s8 --> s7: you reject it or you approve current or drifted
  s8 --> s10: you approve superseded or obsolete
  s8 --> s12: you approve done
  classDef blue fill:#e6f0ff,stroke:#2f6fd6,color:#173a73
  classDef tan fill:#f5ecdc,stroke:#a6793a,color:#5a3e14
  class s1 blue
  class s3 blue
  class s4 blue
  class s5 tan
  class s7 blue
  class s8 tan
  class s10 tan
  class s12 tan
```

## Review bar

A reviewer finds more edge cases in each round. The pipeline ends the loop when a review finds no blocker and no in-scope bug, not when it finds nothing, and it stops after 10 rounds or when a blocker comes back after its fix. A re-review checks the earlier findings and reports only new ones. The reviewer classes each finding as a blocker, in scope (same root cause as the issue, or in the code it touches), or out of scope (a different root cause). Claude fixes the blockers and the in-scope findings in the same branch, and keeps the out-of-scope findings for `ship`, which files a follow-up issue only for a reproduced bug or a feature of high value with a new root cause.

## Credits

- `interview` is the [interview prompt](https://x.com/trq212/status/2005315275026260309) by Thariq Shihipar.
- Many of the ideas behind this plugin are hevily inspired by [Matt Pocock](https://github.com/mattpocock/skills) and [Lauren Tan](https://github.com/cursor/plugins/tree/main/pstack).

The plugin is under the MIT License, see `LICENSE`.
