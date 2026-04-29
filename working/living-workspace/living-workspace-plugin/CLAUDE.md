# Living Workspace Plugin — Operating Protocol

This file is loaded automatically on every interaction. It's a router. The actual operating instructions live in `bootstrap.md` (during early lifecycle states) or `workspace/manual.md` (during operating states).

## On every user message

### 1. Read `workspace/state.json` to get current `status`.

### 2. Route based on status:

```
status ∈ { goal-defining, contracts-drafting }
   → follow living-workspace-plugin/bootstrap.md

status ∈ { operating, wrapping-up }
   → follow workspace/manual.md
   → also consult workspace/method.md if present (blueprint methodology)

status = archived
   → read-only mode. Refuse any mutating action.
   → if user wants to revive, propose a state transition first.
```

### 3. Validate every write.

Before committing any file change:
- Workspace contract changes → validate against `living-workspace-plugin/schemas/workspace-contract.schema.json`
- State changes → validate against `schemas/state.schema.json`
- Goal changes → validate against `schemas/goal.schema.json`
- Store contract changes → look up the store's primitive type, validate against the matching schema in `schemas/contracts/<type>.contract.schema.json`
- Data writes → validate against the relevant store's `_contract.json`

If a write would violate any of these, refuse and surface the violation.

### 4. Log structural changes.

After any change to a contract (workspace or store), the goal, or the workflow, append an entry to `log.md` (project root, not inside `workspace/`). Include: timestamp, what changed, why.

Don't log routine data writes. Only structural change.

## Universal rules (always apply, regardless of state)

- **The substrate is the source of truth.** Every write goes through validation. Never bypass.
- **Don't fabricate state transitions.** If a transition would happen, surface it to the user first. Status changes are explicit.
- **Don't quietly evolve contracts.** Adding fields, changing states, introducing new stores — all of these are structural changes. Confirm before acting.
- **Schema-fit awareness.** When data resists current contracts, propose an escape (`workspace/escapes/`) or a contract change. Never force-fit.
- **Read before write.** When working with existing data, read the current state from disk before making changes.

## Where to find things

- Top-down design: `living-workspace-plugin/operating-model.md`
- Detailed reference: `living-workspace-plugin/architecture.md`
- User-facing reference: `living-workspace-plugin/reference/index.html`
- Phase-specific instructions: `bootstrap.md` (this folder) or `workspace/manual.md`
- Per-blueprint methodology: `workspace/method.md` (if installed)

## What this file is not

- It is **not** the place for operating instructions. Those live in `bootstrap.md` and `manual.md`.
- It is **not** the place for substrate description. That lives in `operating-model.md`.
- It is a router. Keep it short. Keep it stable.
