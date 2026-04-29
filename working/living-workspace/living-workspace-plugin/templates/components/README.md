# Dashboard Components

The dashboard is composed at render time from small reusable components. The plugin reads the workspace's `state.status`, looks up the matching layout in `layouts.json`, and assembles the components into chrome that wraps the page body.

## How a render works

```
state.status  →  layouts.json[status]  →  list of chrome components
                                       +
workspace/pages/<active-page>.json  →  list of widgets in rows
                                       ↓
                                 composed HTML
```

**Chrome** = the surrounding pieces (shell-bar, goal-banner, phase-strip, etc.) — plugin-driven, lifecycle-aware.
**Body** = the page composition (rows of widgets) — workspace-driven, per-page.

## What's here

```
components/
├── README.md                this file
├── styles.css               shared CSS for all chrome components
├── shell-bar.html           workspace identity bar (always rendered)
├── goal-banner.html         the goal (always rendered once goal exists)
├── phase-strip.html         lifecycle progress (bootstrap phases)
├── workflow-strip.html      workflow stages with live counts (operating)
├── happening-now.html       what Claude is currently doing (bootstrap phases)
└── awaiting-footer.html     "act in your terminal" affordance (bootstrap phases)
```

## Components referenced in layouts.json but not yet built (TODO)

- `goal-form` — used during goal-defining; prompts for missing required fields
- `blueprint-picker` — used during contracts-drafting; lists available blueprints
- `contracts-preview` — used during contracts-drafting; shows the contracts being drafted
- `wrap-banner` — used during wrapping-up; banner indicating refusal of structural changes
- `archive-banner` — used during archived; read-only timestamp banner
- `page-body` — used during operating/wrapping-up; placeholder where the active page descriptor renders into
- `page-body-readonly` — used during archived; read-only render of the page body
- `workspace-internals` — collapsible dev-mode panel (already exists in master-todo's dashboard but not yet extracted)

## Component contract

Each component file is an HTML fragment (no `<html>`, `<head>`, or `<body>`) that:

1. Begins with an HTML comment block declaring **what data it expects**
2. Uses `{{ placeholder }}` syntax for data substitution
3. References classes from `styles.css`
4. Renders in any phase where `layouts.json` includes it

Example header:

```html
<!--
  COMPONENT: goal-banner
  Renders: workspace goal as a prominent header band.
  Data:
    goal.purpose            string, required
    goal.deliverable        string
    goal.audience, timeframe, success_criteria, scope_out  optional
    locked                  bool — shows "locked in" tag once status >= contracts-drafting
-->
```

## Layouts manifest

`templates/layouts.json` (one level up) maps each lifecycle status to a chrome composition:

```json
{
  "operating": {
    "components": [
      "shell-bar", "workflow-strip", "goal-banner",
      "page-body", "workspace-internals"
    ]
  }
}
```

The plugin renders chrome components in array order, with `page-body` substituted by the active page descriptor's rendered body.

## Why this beats per-phase full HTML

- **No duplicated shell.** Shell bar, goal banner, fonts, color tokens — written once.
- **Phase changes are layout changes.** Swap `phase-strip` for `workflow-strip` when status moves to `operating`. No new HTML file needed.
- **Components are testable in isolation.** Render each chrome component against any data set.
- **Page bodies stay separate from chrome.** Workspace-driven page descriptors compose freely without affecting the chrome.

## Composed reference renders

For visual reference, see:
- `projects/master-todo/dashboard.html` — the full operating-phase dashboard composed against real master-todo data. Chrome (shell-bar + workflow-strip + goal-banner) wrapping the page body (smart-table + kanban + list + cards rows).
