# Living Workspace Plugin — Architecture

Stakes-in-the-ground for v0. Open questions consolidated at the bottom.

---

## Model discipline

The plugin only earns its keep if Claude reasons in layers. The substrate layout, the slash commands, and the contracts are all designed to keep Claude pinned to this discipline:

```
Goal → Workflow → Contract → Data → Views
```

- **Goal.** A short, durable anchor in `goal.json`. Reread when orientation drifts; changes rarely.
- **Workflow.** Stages and transitions in `workflow.json`. State-machine-flavored.
- **Contract.** Schema + states + transitions + invariants per kind. The load-bearing layer. Machine-readable so the plugin can enforce.
- **Data.** Instances of the schema, evolving per the contract. Folder-per-kind, file-per-instance.
- **Views.** Derived, not authored. Plugin ships generic widgets; custom views are HTML Claude generates against a known contract.

Five operating rules:

1. **Bootstrap top-down.** First session, vague request: elicit the goal, pick the substrate type, sketch contracts — *before* generating data or views.
2. **Classify every request.** Each user message lands at one of the layers. *"Add credibility tag to sources"* is contract. *"Show items stuck in 'extracted' for 3+ days"* is view. *"It's a board deck now"* is goal. Classification determines propagation.
3. **Propagate top-down.** Goal change ripples through workflow, contract, data, views. Don't patch the bottom when the change is at the top.
4. **Flag schema-fit.** Real work generates objects that resist the current contract. Mark them as escapes / candidates; don't mash them into something close-but-wrong.
5. **Identify spine.** As the substrate accumulates, propose what's load-bearing for promotion to contract. The user confirms; the contract evolves.

This discipline is the operating system of the plugin's value. The substrate layout encodes it; `CLAUDE.md` (TODO — see open questions) makes it executable.

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
<project>/
├── workspace/                      All structured JSON lives under here.
│   ├── meta.json                   Workspace identity + lifecycle state.
│   ├── goal.json                   The anchor.
│   ├── workflow.json               Stages + transitions.
│   ├── contracts/
│   │   ├── <kind>.json             One file per kind.
│   │   └── ...
│   ├── data/
│   │   ├── <kind-plural>/
│   │   │   ├── <id>.json           One file per instance.
│   │   │   └── ...
│   │   └── ...
│   ├── views/
│   │   ├── <name>.json             View descriptor.
│   │   └── <name>.html             Custom HTML view (when generic doesn't suffice).
│   └── escapes/
│       └── escape-<id>.json        Objects that resist the current contract.
├── process.md                      Narrative log: decisions, pivots, spine candidates.
└── dashboard.html                  Rendered output (the plugin emits this).
```

**Rule of thumb.** Structured JSON lives under `workspace/`. Narrative (`process.md`) and rendered output (`dashboard.html`) live at the project root. Folder location identifies file type, so filenames don't need redundant suffixes (`contracts/task.json`, not `contracts/task.contract.json`).

---

## Meta-schemas (invariant across all workspaces)

Five JSON Schemas define the skeleton of every workspace. Canonical definitions live in [`schemas/`](./schemas/).

| Schema | What it validates | Required keys |
|---|---|---|
| [`meta.schema.json`](./schemas/meta.schema.json) | Workspace identity + lifecycle | `workspace_id`, `created_at`, `status`, `meta_schema_version` |
| [`goal.schema.json`](./schemas/goal.schema.json) | The anchor | `purpose`, `deliverable`, `success_criteria` |
| [`workflow.schema.json`](./schemas/workflow.schema.json) | Stages + transitions | `stages`, `transitions` |
| [`contract.schema.json`](./schemas/contract.schema.json) | A domain contract's shape (the most important meta-schema) | `kind`, `schema` |
| [`view.schema.json`](./schemas/view.schema.json) | View descriptor | `name`, `view_type` |

Notable shape decisions captured in those files:

- **Status enum** spans the full lifecycle: `goal-defining`, `substrate-selecting`, `contracts-drafting`, `operating`, `wrapping-up`, `archived`.
- **Substrate type enum**: `ongoing-system`, `single-deliverable`, `pipeline`, `tracker`, `project-plan`, `hybrid`.
- **Contract** carries `states`, `initial_state`, `transitions` (with optional `guard`), and `references` (foreign-key-like links between kinds).
- **View descriptor** has a polymorphic `config` whose shape varies by `view_type`. Smart-table columns support `mode: data | computed | enriched | manual`.

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

The plugin ships skeletons, not domain knowledge. Contracts are always fabricated per-workspace by Claude; the plugin provides the boilerplate. All in [`templates/`](./templates/) — see [`templates/README.md`](./templates/README.md) for the layout.

| Path | Purpose |
|---|---|
| [`templates/dashboard.template.html`](./templates/dashboard.template.html) | Canonical dashboard render. Plugin substitutes workspace data into placeholders. |
| [`templates/workspace-skeleton/`](./templates/workspace-skeleton/) | What `/scaffold` copies into an empty folder. Empty placeholder values; bootstrap conversation fills them. |
| [`templates/starter-packs/<substrate-type>/`](./templates/starter-packs/) | Per substrate type: default `workflow.json` + suggested contracts + default views. Loaded after the user picks a substrate type. |
| [`templates/contracts/`](./templates/contracts/) | Boilerplate contract patterns: stateless, stateful, hierarchical. |
| [`templates/views/`](./templates/views/) | View descriptor templates per widget type (smart-table, kanban, list, detail, dashboard). |

**Status of starter packs.** `ongoing-system` exists (matches the master-todo example). The other five (`single-deliverable`, `pipeline`, `tracker`, `project-plan`, `hybrid`) are open work — see "Open questions → Most consequential."

**Default views (no descriptors present).** When `views/` is empty, the plugin falls back to substrate-type defaults:
- `ongoing-system`: smart-table + kanban + dashboard
- `single-deliverable`: outline + cards + dashboard
- `pipeline`: kanban + smart-table
- `tracker`: timeline + smart-table
- `project-plan`: tree + timeline + dashboard
- `hybrid`: dashboard + smart-table

Workspaces can override by dropping a view descriptor in `views/`.

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

## Open questions

### Most consequential (v0 load-bearing gaps)

1. **`CLAUDE.md` and slash command bodies.** The discipline made executable. We have the design for what Claude *should* do; we don't have the prompt that makes it do that. Without this, nothing else works.
2. **Invariant / guard expression language.** Today invariants and guards are prose strings. Without machine-checkable rules, contracts decay to advisory comments and the plugin can't enforce. Approaches: JSON Schema `if/then/else`, a small predicate DSL, or generated JS predicates per contract.
3. **Substrate-type starter packs.** Each substrate type needs concrete `workflow.json` + `contracts/*.contract.json` boilerplate, otherwise the bootstrap conversation has nothing to load.
4. **ID generation + referential integrity.** Who assigns `task-001`? Who checks that `task.area = "area-001"` points to a real area? At what timing?
5. **Default rendering with no views.** What does the plugin show when `views/` is empty? This is what most users see most of the time, and currently undefined.

### Substrate concerns

- **Prose-heavy data.** When a kind's primary content is a 500-word body, JSON-with-`body`-field is brutal to hand-edit. Sidecar `.md`? Folder-per-instance with `body.md` plus `meta.json`?
- **Atomic / concurrent writes.** Claude writes file A while user edits A by hand; or one operation needs to update several files atomically.
- **Cascading deletes.** Area deleted, tasks reference it. Forbid? Cascade-null? Cascade-delete?
- **Binary attachments.** Images, PDFs. Where, and how referenced from JSON?
- **Schema evolution.** When contracts change, what happens to existing data? Punted for v0; flag for revisit.

### Rendering & widgets

- **URL structure / routing.** `/`, `/kind/<kind>`, `/view/<name>`, `/kind/<kind>/<id>`?
- **View state persistence.** Sort/filter/hidden columns — ephemeral, saved-to-descriptor, or per-user-preference?
- **View composition.** Can a dashboard contain a smart-table tile?
- **Custom HTML view security.** Iframe sandbox, scoped CSS, or strict CSP? Big call.
- **Reactivity granularity.** Whole-workspace refresh vs per-view diffs.

### Live update loop

- **Half-written files.** Watcher fires on partial JSON; parser breaks. Atomic-rename pattern, or debounce?
- **Conflict resolution.** Browser has unsaved local edit; file change arrives.
- **Activity feed.** Should the user see *"Claude wrote task-003"* as a stream?

### Action routing (browser → Claude)

- **Click-to-copy UX.** Prompt format, preview-before-copy.
- **Bulk action protocol.** 5 selected tasks → 1 prompt or 5? How does the user verify?
- **Structured invocation.** Could a button-click write a small `pending-action.json` Claude polls, instead of free-text routing?

### Lifecycle / persistence

- **Server lifecycle.** Shut down on terminal exit? Idle? User-controlled?
- **Crash recovery.** Server dies mid-write; state on disk vs server memory.
- **Undo / history.** File system has none. Rely on user's git, or maintain plugin snapshots?
- **Audit log.** What got written, by whom, when.

### Plugin shape

- **Packaging / install flow.** Manifest format, distribution channel, runtime requirements.
- **Runtime.** Node vs Python.
- **Workspace discovery.** Open cwd, explicit path, or registry of workspaces?

### Out of scope for v0

- Back channel that injects prompts into the running Claude Code session
- Multi-user collaboration
- Hosted / cloud version
- Migrations between contract versions
- Cross-workspace references
- Mobile / responsive
