import { state as fromTodo } from "./from-todo.mjs";
export { group } from "./from-todo.mjs";
export { colors, step } from "./view.mjs";
export const title = "The work of /autonomous-loop";

// An issue that you take back leaves the loop, so it gets its own state and not the states of the loop.
export const state = (v) => v.mode === "manual" ? ["In Progress", "Built by you, as in the by-hand chart"] : fromTodo(v);
