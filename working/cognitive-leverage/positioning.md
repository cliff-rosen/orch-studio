# Positioning

How to frame cognitive leverage for external audiences. The canon (`synthesis.md`) is the underlying framework; this file is how it gets communicated depending on who's on the other side.

The canon does one job: state what's true. Positioning does a different job: make it land. Keep them separate so the canon doesn't get bent by rhetorical choices and positioning doesn't drift from what's actually true.

---

## Fleet management vs. cognitive leverage — five cuts of the same distinction

Useful when the simple diagnostic ("are you optimizing throughput within an inherited allocation, or optimizing the allocation itself?") isn't landing. Each cut is a different angle on the same thing:

1. **Supply vs. demand.** Fleet management optimizes the supply side (more agents, better coordination). Cognitive leverage is demand-side — operator attention is the binding constraint.
2. **Human as manager vs. component.** Fleet management treats the human as manager *of* the system. Cognitive leverage treats the human as a *component in* the system — the rate-limiting one.
3. **Optimizing vs. culling.** Fleet management assumes the fleet should exist as constituted and optimizes within it. Cognitive leverage includes culling as a core function — "should this project exist at all?"
4. **Opportunity cost visibility.** Fleet management sees agent-vs-agent trade-offs. Cognitive leverage also sees *agent-vs-non-agent* — relationships, rest, strategic thinking. Invisible on a fleet scorecard.
5. **Snapshot vs. portfolio-over-time.** Fleet management describes a state. Cognitive leverage is portfolio optimization over time.

**The punch line**: you can have perfect fleet management and still be in a mathematically misallocated portfolio. The fleet hums, but the operator's cognitive budget is consumed by below-threshold projects, invisible holdings, or allocations with badly unequalized marginal returns. Fleet management's scorecard doesn't see this.

## Execution leverage vs. cognitive leverage — a cut by operator intent

- **Execution leverage** — using the orchestrated system as a faster way to build the thing already planned. Agent-speed applied to a pre-committed plan.
- **Cognitive leverage** — using the orchestrated system to *change* what's planned. Agent-speed applied to decisions, not just execution.

Most people using agents today are in the first mode. The framework is about operating in the second.

---

## Two use cases for the framework

The same framework serves two audiences with different rhetorical needs:

| Use case | Audience | Goal | What to foreground |
|---|---|---|---|
| **Internal strategic memo** | Partner / co-operator | Decide how to run *our* business | The math for our specific commitments. Delegation map. Reinvestment stance. Walking through the N-math table with our actual `C` and current `t_i`. |
| **External market pitch** | Collaborators, investors, market | Recognize the category shift | Gold rush framing. Clone thought experiment. The enablement whitespace. "2026 was orchestration; 2027 is cognitive leverage." |

Both are valid products of the framework. They share primitives (`C`, `t_i`, `R_i`, two drivers) but diverge in what they foreground. Derived writing should be clear which use case it's serving — save drafts with filenames that signal which.

Orthogonal axis flagged in sources: **practitioners vs. leaders**. For practitioners it's personal productivity; for leaders it's organizational design. This cut is distinct from internal-vs-external and may matter for specific positioning choices.

---

## Rhetorical hooks

### The clone thought experiment

Shortest path to the core insight for an unprimed reader:

> Think back to any point in your career when you had good people working for you. Imagine that on some ordinary Tuesday morning you could have cloned any of them — instantly, for free, as many times as you wanted. Would you have done it? Obviously yes. How many? Until managing them became the bottleneck. That ceiling was always you; you just never got close enough to feel it. The clones are available now.

Works because it lets the reader do the derivation themselves. **Use for external pitch, not internal analysis.**

### Gold rush framing

For market-level pieces:

> The infrastructure doesn't exist yet. The best practices haven't been written. The picks and shovels haven't been built. That's not a problem — that's the opportunity.

### The timing line

> 2026 was the year of orchestration. 2027 is the year of cognitive leverage.

Good positioning hook. Works because the shift from "make agents reliable" to "decide what to point them at" is exactly what's moved to the frontier.

### The "faster typewriter vs. cognitive instrument" contrast

For an opener that shows the shift without defining it:

> Someone using a well-orchestrated system as a faster typewriter vs. someone using it as a cognitive instrument. The difference isn't the orchestration; it's what the human is doing at the top of the stack.

---

## Rhetorical principles

Extracted from drafting across the source conversations:

- **Don't overclaim novelty.** The delegation tradeoff isn't new. Comparative advantage isn't new (Ricardo). Quality-for-volume tradeoffs aren't new (pricing, manufacturing, offshoring). What's new is *specifically* the two drivers — and the threshold `t_i` collapsing as a consequence.
- **Ground abstractions in the founding commitment**, not economic theory. "Two fixed inputs and a clear purpose" lands better than "a four-factor model."
- **"Then and now" walkthrough structure** for case material: how the math worked pre-AI, what AI changed, what actually happened, what remains.
- **Pieces for partners should open conversations**, not close them. Quiet, not punchy, closes.
- **Credit the small move before the big move.** The N=1→N=2 step at Orchestrator Studios was an unspoken cognitive-leverage move; use it as the bridge.
- **Don't land on "develop the skill"** when pitching the market opportunity. Category creation is a bigger story than individual prescription.
- **Vocabulary UX principle**: precise terms stay internal; UX speaks in sensations (drift / neglect / momentum) — not variables.

---

## Product-category framing — for infrastructure-opportunity pitches

When the pitch is about the enablement market (building the picks and shovels), the closest product-category analogy is **command and control (C2)** — the kind of system that exists in military operations, trading floors, air traffic control. Shared characteristics:
- Universe large, dynamic, partially observable
- Resources limited and allocated in real time
- Decisions must be made faster than any individual can manually process
- Cost of blind spots is high

Knowledge work has crossed the complexity threshold that requires this class of infrastructure. See `universe-model.md` for the requirements treatment.
