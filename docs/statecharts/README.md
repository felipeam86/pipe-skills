# Statecharts

`Lifecycle.tla` models the lifecycle of one piece of work through the skills, and TLC checks the rules in `Lifecycle.cfg`. `view.mjs` gives the words of the chart. The two charts in the top `README.md` come from this model:

- The main workflow: `Lifecycle-main.cfg` keeps only the steps that you drive by hand, with no `autonomous-loop`, `assess`, `sweep`, or warning of `ship`. `view-main.mjs` takes the words of `view.mjs` and gives its own title.
- The full lifecycle: `Lifecycle.cfg`, with every step and every rule.

To check the rules and make the charts again, run the `statechart` skill once for each chart, each time into a new folder:

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle-main.cfg --view docs/statecharts/view-main.mjs --out /tmp/lifecycle-main
```

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle.cfg --view docs/statecharts/view.mjs --out /tmp/lifecycle-full
```

The first run installs TLC and Java with `mise`. Without `mise`, set `TLA2TOOLS` to the path of `tla2tools.jar` and `JAVA` to a Java 11 or later binary.
