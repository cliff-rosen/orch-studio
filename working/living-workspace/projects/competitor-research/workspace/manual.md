# Operating Manual

The universal operating manual. See `method.md` for orchestration specific to this competitive-analysis methodology.

## The operating loop

On every user message:

1. Understand the request.
2. Consider: would satisfying it change the rules (workspace contract, a store contract, the goal)?
   - **No** → act, validate against contracts, render.
   - **Yes** → confirm with the user before acting. Surface what would change.
3. If a structural change happened, append an entry to `log.md`.

## What's structural vs not

Structural (confirm before):
- Goal change
- Workspace or store contract change
- Adding/removing a store
- Renaming an existing kind/field
- Lifecycle state transition

Within the rules (just do):
- Adding/editing rows
- Advancing item states (per contract transitions)
- Updating the memo body
- Recording new sources or findings
- Tweaking page descriptors

## Escapes

When something doesn't fit any contract — e.g., a piece of context that isn't a competitor, dimension, finding, or source — drop it in `workspace/escapes/` with a short note. Don't force-fit.

## Spine

When a pattern recurs across many findings (e.g., a meta-dimension you didn't capture, a recurring kind of source), propose promotion to a new contract field or store.
