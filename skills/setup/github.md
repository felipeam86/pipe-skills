# Set up GitHub

The tracker file `trackers/github.md` owns the tracker line, the state names, the map line, and the operations; this file holds only what a setup checks and fixes.

## Requirements

- The repository has a GitHub remote: `gh repo view` answers. The fix is by hand: create the repository on GitHub and push the target branch, for example `gh repo create <owner>/<name> --source . --push`.
- `gh` has the `project` scope: `gh auth status` lists it. The fix is by hand, because it opens the browser: `! gh auth refresh -h github.com -s project`.
- The GitHub project exists, and it is linked to the repository when both have the same owner. GitHub links a project only to a repository of its own owner; a project of another owner still holds the issues as items.
- `Status` has an option for each of the five states of **Project fields** in `trackers/github.md`, by its name or by the map line, and each state has its own option: when `Backlog` and `Todo` share one, the loop takes a parked issue again.
- A `Priority` field with at least one option exists. It is optional: without it, the queue goes by issue number.
- Report, and do not change, the workflows that are off: `query { node(id: <project-node-id>) { ... on ProjectV2 { workflows(first: 20) { nodes { name enabled } } } } }`. The API can only read them, and an organization can refuse even the read. `Item closed` and `Pull request merged` set `Done`; `Auto-close issue` closes an issue at `Done`.

## Setup

Send each GraphQL mutation below as a JSON body with `gh api graphql --input <file>`, because `gh api -f` cannot pass a list.

- **Create the project.** `gh project create --owner <owner> --title <title> --format json`. A new project has `Status` = `Todo`, `In Progress`, `Done`, no `Priority`, and one table view; the API cannot start it from a template such as Kanban. Then add a board, whose columns are the `Status` options: `createProjectV2View(input: {projectId, name: "Board", layout: BOARD_LAYOUT})`.
- **Link the repository.** `gh project link <number> --owner <owner> --repo <repository>`.
- **Map or add the states.** For a project with its own lanes, ask the user for each missing state: map it to an existing option, which is the default when one fits, such as `Doing` for `In Progress`, or add the option. Write the map line for the mapped states, and add the others as **Fix `Status`** says.
- **Fix `Status`.** Read the options with their `id`, `name`, `color` and `description`: `node(id: <project-node-id>) { ... on ProjectV2 { field(name: "Status") { ... on ProjectV2SingleSelectField { id options { id name color description } } } } }`. Then send the whole list to `updateProjectV2Field(input: {fieldId, singleSelectOptions: [...]})`: the options that exist, and a template option only for a state that has no option by its name or by the map line, each option with `name`, `color` and `description`, with the option name of **Project fields** and, for each state, the color and the description of the template: `Backlog` GREEN "This item hasn't been started", `Todo` BLUE "This is ready to be picked up", `In Progress` YELLOW "This is actively being worked on", `In Review` PURPLE "This item is in review", `Done` ORANGE "This has been completed". A new project has the options `Todo` and `In Progress`: rename them to their option names only when no map line names them. Keep the `id` of every option that exists, renamed or not, and keep every other option: the list replaces all options, and an option sent without its `id`, or left out, clears the `Status` of its items.
- **Add `Priority`.** When the field exists with no option, send `P0`, `P1`, `P2` to `updateProjectV2Field` on it. Else `createProjectV2Field(input: {projectId, dataType: SINGLE_SELECT, name: "Priority", singleSelectOptions: [{name: "P0", color: RED, description: ""}, {name: "P1", color: ORANGE, description: ""}, {name: "P2", color: YELLOW, description: ""}]})`.
