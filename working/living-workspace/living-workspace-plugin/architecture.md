# Living Workspace Plugin — Architecture

Detailed design reference. The top-down conceptual model is in [`operating-model.md`](./operating-model.md); this doc covers implementation details — components, validators, plugin server, runtime concerns, open questions.

---

## Components

### Server-side (runs locally)

| Component | Job |
|---|---|
| **HTTP server** | Serves the SPA + static assets. Default `localhost:7000`. |
| **WebSocket server** | Pushes file system changes to the browser in real time. |
| **File watcher** | Watches the workspace folder. Knows which files map to which schema (workspace contract, store contracts, page descriptors, data files). Debounces rapid edits. |
| **Schema registry** | Loads the meta-schemas from `schemas/`. Validates structural files on read and write. |
| **Contract validator** | Reads each store's `_contract.json` and validates data writes within that store. Polymorphic by primitive type. |
| **Page renderer** | Given a page descriptor and the active layout, composes chrome + page body into HTML. |
| **Lifecycle resolver** | Reads `state.status`; looks up the corresponding chrome composition in `layouts.json`. |

Runtime open question: Node.js (familiar, NPM ecosystem, easier SPA bundling) vs Python (lower deps, stdlib-friendly). Probably Node — better for the WebSocket story and the JS-friendly templating.

### Client-side (browser)

| Component | Job |
|---|---|
| **WebSocket client** | Subscribes to workspace changes. |
| **State store** | Mirrors the file system in browser memory. |
| **Widget set** | Generic interactive components. See *Widgets* section. |
| **Chrome components** | Lifecycle-aware shell pieces (shell-bar, goal-banner, phase-strip, etc.) from `templates/components/`. |
| **Custom view embedder** | Renders Claude-generated HTML for one-offs. Sandboxed per-widget instance. |
| **Schema-driven editor** | (later) Forms generated from contract schemas for direct manipulation. |

### Claude Code integration

- **Slash commands** (`.claude/commands/*.md`):
  - `/scaffold` — bootstrap a new workspace (drives goal-elicitation + blueprint selection)
  - `/render` — start the local server, open browser
  - `/spine` — propose load-bearing patterns for promotion to contract
  - `/escape` — flag an object that doesn't fit the current contract
  - `/promote` — promote an escape or spine candidate to a contract
- **`CLAUDE.md`** — always-loaded router. Reads `state.status`, dispatches to `bootstrap.md` or `workspace/manual.md`. See `living-workspace-plugin/CLAUDE.md`.
- **`bootstrap.md`** — universal Phase 1+2 instructions. Walks goal-defining and contracts-drafting (with blueprint installation procedure).
- **No MCP server in v0.** Slash commands + file conventions are enough.
- **No hooks in v0.** File watcher catches what we need.

---

## The five primitives

Every store in a workspace is one of five primitive types. The primitive determines the shape of the store's contract and what data it holds.

| Primitive | Holds | Contract sections | Examples |
|---|---|---|---|
| **Table** | Structured records (rows × columns) | row schema + states + transitions + references + invariants + document_columns | Tasks, Sources, Contacts |
| **Document** | Prose body with optional structured front-matter | front_matter_schema + body_type + embeds + invariants | Memo, Spec, Notes |
| **Calendar** | Time-scheduled events | event_schema + recurrence_rules + conflict_policy + invariants | Schedule, Deadlines |
| **Tree** | Hierarchical nodes (single parent constraint) | node_schema + parent_field + max_depth + ordered + invariants | Outline, Concept hierarchy |
| **Graph** | Nodes + directed typed edges | node_schema + edge_schema + edge_types + invariants | People network, Decision graph |

**Composition between stores:**

- A Table can have a column whose type is Document — sidecar `.md` file pattern.
- A Document can embed other stores by reference — render-time substitution at body block tags.
- A Graph node can hold a Document body or be entirely structured per the node schema.
- Edges in a Graph carry their own schema (direction + type + optional fields).

---

## Storage layout

```
<project>/
├── workspace/                      All structured JSON lives under here.
│   ├── _contract.json              Workspace contract (lifecycle, required stores, cross-store rules).
│   ├── state.json                  Workspace current state.
│   ├── goal.json                   The anchor.
│   ├── manual.md                   Universal operating manual.
│   ├── method.md                   (optional) Blueprint-specific orchestration.
│   ├── stores/
│   │   ├── <store-name>/
│   │   │   ├── _contract.json      Store contract (primitive type, schema, rules).
│   │   │   └── <data files>        Shape varies by primitive type.
│   │   └── ...
│   ├── pages/
│   │   └── <page-name>.json        Page descriptor (rows of widgets).
│   └── escapes/
│       └── escape-<id>.json
├── log.md                          Narrative log: decisions, pivots, spine candidates.
└── dashboard.html                  Plugin-rendered output.
```

**Filename convention.** Underscore prefix marks structural metadata (`_contract.json`). Bare names hold content/data. Folder location identifies type — no need for redundant suffixes (`task.json` not `task.contract.json`; folder location says it's a contract).

**Per-primitive data file conventions:**
- Table: one file per row (`<id>.json`); optional sidecar files for document/file columns
- Document: `body.md` plus optional front-matter section in `_contract.json`
- Calendar: one file per event (`evt-<id>.json`)
- Tree: one file per node (`node-<id>.json`) with parent reference
- Graph: `nodes/<id>.json` + `edges/<id>.json` subfolders

---

## Meta-schemas

Eight meta-schemas in [`schemas/`](./schemas/) — the validators the plugin reads on startup.

| Schema | Validates | What it checks |
|---|---|---|
| [`workspace-contract.schema.json`](./schemas/workspace-contract.schema.json) | `workspace/_contract.json` | Lifecycle states + transitions, initial state, required stores, workflow, cross-store invariants. |
| [`state.schema.json`](./schemas/state.schema.json) | `workspace/state.json` | Workspace identity, current status, blueprint reference. |
| [`goal.schema.json`](./schemas/goal.schema.json) | `workspace/goal.json` | Required goal fields (purpose, deliverable, success_criteria). |
| [`page.schema.json`](./schemas/page.schema.json) | `workspace/pages/<name>.json` | Page descriptor: rows of widget specs, each referencing a store. |
| [`contracts/table.contract.schema.json`](./schemas/contracts/) | Table store contracts | Row schema, states, transitions, references, document_columns, invariants. |
| [`contracts/document.contract.schema.json`](./schemas/contracts/) | Document store contracts | Front-matter schema, body_type, embeds. |
| [`contracts/calendar.contract.schema.json`](./schemas/contracts/) | Calendar store contracts | Event schema, recurrence rules, conflict policy. |
| [`contracts/tree.contract.schema.json`](./schemas/contracts/) | Tree store contracts | Node schema, parent_field, depth/branching constraints. |
| [`contracts/graph.contract.schema.json`](./schemas/contracts/) | Graph store contracts | Node schema, edge schema, edge_types catalog. |

Plugin reads `_contract.json.type` first, then picks the right contract meta-schema.

---

## Two-level validation

```
Level 1 — contract is well-formed
   _contract.json  →  validated against  matching meta-schema
   (happens when plugin loads the workspace)

Level 2 — data conforms to its contract
   data files  →  validated against  the local _contract.json
   (happens on every write)
```

Both checks are machine-enforced. Malformed contracts fail at level 1; bad writes fail at level 2.

---

## Invariants

Beyond shape (handled by JSON Schema's basic constructs), contracts can declare conditional rules — *"if state == done, completed_at must be set."*

For v0, **invariants are expressed in JSON Schema `if/then/else`**:

```json
{
  "description": "If state is done, completed_at must be set.",
  "rule": {
    "if": { "properties": { "state": { "const": "done" } } },
    "then": { "required": ["completed_at"] }
  }
}
```

Verbose but native — the plugin enforces this for free using any JSON Schema validator. We can layer a more concise authoring DSL later that compiles to this if invariants get unwieldy.

---

## Widgets

A view isn't just rendering — it's an interactive surface. The plugin ships a set of **widgets**: generic components that know how to display a specific shape of data and what behaviors they offer.

| Widget | Renders | Required field | Behaviors |
|---|---|---|---|
| `smart-table` | Table | — | Sortable/filterable/hideable columns; inline edit; bulk actions; computed/enriched/manual column add |
| `kanban` | Table | state field | Columns are states; cards are rows; drag = state transition (validated against contract) |
| `cards` | Table | — | Visual grid of preview cards |
| `list` | Table | — | Compact single-line rows; group-by support |
| `detail` | Table | — | Single row view with all fields; state transition buttons |
| `calendar` | Calendar (or Table with date+duration) | start, end | Time-grid; drag to reschedule |
| `timeline` | Table with date field, or Calendar | date field | Items positioned by time, zoom levels |
| `document` | Document | — | Rendered prose with outline navigation |
| `outline` | Tree or Document | — | Collapsible hierarchy; drag-reparent |
| `tree` | Tree | — | Tree visualization, expand/collapse |
| `graph` | Graph | — | Node-link visualization (force-directed or hierarchical) |
| `file-browser` | Any store | — | File-system view of the store's folder. Shows files, sidecars, file metadata. Useful for stores that hold raw files, attachments, or where the file structure carries meaning. |
| `custom` | Any store | — | Renders Claude-generated HTML in a sandboxed iframe |

Widgets compose into pages. The same store can be rendered by multiple widgets across pages.

### Widget configuration

Each widget has its own config schema (per-widget). The page descriptor's `widgets[].config` carries the matching config:

```json
{
  "widget": "smart-table",
  "store": "stores/tasks",
  "config": {
    "columns": [
      { "field": "title" },
      { "field": "due" },
      { "field": "age_days", "mode": "computed", "expression": "today - created_at" }
    ],
    "filters": { "state": ["next", "doing"] },
    "sort": { "field": "due", "direction": "asc" }
  }
}
```

### Smart-table column modes

- **`data`** (default) — direct from the row's field
- **`computed`** — formula over existing fields. View-side only. Cheap, dynamic.
- **`enriched`** — Claude walks each row and writes a value. Persistent. Expensive (one LLM call per row).
- **`manual`** — empty new field; user fills in. Becomes part of the contract.

---

## Pages and chrome

Two layers compose to make a workspace dashboard:

| Layer | Source | Driver |
|---|---|---|
| **Chrome** | `templates/components/` + `layouts.json` | Workspace lifecycle status |
| **Body** | `workspace/pages/<active-page>.json` | The page descriptor |

The plugin reads `state.status`, looks up the chrome composition in `layouts.json`, looks up the active page in `workspace/pages/`, and composes the two.

```
Chrome (lifecycle-driven)        Body (workspace-driven)
┌────────────────────┐
│ shell-bar          │
│ goal-banner        │
│ workflow-strip     │
├────────────────────┤
│ page-body          │←  rows of widgets from active page descriptor
├────────────────────┤
│ workspace-internals│
└────────────────────┘
```

---

## Lifecycle

Default lifecycle (declared in the universal workspace contract template):

```
goal-defining → contracts-drafting → operating → archived
```

Backward transitions allowed: `contracts-drafting → goal-defining`, `operating → contracts-drafting`. Workspaces can extend with custom states (e.g., `wrapping-up` between operating and archived for single-deliverable patterns).

The plugin enforces basic structural invariants — every workspace must start in goal-defining; archived must be terminal — but otherwise the lifecycle is workspace-defined via `_contract.json`.

---

## Process flows

### Bootstrap (`/scaffold`)

1. **`goal-defining`** — Claude reads `bootstrap.md`, drives goal-elicitation. Writes `goal.json` and updates `state.json`. Exit when goal validates and user confirms.
2. **`contracts-drafting`** — Claude offers blueprints (or "start blank"). On selection, copies the blueprint into the workspace (workspace contract, store contracts, pages, method.md). Customizes with the user. Exit when user approves.
3. **`operating`** — Claude flips status; from now on, follows `workspace/manual.md` (and `method.md` if installed).

### Render (`/render`)

1. Slash command launches the plugin server via Bash.
2. Server validates the workspace against meta-schemas; opens browser.
3. Browser connects via WebSocket, renders state.
4. As Claude edits files, watcher pushes diffs; browser updates.

### Operating loop

1. User says something.
2. Claude understands the request.
3. Claude considers: would satisfying this change the rules?
   - **No** → act, validate, render.
   - **Yes** → confirm with user first, then act.
4. If structural change, append to `log.md`.

---

## Open questions

### Most consequential (v0 load-bearing gaps)

1. **Per-widget config schemas.** Page descriptor validates the `widgets[]` array shape, but each widget's config is currently `type: object` (anything goes). Need per-widget config schemas to validate column specs, filter shapes, etc.
2. **ID generation + referential integrity.** Who assigns `task-001`? Who checks that `task.area` points to a real area at write time? At what timing?
3. **Default rendering with no pages.** What does the plugin show when `pages/` is empty? Probably auto-generates a per-store smart-table.
4. **Cross-store invariants in machine-readable form.** Workspace-level cross-store invariants are currently prose strings. JSON Schema if/then doesn't naturally span multiple files.

### Substrate concerns

- **Atomic / concurrent writes.** Claude writes file A while user edits A by hand; or one operation needs to update several files atomically.
- **Cascading deletes.** Area deleted, tasks reference it. Forbid? Cascade-null? Cascade-delete?
- **Binary attachments.** Images, PDFs in source-heavy workspaces. Where, and how referenced from JSON?
- **Schema evolution.** When contracts change, what happens to existing data? Punted for v0.

### Rendering & widgets

- **URL routing.** `/`, `/page/<name>`, `/store/<name>`, `/store/<name>/<id>`?
- **View state persistence.** Sort/filter/hidden columns — ephemeral, saved-into-descriptor, or per-user-preference?
- **Custom HTML view security.** Iframe sandbox, scoped CSS, or strict CSP? Big call.
- **Reactivity granularity.** Whole-workspace refresh vs per-widget diffs.

### Live update loop

- **Half-written files.** Watcher fires on partial JSON; parser breaks. Atomic-rename pattern, or debounce?
- **Conflict resolution.** Browser has unsaved local edit; file change arrives.
- **Activity feed.** Should the user see *"Claude wrote task-003"* as a stream?

### Action routing (browser → Claude)

- **Click-to-copy UX.** Prompt format, preview-before-copy.
- **Bulk action protocol.** 5 selected → 1 prompt or 5? How does the user verify?
- **Structured invocation.** Could a button-click write `pending-action.json` Claude polls, instead of free-text?

### Lifecycle / persistence

- **Server lifecycle.** Shut down on terminal exit? Idle? User-controlled?
- **Crash recovery.** Server dies mid-write; state on disk vs server memory.
- **Undo / history.** File system has none. Rely on user's git, or maintain plugin snapshots?
- **Audit log.** Granular log of what was written, by whom, when.

### Plugin shape

- **Packaging / install flow.** Manifest format, distribution channel.
- **Runtime.** Node vs Python.
- **Workspace discovery.** Open cwd, explicit path, or registry of workspaces?

### Out of scope for v0

- Back channel that injects prompts into the running Claude Code session
- Multi-user collaboration
- Hosted / cloud version
- Migrations between contract versions
- Cross-workspace references
- Mobile / responsive layouts
