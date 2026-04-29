# Process Log — Aftershoot Methodology Draft Revision

## Decisions

### 2026-04-28 — Workspace scaffolded; goal locked
Goal: take cmr take 2 and improve it. Harvest the good, cut the bad, develop the good. Same purpose as source. Source is cmr take 2 only — earlier versions are context, not material.

### 2026-04-28 — Substrate: 3 stores
Resisted over-engineering. Three stores: inputs (Document, source), harvest (Table, items to preserve/develop), versions (Table with document column, drafts).

### 2026-04-28 — Workflow: 3 stages
intake → harvesting → drafting → iterating → finalizing. (Removed the structuring stage; structure decisions happen during drafting against the harvest.)

### 2026-04-28 — Lifecycle advanced: goal-defining → operating
Status flipped to operating at 15:00. current_workflow_stage: harvesting.

### 2026-04-29 — Snapshot-before-edit rule encoded in manual.md
Edited `outline-cmr-take-2.md` without first snapshotting the prior `latest` (captured 2026-04-29T09:00:00Z), losing it from the version chain. Recovered the prior content from git HEAD into `.history/outline-cmr-take-2/2026-04-29T09-00-00Z.md`, promoted the old `latest` entry to a frozen snapshot, and added a new `latest` entry covering today's §1 reframe. Added an "Editing files that have history" section to `workspace/manual.md` so the rule is read on every operating turn.

## Pivots

(none yet)

## Spine candidates

(none yet)

## Escapes

(none yet)
