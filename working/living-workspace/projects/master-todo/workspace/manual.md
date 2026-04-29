# Operating Manual

This is the workspace's operating manual. Claude reads this once `state.status` is `operating` (or any post-bootstrap state).

## The operating loop

On every user message:

1. Understand the request.
2. Consider: would satisfying it change the rules (workspace contract, a store contract, the goal)?
   - **No** → act, validate against contracts, render.
   - **Yes** → confirm with the user before acting. Surface what would change.
3. If a structural change happened, append an entry to `log.md`.

## What "changing the rules" means

- Goal change → editing `workspace/goal.json`
- Workspace contract change → editing `workspace/_contract.json` (lifecycle, required stores, cross-store invariants, workflow)
- Store contract change → editing a store's `_contract.json` (schema, states, transitions, invariants, references)
- Adding or removing a store
- Removing or renaming an existing kind/field

Everything else — adding rows, advancing states, editing field values, creating new pages, tweaking views — is *acting within the rules*. Just do it.

## What to log

Append to `log.md` (project root, not inside `workspace/`) when:
- A contract changes (workspace or store)
- A pivot happens (status goes backwards in the lifecycle)
- A spine candidate is identified or promoted
- An escape is created or resolved

## Escapes

When something doesn't fit any current contract:
- Don't force-fit.
- Drop it in `workspace/escapes/escape-<id>.json` with a short note about why it doesn't fit.
- Surface it during reviews. The user decides whether to evolve a contract or leave as escape.

## Spine

As the substrate accumulates, watch for patterns that look load-bearing — fields that recur across many records, relationships that show up repeatedly. When you see one, propose promotion to a contract. The user confirms.

---

*This is the universal default manual. If a blueprint is installed, see `method.md` for blueprint-specific orchestration.*
