# Starter pack — ongoing-system

For workspaces where the system itself is the deliverable, used continuously. No single artifact ships at the end.

**Examples:** master to-do, personal CRM, knowledge base, contact manager, reading queue.

## What this pack provides

- `workflow.json` — a generic capture → process → done lifecycle that fits most ongoing-system patterns
- `contracts/item.contract.json` — a starter contract with a state machine matching the workflow

Claude is expected to customize both during the `contracts-drafting` phase: rename `item` to a domain-specific kind (`task`, `contact`, `note`), add fields, refine states, add references. The pack is a *starting point*, not a constraint.

## Default views (suggested)

When `views/` is empty, the plugin's defaults for ongoing-system are:
- Smart-table of items, filtered to non-terminal states, sorted by recency
- Kanban of items by state
- Composed dashboard with both, plus counts per state

Workspaces can override by dropping view descriptors in `views/`.

## When to pick a different substrate type

- If the work culminates in a single deliverable on a deadline → `single-deliverable`
- If items move through a strict pipeline of named stages and you care more about throughput than long-lived state → `pipeline`
- If you're doing append-only longitudinal capture (habits, decisions, metrics) → `tracker`
- If you have dependencies between work items and milestones → `project-plan`
