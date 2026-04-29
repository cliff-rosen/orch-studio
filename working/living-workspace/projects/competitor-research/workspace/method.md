# Method — Competitive Analysis (single-deliverable)

Orchestration for competitor-research workspaces. Read on every operating-phase turn after `manual.md`.

## The flow: candidates → final three → findings → memo

```
gathering ─→ shortlisting ─→ researching ─→ synthesizing ─→ drafting ─→ finalizing ─→ (archived)
```

Each stage has a different rhythm. The current stage is in `state.current_workflow_stage`; advance only with user confirmation.

## Stage rhythms

### gathering
Goal: cast a wide net. Capture every candidate that comes up.

Behavior:
- Add competitors at `state: candidate` without filtering. We'll narrow later.
- Don't research yet — just capture name, url, basic fit notes.
- Don't ask for full profiles. Capture must be fast.
- Push back if the user starts deep research before exiting this stage: *"want to lock the candidate list first?"*

### shortlisting
Goal: narrow to 5–8 strong candidates.

Behavior:
- Walk through candidates. Move to `shortlisted` or `dropped` (with reason).
- Force a reason on `dropped` — *"Why not?"* — for the memo's narrative.
- Don't profile yet. Just narrow.

### researching
Goal: deep profile on the final 3; populate findings.

Behavior:
- Move 3 from `shortlisted` to `final-three`. The rest stay shortlisted (for record).
- For each `final-three` competitor: write the profile (the document column), and create findings across each dimension.
- Every finding must cite at least one source. If not, surface as an escape until cited.
- Surface gaps: *"Linear has no finding yet on the 'pricing-model' dimension."*

### synthesizing
Goal: build the comparison; land a differentiation thesis.

Behavior:
- Look across findings. Where do the competitors converge? Diverge? Where can our product credibly win?
- Propose 1–3 candidate theses. Discuss with user.
- Don't draft yet. Synthesis comes before drafting.

### drafting
Goal: write the memo.

Behavior:
- Use the memo Document as a working draft.
- Embed live findings/dimensions/competitors via store-embed references — don't copy-paste.
- Iterate sections. Surface citations from sources store inline.

### finalizing
Goal: polish + executive review.

Behavior:
- Refuse contract changes ("we're finalizing — should we go back to drafting?").
- Run citation check: every claim has a source.
- Run scope check: deliverable matches `goal.json`.
- Surface any escapes that haven't been resolved. Decide: include in memo, or document as out-of-scope?

## Substrate-specific opinions

- **Profile is the primary research artifact.** A competitor without a profile isn't `final-three` material — push back.
- **Dropped candidates aren't waste.** Their reasons inform the memo's "why not these others" narrative.
- **Findings before synthesis.** Don't let the user draft a thesis before findings are populated. The thesis emerges from the data.
- **Stay scope-disciplined.** It's tempting to widen. Keep checking against `goal.scope_out`.

## Wrapping up

When the memo is shipped (executive review complete; no further changes):
1. Move `state.status` from `wrapping-up` to `archived`.
2. The workspace becomes read-only.
3. Future similar projects can fork this workspace as a starting point.
