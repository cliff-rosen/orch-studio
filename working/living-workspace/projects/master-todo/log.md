# Process Log — Master To-Do

## Decisions

### 2026-04-26 — Substrate type: ongoing-system
**Why.** This isn't producing a single artifact. The deliverable IS the system, used continuously. Drove the choice of state-machine-flavored task lifecycle and a smart-table + kanban + dashboard view default.

### 2026-04-26 — Three kinds: Task, Project, Area
**Why.** GTD-flavored. Tasks are the atomic action unit. Projects are multi-step outcomes. Areas are ongoing responsibilities (Health, Work, etc.) — useful for grouping but not state-machined.

### 2026-04-26 — Skip "context" as a separate kind
**Why.** GTD orthodox uses contexts (@home, @phone, @errand) heavily. For v0 we'll use a `contexts` array on Task instead — flat tags, not a separate kind. Revisit if filtering by context becomes a daily habit.

## Pivots

(none yet — workspace just bootstrapped)

## Spine candidates

- **Weekly review surface**. We don't have a formal review-rhythm artifact yet, but every system like this needs one. Likely candidate: a saved smart-table view filtered by `state in (waiting, someday)` plus a counter of inbox items.
- **Daily focus**. A dashboard tile for "What I'm doing today" — likely a kanban filter or a pinned smart-table view.

## Escapes

(none yet)
