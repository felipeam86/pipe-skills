# pipe-skills

## Tracker

- Track work in GitHub Issues, on the GitHub project **Pipe's skills** of `felipeam86`.

## Statechart

- The statechart in `docs/statecharts` and the skills describe one behavior, so they change in the same commit, in both directions: a skill change that adds, removes, or moves a step, a state, or a rule changes `Lifecycle.tla` and `view.mjs`, and a model change changes the skill text it describes. Run TLC with the command in `docs/statecharts/README.md`, and paste the new chart into `README.md`, because a chart that drifts from the skills tells the user a wrong story.
- When you put a new `chart.mmd` into `README.md`, remove its `Legend` block and its `class lg` lines, and add one `classDef` line for each phase color, with the colors of the chart in `README.md`. The command always writes the Legend, which Mermaid cannot place at a fixed position, so `README.md` gives the colors in one line of text, and the command writes no `classDef` for the phase colors.
- Each time you change a skill, read the model, and say in the commit message whether the chart changed, so that a skill change that skips the model shows in the history.

## Skills

- A skill reads the values of a project, such as its Linear team and project, from the `CLAUDE.md` of that project and never holds them, because the plugin serves every project that installs it.
- A skill that merges, closes an issue, or deletes a branch sets `disable-model-invocation: true`, so that only the user starts it. `ship` and `autonomous-loop` are the case.
- A skill names another skill as `pipe-skills:<name>`, and a subagent prompt reads a skill at `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md`, so that the reference holds wherever the plugin is installed.
- A skill owns its behavior. The `README.md` gives each skill one row with one example, plus the chart, so a new, renamed, or removed skill changes its row in the same commit.
- A guard in a skill never stops `autonomous-loop`: when the guard asks the user for a go, the loop continues without it, because the loop exists to work through a queue with no stop for the user.
