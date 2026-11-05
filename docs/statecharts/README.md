# Statecharts

`Lifecycle.tla` models the lifecycle of one piece of work through the skills, and TLC checks the rules in `Lifecycle.cfg`. `view.mjs` gives the words of the chart. The chart in the top `README.md` comes from this model.

To check the rules and make the chart again, run the `statechart` skill:

```sh
~/.claude/skills/statechart/scripts/statechart docs/statecharts/Lifecycle.tla --config docs/statecharts/Lifecycle.cfg --view docs/statecharts/view.mjs --out /tmp/lifecycle-chart
```

The first run installs TLC and Java with `mise`. Without `mise`, set `TLA2TOOLS` to the path of `tla2tools.jar` and `JAVA` to a Java 11 or later binary.
