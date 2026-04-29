# Bootstrap Instructions

This file governs Claude's behavior during the early lifecycle states: `goal-defining` and `contracts-drafting`. Once the workspace transitions to `operating`, the workspace's `manual.md` (and optional `method.md`) takes over.

---

## Phase: `goal-defining`

The workspace has just been scaffolded. `workspace/goal.json` exists with empty placeholder fields. No stores yet.

### Goal of this phase

Fill in `workspace/goal.json` with all required fields, validated against `schemas/goal.schema.json`.

### Required fields in goal.json

| Field | What it is |
|---|---|
| `purpose` | One sentence: what this workspace exists to produce. |
| `deliverable` | The artifact(s) being produced. Could be ongoing ("a trustworthy system") or specific ("a 6-page memo by April 30"). |
| `success_criteria` | Array of strings. At least one. Concrete signals that the work is going well. |

### Optional but useful fields

| Field | What it is |
|---|---|
| `audience` | Who the deliverable is for. |
| `timeframe` | When this needs to happen, if there's a when. |
| `scope_in` | Array. What's explicitly in scope. |
| `scope_out` | Array. What's explicitly out of scope (just as important). |

### Conversation shape

Don't dump all questions at once. Walk the user through:

1. **Purpose first.** *"In one sentence, what is this workspace for?"* Don't accept vague answers — push for specificity.
2. **Deliverable.** *"What does the output look like? Is it ongoing, or is there a moment when this is 'done'?"*
3. **Audience and timeframe.** Quick questions if they apply.
4. **Scope (in/out).** *"What's in scope? What's explicitly NOT in scope?"* Scope_out is often the most clarifying field.
5. **Success criteria.** *"How will you know the work is going well?"* At least one concrete signal.

Update `goal.json` incrementally as the user answers — don't wait until the end. The browser will show their progress live.

### What you should NOT do in this phase

- Don't propose stores or contracts yet. That's `contracts-drafting`.
- Don't generate any data files.
- Don't pick a blueprint yet — wait until goal is locked in.
- Don't guess at the user's goal. Ask.

### How to advance

When all required fields are populated and the user confirms the goal captures the work:

1. Update `state.json.status` from `goal-defining` to `contracts-drafting`.
2. Update `state.json.last_modified`.
3. Append to `log.md` noting the transition.
4. Read `bootstrap.md` again — the next phase's instructions are below.

If the goal turns out to be wrong later, transition backward is allowed: from `contracts-drafting` back to `goal-defining`.

---

## Phase: `contracts-drafting`

`workspace/goal.json` is complete. No stores yet. Now we set up the substrate.

### Goal of this phase

Install the right initial contracts and pages so the user can start working. Two paths:

- **Pick a blueprint** — install a packaged methodology (substrate + method) from `living-workspace-plugin/templates/blueprints/<name>/`.
- **Start blank** — keep the universal `workspace-skeleton` and define stores from scratch as needed.

### Conversation shape

1. **Read goal.json carefully.** What kind of work is this?
2. **Browse blueprints.** Look at `templates/blueprints/`. Each blueprint has a `README.md` describing what kind of work it's for. Common ones: `personal-todo`, `document-revision`, `research-synthesis`, `decision-log`.
3. **Recommend a blueprint** if one fits the goal cleanly. Explain why. Show the methodology summary from the blueprint's README.
4. **Offer alternatives.** "If you'd rather start blank, we can. Or pick a different blueprint." User decides.

### Installing a blueprint

When the user picks one:

1. Copy the blueprint's `_contract.json` to `workspace/_contract.json` (overwriting the universal-default contract from the skeleton).
2. Copy each `<store-name>/` folder from the blueprint into `workspace/stores/<store-name>/`.
3. Copy the blueprint's `pages/*.json` into `workspace/pages/`.
4. Copy the blueprint's `method.md` to `workspace/method.md`.
5. Update `state.json.blueprint` to the blueprint name.

### Customizing

Blueprints ship with reasonable defaults but should be customized to the specific goal:

1. Walk through each store contract. Ask: does the kind name fit? Are the fields right? Are the states right?
2. Suggest renames where the blueprint's generic names don't fit the user's domain (`item` → `task`, `record` → `source`, etc.).
3. Add fields the user mentions but the contract doesn't have.
4. Don't add stores that aren't immediately needed. Capture > completeness during bootstrap.

For each customization:
- Validate the updated contract against the relevant meta-schema before saving.
- Brief the user: *"Adding a `priority` field to the Task contract."*
- Apply the change.

### What you should NOT do in this phase

- Don't generate data instances yet. Wait until operating.
- Don't add stores the user didn't ask for. Stay close to the blueprint or what the user named.
- Don't transition to operating without user confirmation.

### How to advance

When the user confirms the contracts and pages look right:

1. Update `state.json.status` from `contracts-drafting` to `operating`.
2. Update `state.json.last_modified`.
3. Append to `log.md` noting the transition and which blueprint (if any) was installed.
4. From this point on, follow `workspace/manual.md` (and `workspace/method.md` if installed).

If contracts turn out to be wrong later, transition backward is allowed: from `operating` back to `contracts-drafting`.

---

## Backward transitions

Both pivots are explicit and supported:

- `contracts-drafting` → `goal-defining` (the goal needs revision)
- `operating` → `contracts-drafting` (the contracts need revision)

When the user requests a backward transition:
1. Surface what's at stake (existing data may not conform to revised contracts).
2. Confirm.
3. Update state. Log the transition.

---

## Reference

- Phase definitions: `workspace/_contract.json` (lifecycle section)
- Goal schema: `living-workspace-plugin/schemas/goal.schema.json`
- Store contract schemas: `living-workspace-plugin/schemas/contracts/<type>.contract.schema.json`
- Blueprints: `living-workspace-plugin/templates/blueprints/`
- Universal manual (post-bootstrap): `living-workspace-plugin/templates/workspace-skeleton/workspace/manual.md`
