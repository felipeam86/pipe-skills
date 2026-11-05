# Set up Linear

The tracker file `trackers/linear.md` owns the tracker line, the state names and the operations; this file holds only what a setup checks and fixes.

## Requirements

- A Linear MCP server is connected: ToolSearch finds its `whoami` tool, `mcp__<server>__whoami`, whatever the server name, and `whoami` answers. The fix is by hand: `claude mcp add --scope user --transport http linear-server https://mcp.linear.app/mcp`, then `/mcp` to log in. The user scope serves every project; the default local scope serves only the project where it was added. The new tools may appear only in a new session: then end the setup, and run it again there.
- The team exists: `get_team` with its key. The MCP cannot create a team: the user creates it in Linear.
- The workflow of the team has the states of **Operations** in `trackers/linear.md`: `list_issue_statuses` with the team. `In Review` is not in the default workflow of a team. The MCP cannot create a state: the user adds it in the settings of the team, under the workflow, in the `Started` group.
- In the project form, the project exists in the team: `list_projects` with the team and its name.
- In the initiative form, the initiative exists: `get_initiative` with its name. Each project that **List the outcomes** of `trackers/linear.md` gives holds the team: `list_projects` with `initiative` and `fields` that hold `teams`. An initiative with no project is ready, because `pipe-skills:prd` files its first outcome.

## Setup

- **Create the project.** `save_project` with the project name and the team. Load its schema with ToolSearch first, because the tools of the server change.
- **Create the initiative.** Ask the user for its parent initiative, if it has one. `save_initiative` with the initiative name, and `parentInitiatives` with the parent. Load its schema with ToolSearch first.
- **Add the team to a project of the initiative.** `save_project` with the `id` of the project and `addTeams` with the team.
