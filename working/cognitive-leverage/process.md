# Process — How This Synthesis Is Built

Meta-document for how we're working on the cognitive-leverage effort. Separate from the content itself so structure decisions don't pollute the substance.

## Goal

**Converge on a canonical framework for cognitive leverage.**

This is the explicit objective. Not mapping a thinking-in-progress as an archive. Not preserving every alternative framing as equally valid. The job is to arrive at a stable, defensible, teachable framework — terminology, rubrics, models, case applications — that can survive outside the conversations it emerged from.

This shapes everything else:
- We're willing to retire framings that got superseded, not just catalog them.
- We're willing to mark claims as "tentative" and "in flight" rather than leaving them implicitly settled.
- We're trying to detect and resolve contradictions across sources, not smooth them over.
- The end state is a synthesis that stands on its own; the raw sources become provenance, not the primary artifact.

## Inputs

Raw material arrives in various forms:
- Pasted text directly in chat
- Files dropped into `sources/` (conversation transcripts, essays, drafts, memos)
- URLs (handled via WebFetch when unauthenticated; otherwise user pastes the content)
- Eventually: Google Drive folders, other external stores

Every raw input is preserved verbatim in `sources/`. The synthesis never becomes the only copy of anything.

## Method

For each new input, the working loop is:

1. **Read fully.** Don't skim; noise matters less than catching a correction buried mid-conversation.
2. **Classify against existing synthesis:**
   - **Supports** — reinforces something already captured. Note reinforcement; usually no edits needed.
   - **Adds** — genuinely new substance not present in prior sources. Integrate into the appropriate section.
   - **Conflicts** — real tension with what's already captured. Surface it explicitly, don't smooth over. Decide whether one supersedes the other or they're complementary at different levels.
3. **Update synthesis.md** with the distilled substance.
4. **Preserve the raw source** in `sources/` with a clear filename.
5. **Update `synthesis.md § Source Log`** with the new entry.
6. **Retire any parked questions** that the new source resolves; move them to a "Previously parked, now addressed" area rather than deleting.
7. **Flag lingering uncertainty** using confidence markers (see below).
8. **Summarize in response to user:** what was added, what conflicts surfaced, what's been resolved. Keep this concise — the synthesis is the artifact; the response is just the receipt.

## Confidence markers

Used sparingly in `synthesis.md`. Overuse defeats the purpose.

- **(tentative)** — a specific claim I'm not sure will survive the next source. Could be renamed, reframed, or cut.
- **(in flight)** — the underlying concept is still being actively worked out across sources; terminology and boundaries may shift.
- **Unmarked** — stable across the sources processed so far.

When a marker gets removed, note it in the source log ("confirmed by conv-N").

## Structure principles

- **`synthesis.md`** is the hub. It's the primary artifact.
- **`sources/`** holds verbatim raw material. Read-only after capture (typos/formatting fine to clean; content not to be edited).
- **`process.md`** (this file) is meta-only. How we work, not what we've concluded.
- **Spin-off files** are created when a section of synthesis gets heavy enough to warrant its own home (rough threshold: one section dominates the doc's length or a reader would want to refer to it independently).
- **Naming**: descriptive filenames, no dates in filenames (dates live in the source log and in file contents if needed).

## Reassessment commitments

Structure decisions aren't locked in. Explicit reassessment points:

- **After conv-3** — check whether the single-file synthesis is still scannable. If it's crossed a readability threshold, split into a hub + detail files (candidate splits: `concepts.md`, `engagement-root-cause.md`, `case-orchestrator-studios.md`).
- **After all seven convs are processed** — full pass to canonicalize. Remove remaining tentative markers where sources converged. Resolve in-flight concepts. Write a "canonical summary" section that can be excerpted or adapted for external writing.
- **Whenever substantial contradictions emerge** — pause the ingestion loop, raise with user, don't try to decide unilaterally.

## What goes in synthesis vs. what doesn't

**In synthesis:**
- Terminology the framework relies on
- Rubrics and decision rules that apply across cases
- Primitives (fixed cognitive capacity, the two dimensions, CCC, etc.)
- Case applications that exercise the framework
- Framing/rhetorical principles that proved useful
- Evolution notes when a framing shifted meaningfully
- Parked and resolved questions

**Not in synthesis:**
- Verbatim quotes from conversations (those live in `sources/`)
- Editorial debate about prose choices that didn't affect the framework
- Personal/biographical detail beyond what the framework needs (e.g., "Cliff and Adam started Orchestrator Studios with $1k/month" stays because it anchors the pre-AI-math counterfactual; details of specific products beyond the names don't belong)
- Process commentary — that lives here

## Anti-patterns to avoid

Things I've been tempted to do and should resist:

- **Prematurely canonizing.** Giving a concept a tidy name before the sources have converged on it. The user has flagged this directly ("stop trying to make assertions about what's cognitive leverage — I don't think you understand it yet"). When uncertain, use a confidence marker rather than a crisp label.
- **Fake-merging conflicting framings.** Two sources saying different things should be surfaced as different, not blended into a false synthesis.
- **Appending instead of restructuring.** It's easier to add a section than to restructure an existing one. Resist this when a new source's substance cuts across existing sections.
- **Losing track of my own confidence.** When I make a distillation decision under uncertainty, mark it. Don't present inference as reporting.
- **Over-abstracting.** The user consistently pushes toward concrete and specific ("ground abstractions in the founding commitment"). Preserve that discipline in synthesis prose.

## Open process questions

- **How to handle external writing once the framework stabilizes.** The synthesis is an internal artifact. Derived external writing (Adam memos, essays, teasers, potential product positioning) needs its own home — probably `drafts/` or similar, separate from synthesis.
- **Whether to track predicted sources.** If we know conv-3..7 are coming, is it useful to hold placeholder entries? Current answer: no, too easy to mis-anticipate content.
- **Version marking on synthesis.** Not versioning now. If the synthesis starts being shared externally, may need to.
