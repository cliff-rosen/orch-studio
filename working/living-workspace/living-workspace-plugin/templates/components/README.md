# Dashboard Components

The dashboard is composed at render time from small reusable components. The plugin reads the workspace's `meta.status`, looks up the layout for that phase, and assembles the components into a page.

## How a render works

```
meta.status  →  layouts.json[status]  →  list of components  →  compose with data  →  HTML
```

## What's here

```
components/
├── README.md                this file
├── styles.css               shared CSS for all components
├── shell-bar.html           workspace identity bar (always rendered)
├── goal-banner.html         the goal (always rendered once goal exists)
├── phase-strip.html         lifecycle progress (bootstrap phases)
├── workflow-strip.html      stages with live counts (operating phase)
├── happening-now.html       what Claude is currently doing (bootstrap phases)
├── substrate-options.html   six substrate cards (substrate-selecting only)
├── today-focus.html         items in 'doing' (operating phase)
├── smart-table.html         tabular data widget
├── side-panels.html         secondary kinds (areas, projects, etc.)
├── kanban.html              tasks-by-state board
├── awaiting-footer.html     "act in your terminal" affordance
└── workspace-internals.html collapsible dev-mode panel
```

## Component contract

Each component file is an HTML fragment (no `<html>`, `<head>`, or `<body>`) that:

1. Begins with an HTML comment block declaring **what data it expects**
2. Uses `{{ placeholder }}` syntax for data substitution
3. References classes from `styles.css`
4. Renders in any phase where the layouts manifest includes it

Example header:

```html
<!--
  COMPONENT: goal-banner
  Renders: workspace goal as a prominent header band.
  Data:
    goal.purpose            string, required
    goal.deliverable        string
    goal.audience, timeframe, success_criteria, scope_out  optional
    locked                  bool — shows "locked in" tag during/after substrate-selecting
-->
```

## Layouts manifest

`templates/layouts.json` (one level up) maps each lifecycle status to a component list:

```json
{
  "substrate-selecting": {
    "components": ["shell-bar", "phase-strip", "goal-banner", "happening-now",
                   "substrate-options", "awaiting-footer"]
  },
  "operating": {
    "components": ["shell-bar", "workflow-strip", "goal-banner", "today-focus",
                   "smart-table", "side-panels", "kanban", "workspace-internals"]
  }
}
```

The plugin renders in array order. Composition is config; the components don't know about each other.

## Why this beats per-phase full HTML

- **No duplicated shell.** Shell bar, goal banner, fonts, color tokens — written once.
- **Phase changes are layout changes.** Swap `phase-strip` for `workflow-strip` when status moves to `operating`. No new HTML file needed.
- **Components are testable in isolation.** Render `smart-table` against any kind, any data set.
- **Custom views slot in.** Claude-generated HTML can be added as a custom component without touching the dashboard structure.
- **Substrate-specific overrides are easy.** A substrate type's manual could declare a custom component list, or override one component (e.g., a tracker substrate uses `timeline` instead of `smart-table`).

## Composed reference renders

For visual reference, the existing full-HTML files in `templates/` are kept as *compiled outputs* of specific layouts:

- `templates/dashboard.template.html` — the `operating` layout rendered against placeholder data
- `templates/dashboard.substrate-selecting.html` — the `substrate-selecting` layout rendered against the master-todo bootstrap scenario

These are *outputs*, not sources. If a component changes, the reference render gets re-composed.
