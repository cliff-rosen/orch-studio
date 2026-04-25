# From User Input to Finished Memo — A Walkthrough

This document traces a single thread end-to-end: a user types something into the Investigate tab, and eventually a 14-section litigation memo comes out the other side. The goal here is intuition, not exhaustive spec — see `MEMO_PIPELINE_INPUTS.md` for the field-level breakdown.

---

## Part 1 — How user input becomes five tables of structured data

### What the user actually supplies

On the Investigate page, the user provides one of two things:

- **A few paragraphs of free text** — e.g. *"I suspect UK supermarkets are coordinating on own-brand pricing — margins look suspiciously identical."*
- **A document** — `.docx`, `.pdf`, or `.txt`. The client extracts the raw text before sending.

Optionally a title. That's it. No fields, no forms, no dropdowns. One blob of prose.

### The single AI extraction

The blob goes to the `investigate` edge function, which makes **one call to Claude** with a very specific instruction: *read this text and return structured JSON in this exact shape*. The shape is the important part — it defines what the rest of the system will know about the case. Claude returns an object with:

- `hypothesis_title`, `hypothesis_description`, `summary`
- `violation_type`, `sector`, `geographic_market`
- `bayesian_posterior`, `confidence_score`, `recommended_action`
- `defendants[]` — name, role, market share, description
- `evidence_items[]` — type, description, source, tier, verification status
- `key_findings[]`
- `damages_conservative_gbp_m`, `damages_mid_gbp_m`, `damages_high_gbp_m`

This is the moment where unstructured prose becomes structured data. Everything downstream works from this JSON.

### The fan-out into tables

Now comes the part that made the picture confusing. The edge function takes that single JSON blob and **sprays it across five tables**, all linked by a fresh `flag_id`:

| Table | What ends up here |
|---|---|
| `market_flags` | The "case container" — market name, posterior-derived confidence band, and a bunch of hardcoded/empty slots for HHI, Lerner, CR4 that Investigate doesn't populate |
| `hypotheses` | One row — the title, description, and a 0–100 confidence score derived from the posterior |
| `market_participants` | One row per defendant (with a placeholder if the AI extracted none) |
| `evidence_items` | The AI-extracted evidence, *plus* the raw user input itself as a Tier-3 evidence item, *plus* key findings as fallback evidence if nothing else was extracted |
| `investigations` | The user's raw session — input text, progress state, the full analysis blob. **Not read by the memo pipeline.** |

**Mental model:** the tables are not five independent inputs the user fills in. They are a *normalized projection* of one AI analysis. The tables exist because different parts of the product (the memo pipeline, the review UI, the dashboards) need to join and query the analysis in different ways. The source of truth is the prose blob and the AI extraction that followed it.

There is one gate: if `bayesian_posterior < 0.25`, the fan-out is skipped entirely — no flag, no hypothesis, no participants, no evidence. The investigation completes but produces nothing for the pipeline.

### What the user does NOT supply (but the memo pipeline wants)

The memo pipeline expects several fields that Investigate never fills in:

- `market_flags.hhi`, `hhi_source`, `hhi_methodology`, `lerner_index`, `cr4`, `case_reference`
- `evidence_items.url`
- The entire `precedent_matches` table

These come from the main anomaly pipeline, manual editing, or enrichment steps that aren't part of the Investigate flow. On a pure Investigate-to-memo path, these render in the prompt as `REQUIRES CALCULATION`, `TBC`, or are omitted entirely.

So the Investigate flow gets you **most** of a memo's inputs, not all. A memo generated from an Investigate-only case will be thinner on market-concentration numbers and comparable precedents than one built on a fully enriched flag.

---

## Part 2 — How those tables become a memo

### The intuition

The memo pipeline is **not** a single "turn this into a document" call. Think of it as a writer working through a document outline. The outline is fixed (it's the v8.0 competition law memo template). The writer has the case file open on their desk — the five tables, joined by `flag_id`. They write one section at a time, consulting the case file each time, and each new section gets to see what they've already written.

That's the whole thing. Fourteen passes, same reference material, building on itself.

### The fixed document outline (14 stages)

Ignore stage numbers for a moment and look at the shape of the document being produced:

```
  Stage 0        Pre-flight — "does this case have what a memo needs?"
  Stage 1        Discovery & Bayesian analysis (not a section — a prep pass)
  Stages 2–8     Sections II through XV — the body of the memo, in document order
  Stages 9–11    Annexes A through R
  Stage 12       QA certificate (an auditor reviews everything above)
  Stage 13       Section I — Executive Summary, written last
```

Two things make this shape sensible rather than arbitrary:

- **Executive summary is written last.** You can only summarize numbers that have already been committed to paper. Writing Section I first would mean predicting your own conclusions.
- **QA certificate runs before the summary but after everything else.** The auditor checks the body; the summary reflects the auditor's approved numbers.

### What each stage actually does

Each stage is one Claude call, and every call has the same three inputs:

1. **Case context** — the five-table block, stringified into plain text. The *same* block every stage. This is the reference material.
2. **Stage prompt** — pulled from the `prompt_library` table by `prompt_ref`. Generic instructions like "write Section VI: compute HHI, Lerner, and coefficient of variation from the evidence." No case data in here; it's the template instruction.
3. **Prior sections** — a truncated trail (3,000 chars total, most recent first) of what earlier stages wrote. Empty on stage 0, longest by stage 13.

Claude returns text. That text gets saved into `memos.sections[outputKey]` — e.g. stage 4's output lands at `sections.section_vi`.

### The models used

- **Sonnet 4.6** for the twelve body/annex stages — fast, capable enough for structured legal writing.
- **Opus 4.6** for stage 0 (validation) and stage 12 (QA) — the two stages where rigour matters more than speed.

### The final memo

After stage 13, `memos.sections` holds all fourteen outputs keyed by section name. The viewer just concatenates them in display order: Executive Summary → validation report → factual background → legal framework → statistics → evidence strategy → defendants & damages → defence & certification → budget, risk, conclusions → annexes → QA certificate.

That's the memo.

---

## End-to-end in one breath

> The user types prose. One AI call turns that prose into structured JSON. The JSON is sprayed into five tables joined by `flag_id`. Later, when the user asks for a memo, the pipeline reads those five tables back into a plain-text case context block and feeds that block — plus a stage-specific prompt and a short trail of prior output — to Claude fourteen times, once per section of a fixed document outline. The fourteen outputs, concatenated, are the memo.

### Where the information *actually* originates

- **Facts of the case** (defendants, evidence, hypothesis, sector) — all ultimately from the user's original prose, via the Investigate AI extraction.
- **Economic numbers** (HHI, Lerner, CR4, precedents) — not from Investigate. Either null or populated by a separate pipeline.
- **Legal structure and section-by-section argument** — from the stage prompts in `prompt_library`. Generic, reusable, case-independent.
- **Cross-section consistency** (numbers matching between Section VI and the Executive Summary) — from the prior-sections trail each stage sees.

Three sources, one merge, fourteen times.
