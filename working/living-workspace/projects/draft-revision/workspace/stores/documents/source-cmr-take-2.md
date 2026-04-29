---
kind: source
title: "AI-Driven Photo Editing Methodology — cmr take 2"
order: 4
focus: true
parent: source-hypothesis-options
created_at: "2026-04-28T15:00:00Z"
---

# AI-Driven Photo Editing Methodology

## 1. Goal

Build an AI-assisted photo editing system that helps novices produce visibly stronger images and learn to edit more effectively in the process. The system guides users through a structured, expert-informed workflow that adapts to the image, the user's skill level, the desired outcome, and the current stage of the edit.

Achieving this reliably — not occasionally, not on cherry-picked images — requires more than a well-written prompt. It requires a structured orchestration layer that manages workflow state, selects expert methodology modules conditionally, constrains tool exposure, and observes the image as it evolves. Section 3 makes the case for each of those mechanisms concretely. For now, the headline is: the LLM handles communication and adaptation; the orchestration layer handles control.

## 2. Target User Experience

The user opens an image. The system analyzes it and gathers context: image type, likely strengths and weaknesses, user proficiency, desired mood or style, available tools, relevant metadata. Based on that context it selects the appropriate methodology modules and guides the user step by step.

The interaction is a closed loop: system gives the next instruction in plain language with rationale → user applies the adjustment → system observes the updated image state → system updates state and gives the next instruction. The user can ask questions or push back at any point, and guidance adapts. The loop continues until the edit reaches an acceptable result.

This is not prompt-and-response. The system sees the image evolve and teaches the user what to do next.

## 3. Why a Mega-Prompt Falls Short — and What Orchestration Actually Buys

Ask a professional photographer to edit an image and you trigger a silent, deep, internal process. They establish what the image is for and what the user wants from it. They look at the image carefully — not just for problems, but for opportunities, for what's recoverable, for what's interesting that a checklist would miss. They form a rough roadmap of phases: get the foundation right first, then refine, then finish. Within each phase they reason about which specific operations to perform, in what order, with what intensity, given everything they've established so far. They evaluate as they go, and revise the plan when an operation reveals something new or fails to deliver what they expected. They know when to stop. The result is a sequence of operations and, presumably, a good outcome.

Now imagine doing the same thing with an LLM via a single mega-prompt: the image, a description of the editing methodology, a state machine describing the phases of work, catalogs of evaluations and operations, completion criteria, and a request to "help the user edit this image." The LLM will produce something. It will be plausible. It will not be good — and the reasons it won't be good come in two distinct kinds, both of which orchestration addresses, but in different ways.

### The first argument: decomposition

A mega-prompt asks the LLM to do, silently and in one pass, work that needs to be done in stages with structured handoffs between them. The model is asked simultaneously to figure out which phase of the work applies right now, what context still needs establishing, which evaluations are relevant, which operations to consider, whether prior recommendations have been honored, and whether the work is done. There is nothing in the prompt structure forcing it to inhabit one of those tasks at a time. What training rewards is producing a fluent end-to-end response. So the model satisfices: it produces a coherent answer that *resembles* the output of careful staged work without actually doing the staged work.

This is the failure mode underlying every "the LLM compressed phases," "the LLM gave a generic readout," "the LLM produced a plausible plan instead of an analytic one," and "the LLM kept recommending things past the point of being done." All of them are the same failure — too much being asked at once — surfacing in different places in the workflow.

The fix is decomposition. The orchestrator externalizes the phase machine and invokes the LLM once per phase, with a prompt scoped to that phase's task only. The output of each phase is a structured artifact that becomes input to the next. The model never sees the full machine — it sees the current phase's well-bounded question. Because the question is well-bounded, the model has its best shot at being genuinely smart about it. Because the orchestrator controls phase transitions, things like "establish context before planning" and "re-evaluate after an operation" and "check completion criteria before recommending more" stop being judgments the model makes implicitly under conditions where it will satisfice, and become structural inevitabilities of the workflow. The principle is: never ask the LLM to do more than it has to do. Every silent compression is leverage lost.

### The second argument: library retrieval at lynchpin moments

The decomposition argument explains why bite-sized prompts beat mega-prompts. But it has a ceiling. Suppose the orchestrator decomposes perfectly and asks the LLM exactly the right tightly-scoped question at every step. Now ask: when the LLM produces, say, a high-level analysis strategy for a difficult backlit portrait — how good is that strategy, compared to what a working pro would produce for the same image?

Even ideally prompted, the LLM is producing the strategy by reasoning from its training data. The pro is doing something different. The pro is recognizing the situation — "this is the backlit-portrait-with-recoverable-rim-light case" — and pulling the matching practice from an internalized library of expert moves built up over years of working with similar images. At those moments the pro is not solving the problem from first principles. They are pattern-matching against curated, context-keyed expertise that took years to accumulate, and adapting it to the specifics in front of them. The LLM's training corpus contains the *appearance* of that expertise — tutorials describing what photographers do — but not the curated, situation-indexed library a working pro carries.

This means there are key moments in the workflow where the right move is not "ask the LLM a smaller, smarter question" but "do not ask the LLM the strategic question at all." Instead: have the orchestrator recognize the situation, retrieve the matching authored practice from a curated library, and ask the LLM to instantiate it against the specifics of this image. The LLM's job at those moments shifts from generation to recognition and application. It is no longer being asked "what's the right strategy here?" — it is being told "the right strategy here is X; apply it to the specifics of this case." Recognition-and-application is a task the LLM can do well. Strategy generation against tacit expert practice is not.

This is what turns the methodology from "better instructions for the LLM to reason from" into something architecturally different: an authored library of context-keyed expert practice — case patterns, sequencing instincts, evaluation priorities, completion criteria — that the orchestrator selects from based on the situation. The library is the content. Decomposition is what makes the LLM able to apply the library well. Both are necessary.

### How the two arguments fit together

Decomposition without an authored library produces a competent but tutorial-grade system: the LLM is being asked smart questions, but it's answering them from its priors, which top out at what's in the corpus. An authored library without decomposition produces a system that has the right content but can't reliably apply it: the model gets the methodology but compresses and satisfices when actually using it. Together they produce something neither one delivers alone — bite-sized prompts at every step so the LLM operates at its best, and at the lynchpin strategic moments, retrieval from authored expert practice rather than fresh generation.

Concretely, this means orchestration externalizes a stack of things, and each one is doing one of these two jobs:

- **Phase position and phase transitions.** Decomposition. Without these, phases get compressed.
- **Per-phase prompts scoped to one well-bounded task.** Decomposition. Without these, the model is asked too many questions at once and satisfices.
- **Structured state passed between phases.** Decomposition. Without it, phase outputs degrade into narrative the next phase has to re-derive.
- **Catalogs of evaluations, indexed by image category and phase.** Library retrieval. Without these, the model produces general-purpose readouts instead of the specific evaluations a pro would run for this situation.
- **Catalogs of operations, with sequencing rules, indexed by image category and proficiency tier.** Library retrieval. Without these, the model produces operation sequences from its general repertoire instead of the curated set a pro would draw from.
- **Completion criteria, per image category and goal.** Library retrieval. Without these, the model is being asked an open-ended "what's next" when the right question is a closed "does this meet X, Y, Z."

The line between the two arguments runs through the middle of this list. The first three items are about asking the LLM the right question at the right time. The last three are about answering the strategic question with curated content rather than asking the LLM to derive it. A mega-prompt fails on all six. A decomposition-only system fails on the last three. A system with both has its best shot at producing genuinely expert outcomes.

What's left for the LLM, after all of this is externalized, is what the LLM is actually good at: looking carefully when prompted to look carefully, recognizing which case from the library applies to this situation, applying the retrieved practice to the specifics in front of it, explaining its reasoning to the user, and adapting to questions and pushback. That is a smaller job than "edit this image like a pro." It is also a job the model can do reliably.

## 4. What This Translates to in the Build

The arguments above describe what the system has to do. This section makes concrete what the system actually is, so the engineering team has a working mental model when they read this spec.

The system has four major parts: a workflow library, a prompt library, an orchestrator, and the LLM itself.

### The workflow library

A workflow is a state machine describing how a particular kind of work proceeds: what states exist, what valid transitions between them are, what work happens in each state, what state must be true to enter or exit each state, and what the structured output of each state looks like.

There is a master workflow that every editing session enters. It handles initial intake — establishing image category, user intent, proficiency, and the relevant constraints — and then routes to one or more sub-workflows based on what it has established. Each sub-workflow handles a specific kind of work: a portrait workflow, a landscape workflow, a low-light workflow, a product-photo workflow. Sub-workflows can themselves invoke other sub-workflows — a portrait workflow might hand off to a backlit-subject sub-workflow when its analysis stage flags the case, then resume when that sub-workflow returns.

For each workflow, the library stores two artifacts. The first is a JSON definition: states, valid transitions, the conditions under which each transition fires, the structured inputs each state requires, and the structured outputs each state produces. This is the executable spec — what the orchestrator reads to know what's legal at any moment. The second is a narrative document explaining what the workflow is for, how it's intended to behave, why the states are designed the way they are, and what the design decisions were. This is the human-readable document — what an engineer or methodology author reads when reasoning about whether the workflow is correct, and what they edit when refining it. The two stay in sync; the JSON is the source of truth at runtime, the narrative is the source of truth for design intent.

The library also stores routing metadata for each workflow: what conditions cause it to be invoked, what inputs it expects, and what outputs it produces back to its caller. This is what allows the master workflow — and any sub-workflow — to dispatch correctly.

### The prompt library

For each state in each workflow, there is a prompt template that defines how the LLM is invoked when that state is active. Prompt templates are parameterized: they take the state's inputs (current image state, established context, evaluation findings from prior states, retrieved methodology content) and produce the actual prompt sent to the LLM. The output schema is also defined per state, so the orchestrator knows how to parse what comes back and update state from it.

Prompt templates are not free-form. They are written specifically to do one of the two jobs described in Section 3: either to put the LLM into the right cognitive frame for a tightly-scoped reasoning task (decomposition), or to ask the LLM to apply a piece of retrieved methodology to the specifics of this image (library retrieval). A prompt template either includes the methodology content the LLM is meant to apply, or it doesn't — and the choice corresponds to which kind of work this state is asking the LLM to do.

### The orchestrator

The orchestrator is the runtime that holds everything together. Its responsibilities are:

- **Workflow tracking.** For any active session, the orchestrator knows which workflow is currently engaged, which state within that workflow is active, what the workflow's state variables currently hold, and what the call stack of nested workflows looks like.
- **Transition logic.** When a state's work completes and produces output, the orchestrator evaluates the workflow's transition conditions against that output (and against accumulated session state) and moves the session to the next valid state.
- **Prompt composition.** When entering a state, the orchestrator pulls the prompt template for that state, populates it with the current state's inputs, retrieves the relevant methodology content from the library, and produces the actual prompt sent to the LLM.
- **Output handling.** When the LLM responds, the orchestrator parses the response according to the state's output schema, updates session state, and triggers the next transition.
- **Routing across workflows.** When a workflow's transition logic dictates handoff to a sub-workflow, the orchestrator pushes the current workflow's frame onto the stack, initializes the sub-workflow with the appropriate inputs, and resumes the parent when the sub-workflow returns.

The orchestrator never asks the LLM to make routing decisions, evaluate transition conditions, or decide what state it's in. Those are deterministic operations performed by code against the workflow JSON. The LLM's role is bounded to producing the structured output its current state expects, given the prompt the orchestrator composes for it.

### The LLM

The LLM is invoked once per state activation. Each invocation is a tightly-scoped task with a specific prompt template, specific inputs, specific retrieved methodology content (where applicable), and a specific expected output schema. The LLM does not maintain conversation history across invocations in the way a chatbot would — its memory across the session is entirely the structured state the orchestrator carries between invocations. This is what makes the model's behavior reliable: every invocation starts from a known, controlled context, and the model is asked exactly one well-bounded question.

### How a session actually runs

*NOTE: this is overly specific for instructional purposes. Pay more attention to the concepts rather than the details.*

A user uploads an image. The orchestrator initializes a session and enters the master workflow at its initial state. That state's prompt template asks the LLM to perform image classification and surface candidate goals. The LLM returns structured output. The orchestrator updates state, evaluates the master workflow's transitions, and either moves to the next state in the master workflow (e.g., goal confirmation with the user) or, once enough is established, dispatches to the appropriate category sub-workflow.

Inside the sub-workflow, the same pattern repeats: each state activates a prompt template, retrieves any relevant methodology content from the library, invokes the LLM, parses the response, updates state, and transitions. When the user applies an edit in the editing tool, that becomes input to the next state — a verify state that re-evaluates whether the plan still holds. When the workflow's completion conditions are met, it returns control to the master workflow, which decides whether the session is finished or another sub-workflow should now run.

What an engineer building this needs to know up front:

- **JSON workflow definitions** are the executable contract. Schema needs to support states, transitions, transition guards, input/output specs, and references to prompt templates and methodology content.
- **Prompt templates** are stored alongside workflows and versioned together with them. Changing a prompt template is a workflow change.
- **The methodology library** is content, stored separately, indexed by image category, phase, and case pattern. Workflows reference into it; they don't contain it.
- **State persistence** has to handle in-progress sessions, including the workflow stack. A session can be paused and resumed; the orchestrator's session state is the source of truth.
- **The LLM is a stateless function call** from the orchestrator's perspective. Everything that needs to persist persists in orchestrator state, not in the model's context window.

This is what a working version of the system looks like. The methodology work — authoring the workflows, the prompt templates, and the methodology library — is the substantive content work. The orchestrator and the integration with the LLM are the engineering scaffolding that makes that content executable.

## 5. Development and Refinement Loop

The methodology is a hypothesis on day one, not a finished artifact. Improvement comes from running it against real editing behavior and professional reference outcomes, finding the gaps, and refining.

**Build the initial methodology** from professional photographer interviews, analysis of common novice mistakes, and existing knowledge of standard editing workflows. Define the phase machine, the evaluation catalogs per category, the operation catalogs per category and proficiency tier, the sequencing rules, the completion criteria, and the failure-mode warnings.

**Assemble a test set** across portraits, landscapes, food, low-light indoor, travel, pets, product-style, backlit subjects, high-contrast scenes, mobile photos, and RAW files — varied in quality, lighting, color, and composition.

**Generate four edit paths per test image:** unguided novice, generic LLM-guided novice, structured-methodology AI-assisted novice, and a professional reference edit with the pro's reasoning captured. The structured system must beat the generic-LLM path, not just the unguided baseline. That's the bar.

**Evaluate and gap-analyze.** Score on visual improvement, naturalness, color and skin tone, highlight/shadow preservation, subject emphasis, composition, avoidance of overediting, appropriate tool use, consistency, user understanding, and similarity to professional decisions. Then isolate causes: where did the methodology improve outcomes, where was generic guidance just as good, where did the pro make a better call, where did state tracking or context injection break down, where were the evaluation or operation catalogs missing something the pro relied on.

**Refine and re-test** the phase machine, catalogs, sequencing rules, completion criteria, prompt templates, and state-tracking logic. Continue until structured AI-assisted edits consistently beat both unguided and generic-LLM paths. The target is measurable improvement, not perfection.
