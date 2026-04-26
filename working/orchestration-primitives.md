# Orchestration Primitives

Eight load-bearing assertions that everything in the orchestration framework leans on. Each one is intended to become a standalone HTML walkthrough — a small page that takes a reader from "haven't thought about it" to "now I see it that way." The order builds dependencies; later primitives presume earlier ones.

Each entry below is structured for someone (you or me) to walk into and produce a single-concept page from:

- **Assertion** — the claim, in one sentence, sharp enough to put on a page.
- **Why it's load-bearing** — what later claims fall apart if this one isn't established.
- **The shift** — what a reader should think differently after walking through it.
- **Walkthrough beats** — the 3–5 moves the standalone page should make, in order.
- **Anchor** — a vivid example, image, or analogy the page can build around.

---

## 1. Knowledge work is a sequence of atomic operations

**Assertion.** All knowledge work reduces to a sequence of atomic operations that turn inputs into outputs.

**Why it's load-bearing.** Without this, "orchestration" has nothing to orchestrate. Every later primitive assumes the work decomposes into discrete acts that can be sequenced, delegated, evaluated.

**The shift.** From "knowledge work is a thing someone does" to "knowledge work is a pipeline of small operations someone composes."

**Walkthrough beats.**
1. Pick a familiar piece of knowledge work (writing a memo, doing a literature scan).
2. Decompose it into the actual operations performed: search, retrieve, read, extract, evaluate, summarize, draft, revise.
3. Show that the sequence varies by domain but the operations themselves are common across domains.
4. Land: the deliverable is what falls out of the pipeline, not what gets done.

**Anchor.** A side-by-side decomposition of three different knowledge tasks (research memo, claims review, marketing brief) into their atomic operations — different sequences, overlapping vocabulary.

---

## 2. Knowledge work draws on two distinct expertises

**Assertion.** Every piece of knowledge work draws on two separable expertises: domain expertise (what makes a good output good) and orchestration expertise (how to decompose and sequence the operations that produce it).

**Why it's load-bearing.** This is the cognitive split everything else hangs on. The spectrum (#4) is a spectrum of where orchestration lives. The agent unlock (#5) is about operations, not orchestration. The asymmetry (the article's closer) is that one expertise is portable and the other isn't. None of those moves are coherent without this split.

**The shift.** From "knowing how to do this work" as a single thing, to "two different things, often held by different people, often confused."

**Walkthrough beats.**
1. State the two expertises and define each in one line.
2. Show a domain expert who can produce great outputs but can't tell you how they did it.
3. Show an orchestration expert (a process designer, a project manager) who structures work in a domain they don't understand themselves.
4. Land: both are required for any piece of work, but they are not the same thing and they don't transfer the same way.

**Anchor.** A real example where the two are visibly separate — a senior partner who writes great briefs but resists templating them, and a junior associate who builds the template by watching ten of the partner's briefs.

---

## 3. Orchestration is locatable

**Assertion.** Orchestration always lives somewhere. It never lives nowhere. Asking "where does the orchestration live for this work?" is always a well-formed question.

**Why it's load-bearing.** Quiet but essential. Establishes that orchestration is a *thing with a location*, which is what makes the spectrum (#4) and the relocation argument (#6) coherent.

**The shift.** From treating orchestration as ambient ("this is just how the work goes") to treating it as a thing with a physical location that can be pointed at.

**Walkthrough beats.**
1. Take a piece of work and ask: where does the structure of how it gets done actually live?
2. Walk through candidate answers — in the operator's head, in a checklist, in an SOP, in a piece of software.
3. Show that the answer is always one of these. There is no "nowhere."
4. Land: this lets us ask a new question — "should it be there, or somewhere else?"

**Anchor.** A single workflow shown three times, with the orchestration located differently each time: in someone's head, in a wiki page, in compiled software. Same work, different homes.

---

## 4. Orchestration locations form a spectrum

**Assertion.** The places orchestration can live form a spectrum from a single operator's head (improvised turn by turn) to compiled purpose-built software (fully encoded, fixed at build time), with templates, SOPs, scripts, and internal tools in between.

**Why it's load-bearing.** Without the spectrum, the "third location" argument later has nothing to anchor against. Also: the spectrum predates LLMs — this primitive is about how knowledge work has always been organized.

**The shift.** From "either I do it, or I commission an app for it" (binary) to "a continuous range of how much is encoded vs. improvised, with most real work living in the middle."

**Walkthrough beats.**
1. Show the two endpoints crisply — the lone operator with a typewriter, the enterprise app with two thousand custom fields.
2. Walk the gradient — checklist, runbook, internal tool, custom dashboard.
3. Note that picking a point on the spectrum is an economic decision: how much encoding does the work earn?
4. Land: this is the lay of the land before agents arrive.

**Anchor.** A horizontal spectrum graphic with five or six recognizable artifacts placed along it (sticky note → checklist → runbook → script → custom tool → enterprise app).

---

## 5. Agents execute atomic operations

**Assertion.** An agent — an LLM in a loop with tools and instructions — can perform many of the atomic operations of knowledge work (search, read, evaluate, summarize, draft, extract) at speed and quality that previously required a human per operation.

**Why it's load-bearing.** This is the familiar claim. It establishes what agents *did* change, which is the setup for the sharper claim (#6) about what they *also* changed.

**The shift.** From "AI is a tool you use" to "AI is a worker that performs the steps of knowledge work, fast and well."

**Walkthrough beats.**
1. Show a knowledge work pipeline (linking back to #1) and circle the operations that used to require a human.
2. Show that an agent now performs each of those operations.
3. Note: this collapses the human-in-every-step bottleneck.
4. Land: but this is only half the story — orchestration is still a question.

**Anchor.** A pipeline diagram with operation icons. Before: every step has a human. After: every step has an agent except the gates the human keeps.

---

## 6. Agents perform within-turn orchestration

**Assertion.** Agents don't just execute operations — they also perform orchestration, but only within a single turn. Given an instruction, the agent decides which tool to call, in what order, when the task is done. Between turns, orchestration is still the user's.

**Why it's load-bearing.** This is the move that creates a third location. Without distinguishing within-turn from between-turn orchestration, the rest of the framework collapses back to "agents do operations, users do everything else."

**The shift.** From "the user orchestrates, the agent executes" to "orchestration is split across two layers — the user owns the macro, the agent owns the micro, and the boundary is the turn."

**Walkthrough beats.**
1. Define a turn — the user issues an instruction, the agent acts until control returns to the user.
2. Show what happens inside a turn: tool choice, sub-task sequencing, retrieval strategy, when to stop. All orchestration.
3. Show what happens between turns: the user decides what to attempt next. Also orchestration, at a coarser grain.
4. Land: agents took on a slice of orchestration that previously required either a human or compiled software. That slice is new.

**Anchor.** A single turn rendered as an expanded timeline — user prompt at the top, then the agent's tool calls and reasoning steps, then the response. Each agent decision flagged as "this used to be a human's call, or hardcoded by a developer."

---

## 7. The turn is the boundary

**Assertion.** The turn is the structural boundary between the user's orchestration and the agent's. Within a turn, the agent decides; between turns, the user decides.

**Why it's load-bearing.** Names the boundary that makes #6 operational. It's the smallest primitive but it lets the reader reason about distribution — "should this decision be inside the turn or outside?" — which is the operator's actual job once they accept the framework.

**The shift.** From a fuzzy sense of "the agent does some stuff and I do some stuff" to a sharp boundary that lets you decide who owns which decisions.

**Walkthrough beats.**
1. Show two example turns — one well-bounded (clear instruction in, clear result out), one badly bounded (agent guesses, asks, drifts).
2. Show that the quality of the turn boundary is something the operator can shape — by making instructions clearer, by adding governance, by trimming scope.
3. Land: every orchestration decision belongs on one side or the other of this line, and choosing where it goes is a real design call.

**Anchor.** A two-pane diagram: left pane = "the operator's turn-by-turn steering," right pane = "the agent's per-turn loop." Decisions placed on each side, with the turn boundary as a vertical bar between them.

---

## 8. The substrate shapes the agent

**Assertion.** Files in the workspace — instructions, samples, rules, state maps, tools, skills — shape how the agent orchestrates within a turn. The workspace is not just where work is produced; it is where the agent's behavior is configured.

**Why it's load-bearing.** This is what makes the third location malleable. Without it, within-turn orchestration is just whatever the model happens to do; with it, the operator can author the orchestration that lives there. The encoding ladder, co-development, and the entire practitioner article depend on this.

**The shift.** From "the agent has a fixed personality" to "the agent's behavior is a function of the substrate, and the substrate is files I can edit."

**Walkthrough beats.**
1. Show two sessions: same agent, two different directories. Different behavior emerges.
2. Open the directories. Surface the files that produced the difference (rules, samples, tools).
3. Edit one of them in place. Show that the next turn changes behavior.
4. Land: the agent location on the orchestration spectrum is *configurable* — and configured by files anyone can write.

**Anchor.** A short demo: a directory with a CLAUDE.md and a sample. The same task run twice — once before adding an annotation to the sample, once after — producing visibly different outputs. The annotation itself shown as a one-line edit.

---

## The punchline these eight primitives set up

> Orchestration used to live in one of two places: someone's head, or compiled software. Agents created a third place — the per-turn reasoning of the model, configured by files in the workspace. The first environments to expose this third location continuously and editably let an operator decide, in conversation, how to distribute their orchestration across all three — and climb from one to the next as the work earns it.

Every clause discharges to a primitive above. No new concepts at the punchline.

---

## Notes on building the standalone walkthroughs

A few things worth keeping consistent across the eight pages:

- **Each page is self-contained.** A reader landing on #6 cold should still get something useful, even if they haven't read #1. Cross-link generously, but don't assume.
- **One concept per page.** The temptation will be to cram in adjacent material. Resist it. The whole reason for splitting these out is to make each one stand on its own.
- **Visual + textual.** Each page should have at least one anchor visual (the "Anchor" entry above is a starting point) and a tight verbal walkthrough. Neither alone is enough.
- **End with the bridge.** Each page should close with a one-line pointer to the next primitive — the natural follow-up question this one raises. That's how the eight pages compose into a path.
