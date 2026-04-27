# Living Workspace Plugin — Architecture

Stakes-in-the-ground for v0. Open questions flagged inline.

---

## Components

### Server-side (runs locally)

| Component | Job |
|---|---|
| **HTTP server** | Serves the SPA + static assets. Default `localhost:7000`. |
| **WebSocket server** | Pushes file system changes to the browser in real time. |
| **File watcher** | Watches the workspace folder. Knows which files map to which meta-schema layer (goal, workflow, contracts, data, views). Debounces rapid edits. |
| **Schema registry** | Holds the meta-schemas (invariant across workspaces). Validates structural files on read and write. |
| **Contract validator** | Reads workspace's *domain* contracts. Validates data instances on write. Surfaces violations. |
| **View resolver** | Given a route, picks the right view: custom HTML in `views/`, or generic default for the data kind. |

Runtime open question: Node.js (familiar, NPM ecosystem) vs Python (lower deps, stdlib-friendly). Probably Node — better for SPA bundling and the WebSocket story.

### Client-side (browser)

| Component | Job |
|---|---|
| **WebSocket client** | Subscribes to workspace changes. |
| **State store** | Mirrors the file system in browser memory. |
| **Widget set** | Generic interactive components (smart table, kanban, detail pane, cards, timeline, etc.). See *Widgets* section below. |
| **Custom view embedder** | Renders Claude-generated HTML for one-offs. Sandboxed per-view. |
| **Schema-driven editor** | (later) Forms generated from contract schema for direct manipulation. |

### Claude Code integration

- **Slash commands** (`.claude/commands/*.md`):
  - `/scaffold` — bootstrap a new workspace (drives goal-elicitation conversation)
  - `/render` — start the local server, open browser
  - `/spine` — propose load-bearing patterns for promotion to contract
  - `/escape` — flag an object that doesn't fit the current contract
  - `/promote` — promote an escape or spine candidate to a contract
- **Project instructions** (CLAUDE.md): the operating discipline — Goal → Workflow → Contract → Data → Views, classification, propagation rules.
- **No MCP server in v0.** Slash commands + file conventions are enough.
- **No hooks in v0.** File watcher catches what we need.

---

## Substrate types

Between goal and workflow there's an archetype classification: **substrate type**. It's the shape of the work. The user picks one (with Claude's recommendation) once the goal is clear, and the choice determines the starter shape of everything below — workflow, contract patterns, default view layout.

| Type | What it is | Workflow shape | Contract pattern | Default view |
|---|---|---|---|---|
| **ongoing-system** | CRM-like. The system itself is the deliverable, used continuously. Examples: master to-do, personal CRM, knowledge base. | Item-lifecycle states (capture → process → done). Review cadences. | Heavy on long-lived domain kinds (Task, Contact, Note). State machines per kind. | Smart table + kanban + dashboard. |
| **single-deliverable** | Produces one artifact by a deadline. Examples: competitive analysis memo, strategy deck. | Linear stages culminating in draft → revised → final. | Inputs (Source, Claim, Theme) plus the deliverable artifact (Section, Draft). | Outline + cards + dashboard. |
| **pipeline** | Input transforms through stages. Examples: research pipeline, hiring pipeline. | Explicit stage progression for a single kind. | One central kind moves through states; supporting kinds at each stage. | Kanban + smart table. |
| **tracker** | Longitudinal capture. Examples: habit tracker, decision log, metrics journal. | Append-only with periodic review. | Lightweight kinds, time-flavored. | Timeline + smart table. |
| **project-plan** | Coordinated multi-step execution. Examples: product launch, event planning. | Dependency-aware stages with milestones. | Project + Milestone + Task with parent/child references. | Tree + timeline + dashboard. |
| **hybrid** | None of the above fit cleanly. | User-defined. | User-defined. | Dashboard + smart table. |

Each substrate type ships as a **starter pack**: default `workflow.json`, suggested contract files (kinds + states), and a default view layout. Claude proposes the pack that matches the goal; the user accepts or asks for a different one. Once accepted, Claude customizes the pack to the specific goal.

The starter pack is a *starting point*, not a constraint. Workspaces evolve away from their starter as the work matures — that's expected.

---

## Workspace lifecycle (state machine)

```
                    ┌───────────────────┐
                    │   goal-defining   │   meta.status, the "bootstrap" phase
                    └─────────┬─────────┘
                              ↓
                    ┌───────────────────┐
                    │ substrate-selecting│
                    └─────────┬─────────┘
                              ↓
                    ┌───────────────────┐
                    │ contracts-drafting│
                    └─────────┬─────────┘
                              ↓
                    ┌───────────────────┐    ┌───────────────────┐
                    │     operating     │ ←→ │     paused        │ (optional side branch)
                    └─────────┬─────────┘    └───────────────────┘
                              ↓
                    ┌───────────────────┐
                    │   wrapping-up     │   (only meaningful for single-deliverable / project-plan)
                    └─────────┬─────────┘
                              ↓
                    ┌───────────────────┐
                    │     archived      │
                    └───────────────────┘
```

Backward transitions are allowed: from `contracts-drafting` back to `substrate-selecting` (wrong archetype) or `goal-defining` (wrong goal). From `operating` back to `contracts-drafting` (need to revise contracts). The state machine documents the *common* path; reality includes pivots.

For ongoing-system and tracker workspaces, `wrapping-up` is rarely used — they archive directly from operating when done.

---

## Storage layout

```
<workspace>/
├── meta.json                       Workspace identity + lifecycle state.
├── goal.json                       The anchor.
├── workflow.json                   Stages + transitions.
├── process.md                      Narrative log: decisions, pivots, spine candidates.
├── contracts/
│   ├── <kind>.contract.json        One file per kind.
│   └── ...
├── data/
│   ├── <kind-plural>/
│   │   ├── <id>.json               One file per instance.
│   │   └── ...
│   └── ...
├── views/
│   ├── <name>.view.json            View descriptor.
│   └── <name>.view.html            Custom HTML (when generic doesn't suffice).
└── escapes/
    └── escape-<id>.json            Objects that resist the current contract.
```

**Rule of thumb.** Anything the plugin enforces is JSON. Anything narrative is markdown. Only `process.md` is markdown today; everything else is structured.

---

## Meta-schemas (invariant across all workspaces)

These five JSON Schemas define the skeleton of every workspace.

### `meta.schema.json`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "lws://meta-schema/meta",
  "title": "Workspace Meta",
  "type": "object",
  "required": ["workspace_id", "created_at", "status", "meta_schema_version"],
  "properties": {
    "workspace_id": { "type": "string" },
    "created_at": { "type": "string", "format": "date-time" },
    "last_modified": { "type": "string", "format": "date-time" },
    "status": {
      "enum": [
        "goal-defining",
        "substrate-selecting",
        "contracts-drafting",
        "operating",
        "wrapping-up",
        "archived"
      ]
    },
    "substrate_type": {
      "enum": [
        "ongoing-system",
        "single-deliverable",
        "pipeline",
        "tracker",
        "project-plan",
        "hybrid"
      ],
      "description": "Selected during bootstrap; determines which starter pack loads."
    },
    "current_stage": {
      "type": "string",
      "description": "Reference to a workflow.json stage name (used during operating)."
    },
    "domain_hint": {
      "type": "string",
      "description": "Free-text tag, e.g. 'competitive-analysis', 'master-todo'."
    },
    "meta_schema_version": { "type": "string" },
    "title": {
      "type": "string",
      "description": "Display name for the workspace."
    }
  }
}
```

### `goal.schema.json`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "lws://meta-schema/goal",
  "title": "Workspace Goal",
  "type": "object",
  "required": ["purpose", "deliverable", "success_criteria"],
  "properties": {
    "purpose": {
      "type": "string",
      "description": "One sentence: what this workspace exists to produce."
    },
    "deliverable": {
      "type": "string",
      "description": "The artifact(s) being produced. Could be ongoing, e.g. 'a trustworthy system'."
    },
    "audience": { "type": "string" },
    "timeframe": { "type": "string" },
    "scope_in": {
      "type": "array",
      "items": { "type": "string" }
    },
    "scope_out": {
      "type": "array",
      "items": { "type": "string" }
    },
    "success_criteria": {
      "type": "array",
      "items": { "type": "string" },
      "minItems": 1
    }
  }
}
```

### `workflow.schema.json`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "lws://meta-schema/workflow",
  "title": "Workspace Workflow",
  "type": "object",
  "required": ["stages", "transitions"],
  "properties": {
    "stages": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "required": ["name"],
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" },
          "invariants": {
            "type": "array",
            "items": { "type": "string" }
          }
        }
      }
    },
    "items": {
      "type": "array",
      "description": "Which kinds flow through these stages.",
      "items": {
        "type": "object",
        "required": ["kind"],
        "properties": {
          "kind": { "type": "string" }
        }
      }
    },
    "transitions": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["from", "to"],
        "properties": {
          "from": { "type": "string" },
          "to": { "type": "string" },
          "kind": { "type": "string" },
          "guard": {
            "type": "string",
            "description": "Condition that must be true to make this transition."
          }
        }
      }
    }
  }
}
```

### `contract.schema.json` — the meta-schema for contracts themselves

This is the most important one. Every domain contract conforms to this shape.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "lws://meta-schema/contract",
  "title": "Domain Contract",
  "type": "object",
  "required": ["kind", "schema"],
  "properties": {
    "kind": {
      "type": "string",
      "description": "Singular name, e.g. 'task'."
    },
    "kind_plural": {
      "type": "string",
      "description": "Plural form for directory naming, e.g. 'tasks'."
    },
    "description": { "type": "string" },
    "schema": {
      "description": "Standard JSON Schema for the data shape.",
      "type": "object"
    },
    "states": {
      "type": "array",
      "items": { "type": "string" },
      "description": "If state-machine-flavored, list the states."
    },
    "initial_state": { "type": "string" },
    "transitions": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["from", "to"],
        "properties": {
          "from": { "type": "string" },
          "to": { "type": "string" },
          "guard": { "type": "string" }
        }
      }
    },
    "invariants": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Prose statements about what must be true; some may be machine-checked."
    },
    "id_field": {
      "type": "string",
      "default": "id",
      "description": "Which field uniquely identifies an instance."
    },
    "title_field": {
      "type": "string",
      "description": "Which field to use as the display title in views."
    },
    "references": {
      "type": "array",
      "description": "Foreign-key-like links to other kinds.",
      "items": {
        "type": "object",
        "required": ["field", "kind"],
        "properties": {
          "field": { "type": "string" },
          "kind": { "type": "string" }
        }
      }
    }
  }
}
```

### `view.schema.json`

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "lws://meta-schema/view",
  "title": "View Descriptor",
  "type": "object",
  "required": ["name", "view_type"],
  "properties": {
    "name": { "type": "string" },
    "view_type": {
      "enum": ["list", "table", "detail", "kanban", "dashboard", "custom"]
    },
    "kind": {
      "type": "string",
      "description": "Which contract kind this view shows. Optional for dashboards that span kinds."
    },
    "fields": {
      "type": "array",
      "items": { "type": "string" }
    },
    "filters": {
      "type": "object",
      "description": "Field/value pairs to filter on."
    },
    "sort": {
      "type": "object",
      "properties": {
        "field": { "type": "string" },
        "direction": { "enum": ["asc", "desc"] }
      }
    },
    "group_by": { "type": "string" },
    "custom_html_path": {
      "type": "string",
      "description": "Path to custom HTML if view_type == custom."
    }
  }
}
```

---

## Widgets

A view isn't just rendering — it's an interactive surface. The plugin ships a starter set of **widgets**: generic components that know how to display some shape of data *and* what behaviors they offer. Custom HTML views are also widgets, just hand-rolled.

Every widget has three layers of behavior:

- **Local UI** (sort, filter, hide column, expand/collapse) — pure browser state, never touches files.
- **Direct write** (inline edit, drag-to-transition, quick-add) — writes files through the contract validator.
- **Claude action** (bulk operations, enrichment, "ask Claude about selected") — routes intent back to the chat session via the click-to-copy pattern (or eventually a back channel).

### Widget catalog (v0)

#### Smart Table
Tabular display, the workhorse widget.
- Sortable, filterable, hideable columns
- Inline cell editing (validated against contract on write)
- Bulk-select → bulk-action (Claude-routed)
- Quick-add row (creates instance through contract; required fields prompt)
- **Dynamic column add — three modes:**
  - **Computed**: a formula over existing fields. View-side, never touches data. Example: `age_days = today - created_at`. Cheap, dynamic, recomputes automatically.
  - **Enriched**: Claude walks each instance and writes a value. Persistent — gets stored back to data files. Example: *"add a column called 'topic' and classify each source"*. Expensive (one LLM call per row), but produces real new data. New instances need re-enrichment.
  - **Manual**: a new empty field you'll fill in yourself. Becomes part of the contract schema.
- The three modes look identical in the UI but have very different cost and persistence profiles. The plugin shows the user which mode they're choosing before committing.

#### Kanban Board
For any kind with `states` defined.
- Columns are states, cards are instances
- Drag = state transition, validated against contract (only valid transitions are accepted; guards enforced)
- Quick-add per column

#### List
- Single-line rows with key fields
- Lighter than smart table; good for narrow panels and dense datasets
- Click → opens detail; supports group-by

#### Detail Pane
- Single instance, all fields
- Edit-in-place
- Renders valid state transitions as buttons
- Inline references: links to other kinds with click-through

#### Cards Grid
- Visual grid of preview cards
- Title + a few key fields per card
- Good for sources, references, anything you want to scan visually

#### Tree / Outline
- Hierarchical display for kinds with parent/child references
- Collapsible nodes
- Drag-reparent (subject to contract validation)

#### Timeline
- Items positioned by a date field
- Day/week/month/year zoom
- Drag to reschedule (writes back to data)

#### Form
- Schema-driven create/edit form, generated from contract schema
- Used inline in other widgets (quick-add) or as a standalone view

#### Dashboard
- Composed of **dashboard tiles**: counts, summary stats, recent items, mini-widgets
- Default dashboard: goal banner + workflow strip + key counts + recent process

#### Command Bar
- Global query / NL action surface
- Typed query (search across data) or *"ask Claude to do X with current selection"*

### Widget configuration

Each widget has its own config schema (sub-schemas of `view.schema.json`). The view descriptor declares `view_type` and supplies the matching config:

```json
{
  "name": "open-tasks",
  "view_type": "smart-table",
  "kind": "task",
  "config": {
    "columns": [
      { "field": "title" },
      { "field": "state" },
      { "field": "due" },
      { "field": "age_days", "mode": "computed", "expression": "today - created_at" },
      { "field": "topic", "mode": "enriched", "enrichment_prompt": "Classify this task into one of: deep-work, errand, communication, admin." }
    ],
    "filters": { "state": ["next", "doing"] },
    "sort": { "field": "due", "direction": "asc" }
  }
}
```

---

## Templates the plugin ships

The plugin ships skeletons, not domain knowledge. Contracts are always fabricated per-workspace by Claude; the plugin provides the boilerplate.

| Template | What's in it |
|---|---|
| **Empty workspace skeleton** | Directory tree + empty placeholder files + initial `meta.json` (status=bootstrap). |
| **`goal.json` placeholder** | Required keys with empty/example values. |
| **`workflow.json` starters** | A few common patterns: linear, kanban, GTD-like, research-pipeline. User picks one or starts blank. |
| **`contract.json` boilerplate** | Skeleton with the required keys; Claude fills schema + states + transitions. |
| **Default views** | List, detail, table, kanban, dashboard — generic, contract-aware. Rendered by the plugin without any view file present. |

---

## Process flows

### Bootstrap (`/scaffold`)

The bootstrap is itself a state machine — Claude walks the user through the phases rather than dumping everything at once.

1. **`goal-defining`** — Claude elicits purpose, deliverable, audience, success criteria. Writes `goal.json` and `meta.json` (status=`goal-defining`).
2. **`substrate-selecting`** — With goal in hand, Claude proposes a substrate type (with reasoning) and offers alternatives. User picks. Updates `meta.json.substrate_type` and `status=substrate-selecting` → `contracts-drafting`.
3. **`contracts-drafting`** — Claude loads the substrate type's starter pack and customizes: `workflow.json` and `contracts/*.contract.json` reflect the specific goal. User reviews, asks for changes.
4. **Confirm** — User says "looks good"; Claude flips `status=operating`.
5. **(Optional) `/render`** — Open the browser.

The user can drop back at any point: substrate-selecting → goal-defining (re-pivot the goal), contracts-drafting → substrate-selecting (wrong archetype). The plugin tracks where you are; Claude doesn't have to remember.

### Render (`/render`)
1. Slash command launches the plugin server via Bash if not running.
2. Server validates workspace against meta-schemas; opens browser.
3. Browser connects via WebSocket, renders state.
4. As Claude edits files in the running session, the watcher pushes diffs; the browser updates.

### Propagate change
1. User makes a request. Claude classifies it: which layer (goal/workflow/contract/data/view)?
2. If higher layer, Claude updates downward as needed and logs in `process.md`.
3. Each write is validated against the relevant schema.
4. Contract violations either resolve in place or land in `escapes/`.

---

## Open architectural questions

- **Server runtime**: Node vs Python.
- **Slash command names**: as listed above, but worth a sanity pass.
- **Workspace discovery**: open the cwd, accept an explicit path, or maintain a registry of workspaces?
- **Browser routes**: `/`, `/kind/<kind>`, `/kind/<kind>/<id>`, `/view/<name>`?
- **Validation timing**: write-time only, or also read-time defensive check?
- **Custom view sandboxing**: iframes vs scoped CSS vs Web Components?
- **State machine format**: inlined transitions in the contract (current draft) is fine for v0. Revisit if guards get complex.
- **Migration**: when contracts change, what happens to existing data? Out of scope for v0; revisit when we hit it.
