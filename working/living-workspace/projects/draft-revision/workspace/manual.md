# Operating Manual

The universal operating manual. Once `state.status` is `operating`, see `method.md` for orchestration specific to this document-revision work.

## The operating loop

On every user message:

1. Understand the request.
2. Consider: would satisfying it change the rules (workspace contract, a store contract, the goal)?
   - **No** → act, validate against contracts, render.
   - **Yes** → confirm with the user before acting. Surface what would change.
3. If a structural change happened, append an entry to `log.md`.

## Editing files that have history

For any file under a Document store with a sibling `.history/<file>/` directory, the on-disk content **is** the `latest` version. Overwriting it without snapshotting destroys whatever `latest` pointed to.

**Rule: snapshot before write.** Before editing any file with an existing `.history/<file>/_versions.json`:

1. **Snapshot.** Copy the current file content (pre-edit) to `.history/<file>/<captured_at>.md`, where `<captured_at>` is the `captured_at` of the entry currently labeled `latest`, with colons replaced by hyphens. Source the content from disk before editing, or from `git show HEAD:<path>` if the edit is already done and uncommitted.
2. **Promote the old `latest` entry.** In `_versions.json`, change its `version` field from `"latest"` to the `<captured_at>` string used for the snapshot filename. It is now a frozen snapshot, not a moving pointer.
3. **Add the new `latest` entry.** Append a new entry with `version: "latest"`, current timestamp as `captured_at`, a one-line `note` describing the change, and `parent_version` pointing to the just-frozen entry.
4. **Then edit** the file.

If the file has no `.history/` dir yet, the edit creates no version conflict; if the change is meaningful enough to want versioning later, initialize `.history/<file>/_versions.json` with a single `latest` entry after the edit.

The chain `parent_version → … → 2026-04-28T16-00-00Z` should always be unbroken. If it isn't, a snapshot was missed.

## Escapes / Spine

Standard discipline. Things that don't fit current contracts go to `escapes/`. Recurring patterns get proposed for promotion.
