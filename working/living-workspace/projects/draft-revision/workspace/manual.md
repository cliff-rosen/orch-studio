# Operating Manual

The universal operating manual. Once `state.status` is `operating`, see `method.md` for orchestration specific to this document-revision work.

## The operating loop

On every user message:

1. Understand the request.
2. Consider: would satisfying it change the rules (workspace contract, a store contract, the goal)?
   - **No** → act, validate against contracts, render.
   - **Yes** → confirm with the user before acting. Surface what would change.
3. If a structural change happened, append an entry to `log.md`.

## Escapes / Spine

Standard discipline. Things that don't fit current contracts go to `escapes/`. Recurring patterns get proposed for promotion.
