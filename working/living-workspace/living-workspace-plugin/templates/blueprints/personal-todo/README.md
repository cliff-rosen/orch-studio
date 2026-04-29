# Blueprint: personal-todo

A trustworthy single source of truth for everything you need to do across all parts of your life. The system itself is the deliverable — there's no shipping moment.

## When to pick this blueprint

Pick this if your goal is:
- Maintaining an ongoing list of things to do
- Tracking progress across personal areas of responsibility (health, work, family, etc.)
- Capturing fast and surfacing what's actively in progress
- Periodic review rather than deadline-driven completion

Don't pick this if:
- You're producing a single deliverable on a deadline (consider `document-revision` or build a custom blueprint)
- You're doing append-only longitudinal capture without state machines (consider `tracker`)
- The work is project-coordinated with hard dependencies (consider `project-plan`)

## What this blueprint installs

Three stores, all Tables:

- **tasks** — the atomic action unit. Each task has a state (inbox / next / doing / waiting / someday / done / dropped), can reference an area and optionally a project, has a due date, priority, and contexts.
- **projects** — multi-step outcomes. Each project has a state (active / paused / complete / abandoned), references an area, optionally has a due date.
- **areas** — ongoing areas of responsibility. Stateless (areas don't get "done"). Used for grouping tasks and projects.

A starter dashboard page that surfaces:
- Smart-table of open tasks (filtered to inbox/next/doing/waiting)
- Kanban view of tasks by state
- List of areas
- Cards for active projects

A `method.md` that encodes the orchestration: capture → process → engage → review.

## How it operates

See `method.md`. The short version: capture must be fast (drop tasks at state=inbox without interrogation); process happens deliberately (clarify each item, set its real state); engage moves things forward (next → doing → done); review is cadenced and surfaces stuck items, spine candidates, escapes.
