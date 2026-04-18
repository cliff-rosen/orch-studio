# Flavors of Encoded Expertise: What Orchestration Actually Captures

By **Cliff Rosen**, Founder & CTO, Orchestrator Studios

April 2026

---

Every orchestration project starts the same way. A human who knows how the work should be done sits down with someone who knows how to build systems, and together they try to translate one into the other. The design problem isn't "how do we use the LLM." It's "how do we capture what this person knows well enough that a system can act on it."

The framing question gets taken for granted: we say we're "encoding expertise." But expertise isn't one thing. It comes in distinct flavors, each with a different shape, a different characteristic artifact, and a different failure mode when missed.

Teams routinely miss flavors. They encode the decomposition beautifully but never articulate the decision points where the agent must choose among operations. They build perfect tools but never specify what "good enough" looks like at each stage. They document constraints but forget handoff protocols. The result is an orchestration that works for the happy path and falls apart the moment the work requires expertise the designers didn't realize they had.

This article names the flavors. Eight of them. The goal isn't a rigid taxonomy — it's a checklist for the designer. When you look at an orchestration, you should be able to ask, for each flavor: where does this live? If the answer is "nowhere" or "implicit in the LLM's judgment," that's where the next failure will come from.

## The Eight Flavors

### 1. Decomposition Patterns

**What it captures.** How a large task breaks into smaller ones. The expertise is knowing the *seams* — where to cut so each sub-task is tractable, verifiable, and recoverable. Experienced practitioners don't just "do taxes" or "write a memo" — they have a mental decomposition that isolates phases in a specific order, with each phase producing something the next phase can consume.

**Artifact.** Task graphs. Pipeline specifications. Phase diagrams.

**Recognition cue.** You need this flavor when the work is too large for a single LLM call but has natural stages that a practitioner can name. If a domain expert can say "first I do X, then Y, then Z" — that sequence is the decomposition.

**Failure when missed.** The system tries to do everything in one pass. Output is shallow, inconsistent, or collapses under the weight of competing sub-goals.

### 2. Decision-Point Cartography

**What it captures.** The points at which an agent must choose among operations, and the principles that should govern each choice. Not rules like "if X then Y" — the underlying structure that lets a plan be composed on the fly. What expert practitioners encode here is *how they decide*, not *what they do*.

**Artifact.** Decision trees. State diagrams. Navigable topologies of choice.

**Recognition cue.** You need this flavor when the work has multiple valid next operations at each step and the right choice depends on the current state. Symptoms of missing it: the agent "railroads" down one path, or thrashes between approaches without committing.

**Failure when missed.** The agent picks operations in the wrong order, revisits settled choices, or commits too early to paths it should have held open.

### 3. Precondition Discipline

**What it captures.** What must be true before an operation runs. Expert practitioners have a pre-flight checklist that prevents downstream disasters. A surgeon doesn't just cut — there's a whole setup protocol that encodes "things that must be verified first." For agents, this means gating tool calls behind explicit state checks.

**Artifact.** Gate conditions. Precondition lists. Setup protocols.

**Recognition cue.** You need this flavor when certain operations are irreversible or expensive, and executing them with the wrong prerequisites produces a cascading mess. If an expert would pause and check something before acting, that check is a precondition.

**Failure when missed.** The agent executes in states where the operation doesn't make sense. Errors compound because the setup was wrong, not the action.

### 4. Quality-Gate Calibration

**What it captures.** What "good enough" looks like at each stage, and what triggers a retry, a repair, or an escalation. Experts have calibrated thresholds; novices either accept junk or polish forever. The encoding specifies the gate, and specifies the repair path when the gate fails.

**Artifact.** Rubrics. Evaluators. Checklists. Acceptance criteria.

**Recognition cue.** You need this flavor whenever a stage produces output that a downstream stage will consume. If you can't state what would make you reject the output, the gate doesn't exist yet.

**Failure when missed.** Errors propagate silently. By the time the problem surfaces, it's three stages downstream of where it originated, and the fix requires redoing everything.

### 5. Failure-Mode Taxonomies

**What it captures.** The characteristic ways things go wrong in this domain, and the matching responses. Experienced debuggers don't try random fixes — they recognize the *shape* of the failure and apply the matching diagnostic. Encoding this gives the agent a recognizer-plus-response library instead of general problem-solving.

**Artifact.** Recognizer-response tables. Symptom-to-diagnosis mappings. Recovery playbooks.

**Recognition cue.** You need this flavor when the work has recurring failure patterns that experienced practitioners can name. If a domain expert would say "oh, that's the X problem — here's what you do" — that's a recognizer-response pair.

**Failure when missed.** Every failure becomes a novel problem. The agent (or the system around it) has no memory of how similar problems were handled before, and no shortcut to the fix.

### 6. State-Externalization Patterns

**What it captures.** What the agent needs to remember, in what form, so that context doesn't collapse across turns. The expertise is knowing *what* to externalize — which parts of working state are load-bearing versus ephemeral. Expert practitioners keep notes, checklists, and running summaries that carry the important state forward and let the rest fall away.

**Artifact.** Schemas. Knowledge-base designs. Explicit state objects. Running logs.

**Recognition cue.** You need this flavor when the work accumulates information over time that must survive across operations. If an expert would keep a notepad open while working, that notepad has a schema — and that schema is what needs encoding.

**Failure when missed.** The agent loses track. Earlier decisions are forgotten or re-litigated. State lives as narrative in the conversation instead of as actual tracked data, which means it's unreliable by construction.

### 7. Constraint Articulation

**What it captures.** The implicit rules of the domain that shape all operations. A lawyer drafting a contract has dozens of constraints running in the background — jurisdiction, precedent, client risk tolerance — that never get stated but always apply. Encoding this means making the constraints explicit so the agent can check against them instead of rediscovering them every call.

**Artifact.** Constraint lists. Invariants. Domain-specific rule sets. Style guides.

**Recognition cue.** You need this flavor whenever experts would reject output that a non-expert would accept. The rejection criterion, articulated, is the constraint.

**Failure when missed.** Output looks plausible to someone outside the domain and wrong to anyone inside it. The agent confidently violates rules no one ever told it existed.

### 8. Handoff Protocols

**What it captures.** How work passes between stages, between agents, or between agent and human. Experts know what information must travel with the work so the next party can proceed without re-discovery. This flavor shows up heavily in multi-agent systems — and also in every check-in with the user, because a check-in is a handoff.

**Artifact.** Handoff schemas. Check-in gates. Context summaries designed for the next consumer.

**Recognition cue.** You need this flavor anywhere work changes hands. If a human review step, a user confirmation, or a pass between agent roles exists in the design, each one needs a handoff protocol. Symptoms of missing it: the next party has to ask "what did you do and why" every time.

**Failure when missed.** Each handoff becomes a re-start. Context is lost, decisions are reopened, and the system runs on the fiction that everyone has full visibility when nobody does.

## A Worked Example: Table Enrichment

Consider a real orchestration problem. A user wants to build a comparison table — options for a decision, candidates for a shortlist, vendors for evaluation. The system supports a handful of operations: propose a schema, propose rows, extend rows, extend columns, repair existing cells. The goal is to drive toward a complete, correct table.

This is a single problem. It exercises six of the eight flavors at once.

**Decomposition Patterns.** The operations themselves are the decomposition. Schema before rows, rows before enrichment, enrichment in clear modes (extend versus repair). That sequencing isn't arbitrary — it encodes a specific theory of how tables get built well.

**Decision-Point Cartography.** At every turn, the agent must choose among operations. The governing principle isn't obvious. *Blast radius* matters — schema changes affect the whole table, cell fills affect one cell. *Homogeneity of retrieval* matters — columns whose values all come from the same source can be batched; columns whose values require different strategies cannot. *User intervention boundaries* matter — the decomposition should break at the points where the user might want to grab the wheel. None of this is rule-based. All of it is cartographic.

**Precondition Discipline.** Extending rows only makes sense after the schema is stable. Column repair only makes sense after the columns exist and have values worth repairing. Running enrichment before the user has confirmed the row set is a common failure — the agent commits compute to rows that are about to be thrown away.

**Quality-Gate Calibration.** What does a good schema look like? What counts as a sufficient row set? When is a column "complete enough" to move on? Without these calibrated, the agent either proceeds past obvious gaps or polishes indefinitely.

**Failure-Mode Taxonomies.** The railroading failure — agent proposes and proposes without checking in — has a specific shape and a specific response (introduce check-in gates at high-blast-radius operations). The unclear-objective failure — agent fills cells without knowing why this column matters for this table — has a different shape and a different response (require the agent to state the objective of the next operation before executing it). These aren't general LLM problems. They're recurring patterns in this specific domain.

**Handoff Protocols.** Every user check-in is a handoff. What travels with it? The user needs enough context to evaluate the proposal, not the full reasoning trace that produced it. Between the schema-proposal stage and the row-proposal stage, what does the second stage need from the first? Not the conversation — the distilled schema, plus the user's confirmation that it's the right schema. The handoff shape determines whether the user can actually steer.

Two flavors — Constraint Articulation and State-Externalization — are lighter in this example but still present. Constraints show up as the domain-specific rules about what makes a useful table (no redundant columns, comparable values, etc.). State externalization shows up as the schema and row set themselves, which live outside the LLM as actual data rather than narrative about data.

The point isn't that every flavor gets equal weight. It's that a single real orchestration problem engages most of them. Getting any one wrong produces a specific, predictable failure. A team that only thought about decomposition and tools would ship a system that railroads the user, has no stopping condition, and can't recover from its own mistakes.

## The Design Implication

Three claims.

**Each flavor has a characteristic shape of artifact.** Decomposition yields task graphs. Cartography yields decision trees. Quality gates yield rubrics. Failure taxonomies yield recognizer-response tables. State externalization yields schemas. If your orchestration design has no artifact of a given shape, you have probably skipped that flavor — and the failure it prevents is waiting for you.

**Teams without this taxonomy tend to over-invest in one or two flavors and under-invest in the others.** The two that get attention are usually Decomposition Patterns and Tool Abstraction (which shows up inside Decision-Point Cartography). The ones that get missed are usually Quality-Gate Calibration, Failure-Mode Taxonomies, and Handoff Protocols. Those three are what separates an orchestration that works for the designer from one that works for the user.

**The payoff of naming the flavors is auditability.** You can look at any orchestration design and ask, for each flavor: where does this live? If the answer is "nowhere," you have a design gap. If the answer is "implicit in the LLM's judgment," you have a latent failure. If the answer is a named artifact, you have something you can inspect, test, and improve.

The model is not the bottleneck. The expertise the model is orchestrated around is. And that expertise is nameable — which means it is capturable, which means it is improvable.

---

© 2026 Orchestrator Studios