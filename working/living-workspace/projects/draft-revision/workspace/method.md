# Method — Document-Intensive, Emergent

This workspace doesn't have a prescribed pipeline. The work is emergent: think about the next move, do it, look at the result, decide what's next. The substrate is a folder of documents that grows as the work progresses.

## The rhythm

Each turn, ask:
- **What's the next extraction, summarization, review, or rewrite I want to do?**
- That decision results in **editing an existing document** or **creating a new one**.
- Repeat.

No stages. No state machine for the work. Just deliberate next-moves and the documents they produce.

## Document kinds

Front-matter on each file declares its `kind`. Available kinds:

- **source** — the original draft material (read-only; we work *from* these)
- **extraction** — pulled-out content (insights, key passages, structural moves)
- **note** — observations, working thoughts, side analyses
- **draft** — versions of the rebuilt document
- **deliverable** — the final
- **comparison** — diffs or side-by-side analyses captured as artifacts

## Conventions

- **Free-named files.** Pick names that read well in the nav: `extraction-section-3-arguments.md`, `draft-v1.md`, `note-on-tone.md`.
- **Use `parent` front-matter** when a document derives from another. E.g., `draft-v2.md` has `parent: draft-v1`. Lets the dashboard surface lineage.
- **Use `focus: true`** on the documents you want surfaced prominently in nav.
- **Don't try to be exhaustive in extractions.** It's fine to make multiple extraction documents over time, each focused on something specific.
- **Don't track structure separately.** Structural decisions happen in drafts; if you want to think about structure before drafting, write a `note-` document about it.

## Render protocol

After every meaningful change to documents (creating a new one, editing an existing one), re-render the dashboard so the nav reflects the new state. Don't accumulate silently.

## Stopping rule

When a `draft` reads as final, change its kind to `deliverable`. Move workspace `state.status` to `archived`.
