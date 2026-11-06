import { state as fullState, group as fullGroup } from "./view.mjs";

// The loop and assess charts merge the steps before the go to file into one state: the main chart already shows how an issue is written.
const beforeFiling = ["idea", "advice", "interview", "draft"];
export const state = (v) => beforeFiling.includes(v.sub) ? ["No issue yet", "Written with /prd"] : fullState(v);
export const group = (v) => beforeFiling.includes(v.sub) ? "specify" : fullGroup(v);
