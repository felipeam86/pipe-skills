# Statecharts

`Lifecycle.tla` models the lifecycle of one piece of work through the skills. `Lifecycle.cfg` checks the rules on every path with TLC, and gives no chart for the top `README.md`. Each of the three charts there keeps one flow of the same model with an `ACTION_CONSTRAINT`:

- By hand: `Lifecycle-main.cfg` and `view-main.mjs`. No step of `autonomous-loop`, `assess`, or `sweep`.
- With `autonomous-loop`: `Lifecycle-loop.cfg` and `view-loop.mjs`. No verdict of `assess` or `sweep`. Of the steps that you run by hand after the issue is filed, it keeps only the ones that take back an issue that the loop left in `Backlog` or skipped: you move it back to `Todo`, or you run `/implement`.
- With `assess` or `sweep`: `Lifecycle-assess.cfg` and `view-assess.mjs`. No implementation.

`view.mjs` gives the words of every chart. With `from-todo.mjs`, the loop and assess views merge the steps before the go to file into one state, "Written with /prd", because the main chart shows how an issue is written.

To check the rules, run the `statechart` skill on `Lifecycle.cfg`. To make the charts again, run it once for each chart, each time into a new folder:

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle.cfg --view docs/statecharts/view.mjs --out /tmp/lifecycle-rules
```

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle-main.cfg --view docs/statecharts/view-main.mjs --out /tmp/lifecycle-main
```

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle-loop.cfg --view docs/statecharts/view-loop.mjs --out /tmp/lifecycle-loop
```

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle-assess.cfg --view docs/statecharts/view-assess.mjs --out /tmp/lifecycle-assess
```

The first run installs TLC and Java with `mise`. Without `mise`, set `TLA2TOOLS` to the path of `tla2tools.jar` and `JAVA` to a Java 11 or later binary.
