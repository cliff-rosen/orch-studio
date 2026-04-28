# Operating Model

This document explains how the Living Workspace plugin works from the top down — the whole flow, the data primitives, the state machines, and how the system knows what to do at any moment. It's the conceptual operating system for the rest of the docs.

---

## The system in one sentence

> **The user chats with Claude in a terminal. Claude drives changes through an application substrate backed by well-described JSON files. The plugin renders the substrate live in a browser through custom HTML.**

Everything that follows is implementation of that sentence.

---

## Cast of characters

| Actor | Role |
|---|---|
| **User** | Types in the terminal. Looks at the browser. Knows what the work is. |
| **Terminal** | Runs `claude` (Claude Code). |
| **Claude** | Reads/writes JSON files in the workspace. Follows whichever operating doc is active for the current phase. |
| **Plugin** | Local server. Watches the workspace folder. Validates writes. Renders the dashboard. Pushes live updates. |
| **Browser** | Renders pages composed from widgets. Read-only in v0. |
| **Workspace** | A folder of structured JSON describing one piece of work. |

The user has one mental connection — they talk to Claude. Everything else is plumbing.

---

## Three worlds (where files live)

Three kinds of file content, at three different scopes:

| World | Where | What it is | When it gets touched |
|---|---|---|---|
| **Meta-rules** | `living-workspace-plugin/schemas/` | JSON Schemas describing the shape every workspace and contract must conform to. | Plugin reads on startup. Never copied or modified. |
| **Templates** | `living-workspace-plugin/templates/` | Boilerplate the plugin copies into a workspace at scaffold time: skeleton, blueprints (curated starter compositions), per-primitive contract templates, view descriptors, dashboard template. | Plugin copies during bootstrap. |
| **Live workspace** | `<project>/workspace/` | The user's actual content. Evolving. | Read/written continuously by Claude during operation. |

Schemas validate templates and live data. Templates are starting points. Live data is the user's actual work.

---

## The substrate (what's in a workspace)

A workspace is a folder. Inside it, structured JSON lives under `workspace/`. Narrative log and rendered output live at the project root.

```
<project>/
├── workspace/
│   ├── _contract.json          Workspace contract (lifecycle, required stores, cross-store rules).
│   ├── state.json              Workspace current state (id, status, timestamps).
│   ├── goal.json               The anchor: what this workspace exists to do.
│   ├── manual.md               Operating manual (universal v0; may layer on per-blueprint hints).
│   ├── stores/
│   │   ├── <store-name>/
│   │   │   ├── _contract.json  Store contract (primitive type, schema, rules).
│   │   │   ├── <data files>    Data conforming to the contract; shape varies by primitive.
│   │   │   └── ...
│   │   └── ...
│   ├── pages/
│   │   └── <page-name>.json    Page composition manifests.
│   └── escapes/
│       └── escape-<id>.json    Objects that resist the current contracts.
├── log.md                       Narrative log: decisions, pivots, spine candidates.
└── dashboard.html               Rendered output (the plugin emits this).
```

**The pattern at every level:** a `_contract.json` declares the rules; bare-named files hold the content/data conforming to those rules. Recursive: workspace has a contract; stores have contracts.

---

## The five primitives

Every store is one of five primitive types. The primitive determines the shape of the store's contract and what data it holds.

| Primitive | Holds | Contract shape | Distinguishing feature |
|---|---|---|---|
| **Table** | Structured records (rows × columns) | Row schema + optional state machine + optional references | Indexed access; per-column types; supports per-row state |
| **Document** | Prose body with optional structured metadata | Front-matter schema + body type (markdown) | Single body; ordered prose; section/heading structure |
| **Calendar** | Time-scheduled events | Event schema + recurrence rules + conflict policy | Time-grid semantics; recurrence; conflicts |
| **Tree** | Hierarchical nodes (single parent constraint) | Node schema + hierarchy rules | Acyclic; ordered traversal; expand/collapse |
| **Graph** | Nodes connected by directed, typed edges | Node schema + edge schema + edge type catalog | Cycles allowed; multi-parent; entity-relationship |

**Composition between stores:**

- A **Table** can have a column whose type is **Document**. Each row owns a document body. Sidecar file pattern (`task-001.json` + `task-001.notes.md`).
- A **Document** can embed other stores by reference. The body has tagged regions that the renderer fills with a live store at view time.
- A **Graph** node can hold a Document body or be entirely structured per the node schema.
- **Edges** in a Graph carry their own schema (direction + type + optional fields).

A workspace mixes primitives freely. A research project might have Sources (Table), Memo (Document), Schedule (Calendar), Outline (Tree), People (Graph) all coexisting.

---

## Contracts at two levels

Contracts exist at both the workspace and store level — same pattern, different scope.

### Workspace contract (`workspace/_contract.json`)

Declares:
- **Lifecycle states** — what states this workspace can be in
- **Initial state** — every workspace starts in `goal-defining`
- **Transitions** — valid moves between states, with optional guards
- **Required stores** — stores that must exist before entering certain states
- **Cross-store invariants** — rules spanning multiple stores
- **Workspace-specific workflow** — optional state machine for the work itself

The plugin ships a default workspace contract template (universal lifecycle: `goal-defining → contracts-drafting → operating → archived`). Workspaces inherit it and may extend with custom states/invariants.

### Store contract (`workspace/stores/<name>/_contract.json`)

Polymorphic by primitive type. Carries:

| Primitive | Contract content |
|---|---|
| Table | row schema + states + transitions + references + invariants |
| Document | front-matter schema + body type + embed rules + invariants |
| Calendar | event schema + recurrence + conflict policy + invariants |
| Tree | node schema + hierarchy rules + invariants |
| Graph | node schema + edge schema + edge type catalog + invariants |

### Meta-schemas (validators of contracts)

The plugin ships meta-schemas in `living-workspace-plugin/schemas/`:

- `workspace-contract.schema.json` — validates workspace `_contract.json`
- `state.schema.json` — validates workspace `state.json`
- `goal.schema.json` — validates `goal.json`
- `contracts/table.contract.schema.json` — validates Table store contracts
- `contracts/document.contract.schema.json` — validates Document store contracts
- `contracts/calendar.contract.schema.json` — validates Calendar store contracts
- `contracts/tree.contract.schema.json` — validates Tree store contracts
- `contracts/graph.contract.schema.json` — validates Graph store contracts

The plugin reads `_contract.json.type` first, then picks the right meta-schema.

### Two-level validation

```
Level 1 — contract is well-formed
   _contract.json  →  validated against  the matching meta-schema
   (happens when plugin loads the workspace)

Level 2 — data conforms to its contract
   data files  →  validated against  the local _contract.json
   (happens on every write)
```

Both checks are machine-enforced. Contracts can't decay to advisory comments.

### Invariants

Contracts carry invariants — rules beyond shape that must hold. Example: *"if state == done, completed_at must be set."*

For v0, **invariants are expressed in JSON Schema `if/then/else`**:

```json
{
  "if": { "properties": { "state": { "const": "done" } } },
  "then": { "required": ["completed_at"] }
}
```

Verbose but native — the plugin enforces it for free. We can layer a more concise authoring DSL later that compiles to this if invariants get unwieldy.

---

## The lifecycle

The default workspace lifecycle (declared in the universal workspace contract):

```
goal-defining ─→ contracts-drafting ─→ operating ─→ archived

  Backward transitions:
    contracts-drafting → goal-defining   (revise the goal)
    operating → contracts-drafting       (need to revise rules)
```

- **`goal-defining`** — every workspace starts here. The exit condition is a complete `goal.json`. Until it's complete, no contracts, no data.
- **`contracts-drafting`** — workspace contract + initial store contracts get drafted. Optionally a blueprint is installed from `templates/blueprints/` (curated starter composition with kinds + suggested pages).
- **`operating`** — the long phase. Normal work happens here.
- **`archived`** — terminal. Read-only.

A workspace can extend this with custom states in its `_contract.json`. E.g., a single-deliverable workspace might add `wrapping-up` between `operating` and `archived`. A research workspace might add `synthesizing` parallel to `operating`.

The plugin enforces basic structural invariants (must start in `goal-defining`; `archived` is terminal) but otherwise the lifecycle is workspace-defined.

---

## State machines (multiple, at different scopes)

Several state machines coexist:

1. **Workspace lifecycle** — declared in `workspace/_contract.json`, current state in `workspace/state.json.status`.
2. **Per-store state machines** — declared in each store's `_contract.json` (only relevant for state-machine-flavored kinds like Tasks). Current state per row.
3. **Workflow stages** (optional) — workspace-level stages of the work itself, declared in the workspace contract.
4. **The operating loop** (implicit) — the rhythm during operating: user message → understand → check structural change → act → validate → render.

---

## Branch points

Where user choices or system conditions change the path.

| Branch | When | What's at stake |
|---|---|---|
| **Goal completion** | Exiting `goal-defining` | Until the goal is complete, no further structure can be built. |
| **Blueprint pick** (optional) | During `contracts-drafting` | Choose a curated starter composition (kinds + pages) or build from scratch. Blueprints are convenience, not commitment. |
| **Lifecycle pivots** | Anywhere | Backward transitions when goal or contracts need revision. |
| **Structural-change gate** | Every operating message | If the request would change the rules (contract, workflow, goal), pause and confirm. Otherwise, just act. |
| **Schema-fit** | When data resists a contract | Force-fit (wrong) / flag as escape (kept raw with a why-not note) / evolve the contract (Branch: structural-change gate fires). |

---

## The operating loop (during `operating`)

```
1. User says something.
2. Claude understands the request.
3. Claude considers: would satisfying this change the rules?
     ├── NO  → act, validate, render.
     └── YES → confirm with user first, then act.
4. If structural change happened, append to log.md.
```

That's the whole operating discipline. Most user messages don't change rules — they're queries, data operations, view tweaks. Claude just acts.

The five-layer structural model (Goal / Workflow / Contracts / Data / Views) is **vocabulary** Claude uses to *describe* what would change when a structural change is implied. It's not a routing tree for every message.

---

## How Claude knows what to do at any moment

The meta-protocol — what `CLAUDE.md` enforces:

```
On every interaction:

1. Read state.json → get current status.
2. Route:
     status ∈ {goal-defining, contracts-drafting}
       → follow living-workspace-plugin/bootstrap.md
     status ∈ {operating, custom-operating-states}
       → follow workspace/manual.md
     status = archived
       → refuse mutating actions
3. Validate every write against the relevant meta-schema and the relevant _contract.json.
4. Log structural changes to log.md.
```

`CLAUDE.md` is a tiny router. The actual instructions live in `bootstrap.md` (universal) and `workspace/manual.md` (per-workspace).

---

## Pages and rendering

The dashboard is composed at render time from **widgets** that render **stores**.

- **Widgets** are reusable HTML+CSS components (smart-table, kanban, cards, list, detail, calendar, timeline, document, outline, tree, graph). Each widget knows what primitive(s) it can render.
- **Pages** are compositions of widgets. A page descriptor in `workspace/pages/<name>.json` declares which widgets to render, in what order, against which stores.
- **The dashboard** is just the default page (`workspace/pages/dashboard.json`).

A workspace can have many pages. The browser navigates between them.

Per-phase shell pieces (lifecycle strip, "what's happening" callout, goal banner) are rendered as appropriate components composed alongside the page content. Layouts for these phase-aware shell elements live in the plugin's `templates/layouts.json`.

Storage:

```
workspace/pages/
├── dashboard.json     default landing
├── outline.json       custom view
└── timeline.json
```

---

## Visual: the data flow

```
                      ┌────────────┐
                      │    USER    │
                      └──┬──────┬──┘
                  types  │      │  watches
                  in     │      │
                         ▼      ▼
                ┌──────────┐  ┌──────────┐
                │ TERMINAL │  │ BROWSER  │
                │ (claude) │  │  (pages) │
                └────┬─────┘  └─────▲────┘
                     │              │
            reads/   │              │  pushes
            writes   │              │  live
            files    │              │  updates
                     ▼              │
            ┌──────────────────────┴──┐
            │   workspace/ folder      │
            │   (contracts + stores +   │
            │    state + goal + pages)  │
            └─────────────┬─────────────┘
                          │
                  watched by
                          ▼
                    ┌──────────────┐
                    │   PLUGIN     │
                    │  (server,    │
                    │   validator, │
                    │   renderer)  │
                    └──────────────┘
```

User has one input channel (terminal), one output (browser). Substrate is truth. Plugin bridges substrate to browser. Claude bridges user intent to substrate.

---

## Why this design works

- **Symmetric contracts** at workspace and store levels. Same pattern at both scopes — easier to reason about.
- **Polymorphic stores** with five primitives + composition. Mix freely; no upfront classification of the workspace as a whole.
- **Two-level machine-checked validation.** Bad contracts fail at load time. Bad data fails at write time. Substrate stays trustworthy across long sessions.
- **Lifecycle is data, not code.** The workspace contract defines its own lifecycle; the plugin enforces structural invariants but workspaces can extend.
- **Substrate is the source of truth.** Browser closes, workspace is intact. Claude session restarts, reads `state.json`, knows where it is.
- **The user only talks to Claude.** No state management, no separate setup mode.

---

## Where each piece lives

```
living-workspace-plugin/
├── README.md                           Orient and navigate.
├── operating-model.md                  (this file) Top-down conceptual model.
├── architecture.md                     Detailed design reference.
├── CLAUDE.md                           Always-loaded router. (TODO)
├── bootstrap.md                        Universal Phase 1+2 instructions. (TODO)
├── schemas/
│   ├── workspace-contract.schema.json
│   ├── state.schema.json
│   ├── goal.schema.json
│   └── contracts/
│       ├── table.contract.schema.json
│       ├── document.contract.schema.json
│       ├── calendar.contract.schema.json
│       ├── tree.contract.schema.json
│       └── graph.contract.schema.json
└── templates/
    ├── workspace-skeleton/             What /scaffold copies.
    │   └── workspace/
    │       ├── _contract.json          Default workspace contract (universal lifecycle)
    │       ├── state.json              Initial state (status: goal-defining)
    │       ├── goal.json               (empty placeholders)
    │       └── manual.md               Universal operating manual
    ├── blueprints/                     Curated starter compositions (kinds + pages).
    │   └── <blueprint-name>/           e.g., personal-todo, research-project, content-pipeline
    ├── store-contracts/                Per-primitive contract templates.
    │   ├── table.json
    │   ├── document.json
    │   ├── calendar.json
    │   ├── tree.json
    │   └── graph.json
    ├── widgets/                        (was: views/) Widget descriptor templates.
    └── components/                     Dashboard composition fragments.
```

---

## Outstanding work

The design is settled; implementation has gaps. The most consequential:

1. **`CLAUDE.md`** — the router that pins Claude to read `state.json` and route to the right doc. Smallest, most load-bearing missing piece.
2. **`bootstrap.md`** — universal goal-defining and contracts-drafting instructions.
3. **Per-primitive contract meta-schemas** — currently we have one `contract.schema.json`; design calls for five.
4. **Blueprints** — at least one (e.g., personal-todo) to replace what was the substrate-type starter pack.
5. **Page rendering and layouts** — the page concept is designed but not built; current dashboards are full-HTML mock-ups, not page-composition outputs.
6. **File renames in existing artifacts** — `meta.json` → `state.json`, primitive folder restructure for the master-todo example, retire substrate-type references.

These are the next concrete builds.
