# Templates

Things the plugin instantiates into a workspace. Distinct from `../schemas/`, which holds the meta-schemas the plugin uses to *validate* workspaces.

## Layout

| Path | Purpose |
|---|---|
| `workspace-skeleton/` | What `/scaffold` copies into an empty folder when a new workspace is created. Empty placeholder values; bootstrap conversation fills them. |
| `blueprints/<name>/` | Packaged methodology + substrate. Loaded after the user picks a blueprint during contracts-drafting. Each blueprint installs a customized workspace contract, initial stores, initial pages, and a `method.md`. |
| `contracts/` | Per-primitive contract boilerplates: `table.json`, `document.json`, `calendar.json`, `tree.json`, `graph.json`. Claude copies and customizes when introducing a new store. |
| `widgets/` | Widget-spec snippets per widget type. Drop into a page descriptor's `rows[].widgets[]` and customize. |
| `pages/` | Page descriptor templates. Copy and customize for new pages. |
| `components/` | Dashboard chrome composition fragments (shell-bar, goal-banner, etc.) + shared CSS. Used by the plugin to wrap page bodies with lifecycle-aware chrome. |
| `layouts.json` | Per-lifecycle-state chrome composition manifest. Maps each `state.status` value to the ordered list of chrome components that render around the page body. |

## Blueprint contents

Each blueprint mirrors what gets installed into a workspace's `workspace/` folder:

```
blueprints/<name>/
├── README.md           User-facing methodology summary (what this is for, when to use it)
├── method.md           Orchestration pattern Claude reads during operating
├── _contract.json       Workspace contract installed at bootstrap
├── stores/             Initial stores with their _contract.json + (optional) seed data
│   └── <store-name>/
│       └── _contract.json
└── pages/              Initial page descriptors
    └── dashboard.json
```

Filename convention: drop redundant suffixes. A file in a store folder named `_contract.json` is a contract; folder location identifies type.

## Status

| Item | Status |
|---|---|
| `workspace-skeleton/` | Aligned with new design |
| `blueprints/personal-todo/` | Aligned (just rewritten as a real methodology blueprint) |
| `contracts/{table,document,calendar,tree,graph}.json` | Aligned (per-primitive boilerplates) |
| `widgets/{smart-table,kanban,list,detail}.json` | Aligned (widget-spec snippets) |
| `pages/dashboard.json` | Aligned (starter page descriptor) |
| `components/` | Mostly aligned; some component stubs referenced in `layouts.json` are not yet built (see components/README.md) |
| `layouts.json` | Aligned with chrome+page-body model |
