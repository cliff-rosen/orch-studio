---
kind: extraction
title: "Outline of source-cmr-take-2"
parent: source-cmr-take-2
created_at: "2026-04-28T16:00:00Z"
---

# Outline — cmr take 2

Structural + key-points outline of `source-cmr-take-2.md`. One bullet per substantive move; nesting reflects the argument structure.

## §1 Goal

- Build an AI-assisted photo editing system for novices
  - Two outcomes: visibly stronger images **and** skill development through the process
  - System adapts along four axes: image, skill level, desired outcome, current edit stage
- Reliable delivery requires more than a well-written prompt — it requires a structured orchestration layer
  - Manages workflow state
  - Selects expert methodology modules conditionally
  - Constrains tool exposure
  - Observes the image as it evolves
- **Headline:** LLM handles communication and adaptation; orchestration handles control
- Forward reference: §3 makes the case concretely

## §2 Target User Experience

- User opens an image
- System gathers context: image type, strengths/weaknesses, proficiency, desired mood/style, available tools, metadata
- **Closed-loop interaction**:
  - System gives next instruction in plain language with rationale
  - User applies the adjustment
  - System observes updated image state
  - System updates its state and gives the next instruction
- User can ask questions or push back at any point; guidance adapts
- Loop continues until acceptable result
- **Frame:** "Not prompt-and-response. The system sees the image evolve and teaches the user what to do next."

## §3 Why a Mega-Prompt Falls Short — and What Orchestration Actually Buys

### Setup

- Pro photographer's editing process is silent, deep, internal
  - Establishes context (what image is for, what user wants)
  - Looks carefully — for opportunities, not just problems
  - Forms phase roadmap (foundation → refine → finish)
  - Reasons about operations within phases (which, in what order, intensity)
  - Evaluates as they go; revises on new information
  - Knows when to stop
- Now imagine same task with LLM via single mega-prompt
  - Result: plausible, not good
  - Two distinct failure modes — orchestration addresses each, but differently

### §3.1 First argument: decomposition

- Mega-prompt asks the LLM to do staged work in one pass
  - Simultaneously: figure out phase, what context still needs establishing, which evaluations apply, which operations to consider, whether prior recs are honored, whether work is done
  - Nothing forces the model to inhabit one task at a time
  - Training rewards fluent end-to-end response → model satisfices
  - Produces output that **resembles** staged work without doing it
- This is the failure mode underlying:
  - "LLM compressed phases"
  - "LLM gave a generic readout"
  - "LLM produced a plausible plan instead of an analytic one"
  - "LLM kept recommending past the point of being done"
- All the same failure: too much asked at once
- **Fix: decomposition**
  - Orchestrator externalizes the phase machine
  - LLM invoked once per phase with prompt scoped to that phase's task only
  - Output of each phase = structured artifact, input to next
  - Model never sees full machine — just current phase's well-bounded question
  - "Establish context before planning," "re-evaluate after operation," "check completion criteria" become structural, not implicit
- **Principle:** never ask the LLM to do more than it has to do. Every silent compression is leverage lost.

### §3.2 Second argument: library retrieval at lynchpin moments

- Decomposition has a ceiling
- Even ideally prompted, LLM produces strategy by reasoning from training data
- Pro does something different at strategic moments:
  - Recognizes situation ("this is the backlit-portrait-with-recoverable-rim-light case")
  - Pulls matching practice from internalized library
  - Pattern-matches against curated, context-keyed expertise
  - Adapts to specifics
- LLM training corpus has *appearance* of expertise (tutorials about what photographers do), not the curated, situation-indexed library
- **Fix at lynchpin moments:** don't ask the LLM the strategic question at all
  - Orchestrator recognizes situation
  - Retrieves matching authored practice from curated library
  - LLM instantiates against the specifics of this image
- LLM's job shifts from **generation** to **recognition + application**
- Methodology becomes architecturally different: an authored library of context-keyed expert practice (case patterns, sequencing instincts, evaluation priorities, completion criteria)

### §3.3 How the two arguments fit together

- Decomposition without library = competent but tutorial-grade
- Library without decomposition = right content, can't reliably apply it
- Together = bite-sized prompts at every step + retrieval at lynchpin strategic moments
- **Six things orchestration externalizes** (each doing one of the two jobs):
  - Phase position and transitions ← decomposition
  - Per-phase prompts scoped to one well-bounded task ← decomposition
  - Structured state passed between phases ← decomposition
  - Catalogs of evaluations, indexed by image category and phase ← library retrieval
  - Catalogs of operations with sequencing rules ← library retrieval
  - Completion criteria per image category and goal ← library retrieval
- Line through middle: first three = right question at right time; last three = curated content instead of LLM-derived
- A mega-prompt fails on all six. Decomposition-only fails on the last three. Both together has its best shot.
- What's left for the LLM:
  - Looking carefully when prompted to look carefully
  - Recognizing which case applies
  - Applying retrieved practice to specifics
  - Explaining reasoning to the user
  - Adapting to questions and pushback

## §4 What This Translates to in the Build

- Four major parts: workflow library, prompt library, orchestrator, LLM

### §4.1 The workflow library

- Workflow = state machine for one kind of work
  - States, valid transitions, work-per-state, entry/exit conditions, structured output per state
- Master workflow (intake, routing) + sub-workflows (portrait, landscape, low-light, product)
- Sub-workflows can invoke other sub-workflows (portrait → backlit-subject → return)
- **Two artifacts per workflow**:
  - JSON definition (executable spec — orchestrator reads at runtime)
  - Narrative document (design intent — humans edit when refining)
  - Stay in sync; JSON is runtime truth, narrative is design truth
- Library stores routing metadata (what conditions invoke this workflow, expected inputs, outputs)

### §4.2 The prompt library

- One prompt template per (workflow, state)
- Parameterized: takes state inputs (image state, established context, prior findings, retrieved methodology) → produces actual prompt
- Output schema defined per state (orchestrator parses response accordingly)
- Templates do one of two jobs:
  - Decomposition framing (cognitive frame for tightly-scoped reasoning)
  - Retrieval application (apply piece of retrieved methodology to specifics)

### §4.3 The orchestrator

- Runtime that holds it all together
- **Responsibilities**:
  - Workflow tracking (active workflow, active state, state vars, call stack)
  - Transition logic (evaluate conditions against output + state)
  - Prompt composition (template + inputs + retrieved methodology)
  - Output handling (parse response per schema, update state, trigger next transition)
  - Routing across workflows (push/pop nested workflows)
- Orchestrator never asks LLM to: make routing decisions, evaluate transitions, decide what state it's in
- LLM bounded to: producing structured output its current state expects, given the composed prompt

### §4.4 The LLM

- Invoked once per state activation
- Each invocation: tightly-scoped, specific prompt + inputs + (optionally) retrieved methodology + expected output schema
- **No conversation history across invocations** — model's memory is the orchestrator's structured state, not the LLM context window
- Why this works: every invocation starts from known controlled context, model asked exactly one well-bounded question

### §4.5 How a session actually runs (illustrative)

- *NOTE: caveat that this is overly specific; concepts > details*
- User uploads image → orchestrator initializes session in master workflow
- Master workflow: classify image, surface candidate goals
- LLM returns structured output → orchestrator updates state, evaluates transitions
- Either advances within master (e.g., goal confirmation) or dispatches to category sub-workflow
- Inside sub-workflow: same pattern repeats per state
- User applies edits → input to next state (verify state re-evaluates plan)
- Sub-workflow completes → returns to master → either session done or next sub-workflow

### §4.6 What the engineer needs to know up front

- JSON workflow definitions = executable contract (states, transitions, guards, I/O specs, prompt + methodology refs)
- Prompt templates stored alongside workflows; versioned together
- Methodology library = content, separate, indexed by image category + phase + case pattern
- State persistence handles in-progress sessions including workflow stack (resumable)
- LLM is stateless function call from orchestrator's perspective

## §5 Development and Refinement Loop

- **Methodology = hypothesis on day one**, not finished artifact
- **Build initial methodology**: pro photographer interviews, novice mistakes analysis, standard editing workflow knowledge
  - Define: phase machine, evaluation catalogs (per category), operation catalogs (per category + tier), sequencing rules, completion criteria, failure-mode warnings
- **Assemble test set**: portraits, landscapes, food, low-light, travel, pets, product, backlit, high-contrast, mobile, RAW — varied in quality, lighting, color, composition
- **Generate four edit paths per test image**:
  - Unguided novice
  - Generic LLM-guided novice
  - Structured-methodology AI-assisted novice
  - Professional reference (with reasoning captured)
- **Bar:** structured must beat generic-LLM, not just unguided
- **Evaluate and gap-analyze**:
  - Score: visual improvement, naturalness, color/skin, highlight/shadow, subject emphasis, composition, avoiding overediting, tool use, consistency, user understanding, similarity to pro
  - Isolate causes: where methodology improved, where generic was just as good, where pro made a better call, where state tracking broke, where catalogs were missing
- **Refine and re-test**: phase machine, catalogs, sequencing rules, completion criteria, prompt templates, state-tracking
- **Target:** measurable improvement, not perfection

---

## Observations from making this outline

- **§1 packs a lot into a small space.** The orchestration mechanisms get listed (state, modules, tool exposure, image observation) but each one is one line. §3 is where they get developed. The forward reference works because §3 actually pays off.
- **§3 is the spine of the document.** Outlining it surfaces three sub-arguments that fit together cleanly. The "six things orchestration externalizes" list is doing real work (it's the bridge from abstract argument to concrete design).
- **§4 reads like reference material, not argument.** Every subsection is a definition of a system component. The argument lives in §3; §4 is "given §3, here's what we build."
- **§5 is procedural and well-shaped.** Build → assemble → generate → evaluate → refine. Five clear phases with concrete content per phase.
- **What's structurally exposed by outlining:** §1 + §3 do most of the load-bearing work. §2 is mostly UX framing that survives intact. §4 is build description (could potentially be tighter). §5 is the methodology iteration loop and reads cleanly.
