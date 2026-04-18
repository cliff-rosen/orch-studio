# The Decomposition of `x_i`

What the operator's cognitive cost per project is actually made of. Decomposes the `x_i` that the canon treats as a scalar (`synthesis.md` § The Canon) into its constituent components — each with different behavior, different reducibility, and different levers.

This is the zoomed-in view. The optimization itself lives in the hub.

---

## The four components

For any active project `i`:

```
x_i  =  CCC_outbound + CCC_intake + CCC_horizon + CCC_irreducible
```

This is the accounting identity for where operator cognitive capacity goes per project. Each component behaves differently and responds to different levers.

- **`CCC_outbound`** — Specification cost. Directing the agent, scoping work, setting quality gates, articulating the next step. **Engineerable toward efficiency** via better upfront specs, bounded degrees of freedom, and encoded expertise in tooling.
- **`CCC_intake`** — Digestion cost. Absorption + pattern recognition + model updating + next-step formation. *Largely irreducible.* Scales with **epistemic density** (how much the output changes what you know), not with output volume. **The binding constraint on delegation velocity.** The sharper operator-experience term for this component is *assimilation*.
- **`CCC_horizon`** — Horizon scanning cost. Sensing what's coming, folding new reality back into the shared model before the gap becomes a cliff. Varies with environmental volatility and how novel the territory is. **Cannot be delegated** — requires weak signals only the operator can perceive and cross-project pattern recognition.
- **`CCC_irreducible`** — Structural human cost. Relationships/trust, novel judgment, motivational leadership. No tooling reduces this.

**Shorthand split**: `CCC_reducible` (outbound + some intake) vs. `CCC_irreducible` (horizon + relationships + novelty). The leverage play is collapsing the reducible portion toward zero — then paying only the irreducible human tax.

## The design rubric for architectural investment

When considering any tool, process change, or pipeline — anything that reshapes how `x_i` is spent — evaluate it with:

> **Does this reduce `CCC_reducible` (outbound + intake) without increasing `CCC_horizon` or `CCC_irreducible`?**

A good tool collapses the reducible cost without shifting cost to parts that are already hard to pay. Common failure modes:

- **Dashboards that expand intake.** Reduce outbound (you spec better) but increase intake (more to digest). Net can be negative.
- **Context-curation systems that expand horizon work.** Make future delegation cheaper but add ongoing horizon-maintenance burden.
- **Quality gates that shift affirmation load to the operator.** Reduce agent drift but add affirmation engagement points — a wasteful category (see engagement anatomy below).

Apply the rubric *before* committing to the investment, not after.

---

## Engagement-point anatomy — how `x_i` is consumed moment-to-moment

`x_i` is paid one engagement at a time. Most engagements fall into one of five types, each with a distinct cost profile and a distinct engineering response. "I'm busy" is opaque; typed engagement points are actionable.

| Type | What's happening | Engineering response |
|---|---|---|
| **Ambiguity resolution** | System hit a fork it can't resolve without your values. Something lives in your head that hasn't been externalized. | Better upfront specification. Points to spec debt that will keep generating the same pull. |
| **Novel judgment** | A new category, not a known fork. | Partially reducible via scenario planning; *irreducibly expensive.* |
| **Quality gate failure** | Output came back wrong. Now you're diagnosing and redirecting. Scales with output volume. | Better gates *in the pipeline*, so less reaches you degraded. Highly engineerable. |
| **Horizon drift** | Territory has changed since you last looked. Agent's model is stale. | State externalization, regular trajectory checks, tighter inbound signal coverage. |
| **Affirmation** | System capable of proceeding but won't without your signal. Trust/authorization issue, not judgment. | Trust calibration, pre-approved envelopes. *Pure friction, no cognitive return — most wasteful category.* |

Visibility into which type each engagement is tells you exactly where to invest to reduce it. A dashboard showing engagement counts by type is more actionable than total-hours-consumed.

## Assimilation — the non-reactive cost

Separate from the five reactive engagement types above: **assimilation** is the ongoing tax of staying genuinely current with what agents are doing and why, so the operator's future judgment calls are informed. It's the sharper name for `CCC_intake`.

What makes assimilation dangerous: it's *skippable in the short term*. The agent keeps running. Output keeps coming. But the operator is now making decisions on a stale internal model. Nothing breaks immediately — the gap widens silently.

Assimilation is really **three things collapsed together**:
1. **Comprehension** — processing what was produced.
2. **Triage** — filtering what's load-bearing from what's noise (a hard, learned skill).
3. **Model updating** — integrating what matters into the operator's picture.

Agent output contains a mix: actual decisions, paths chosen, assumptions baked in, dead ends, shaping context. Most looks like noise; some is load-bearing for future judgment. The filter is itself a skill — get it wrong one way and you're drowning; get it wrong the other and you're flying blind.

## Two forms of cognitive debt

Debt that accumulates when a reducible cognitive cost is deferred. Compounds like technical debt.

### Assimilation debt
What accumulates when you defer assimilation. Comes due eventually: either (a) a bad call because you didn't have the real picture, or (b) a forced catch-up under pressure with interest. Directly analogous to technical debt.

### Horizon debt
Sharper and more dangerous. When the agent runs past the operator's horizon — when the work has moved further than the operator's understanding — the operator loses not just cleanliness but **informed leadership**.

**Unique failure mode** (no technical-debt equivalent): past a certain amount of horizon debt, the operator doesn't know what questions to ask to close the gap. "You don't know what you don't know." The relationship flips from operator-directs / agent-executes to operator-dependent on agent to explain what it's been doing.

Horizon debt also **constrains what the agent can do next** — because the operator can't give good direction until the gap is closed.

---

## Root cause — why engagement is required at all

Why `x_i > 0` is unavoidable for any Regime-3 project traces to one fact:

**The agent does not know what it does not know.**

It executes within a model of the world that is necessarily incomplete. It cannot detect when reality has drifted outside that model. It cannot signal that it's operating on stale context. It doesn't know which things it doesn't know are load-bearing. So it proceeds confidently into territory it isn't equipped for — not because it's failing, but because its bounded awareness can't perceive the boundary.

### Three architectural realities
1. **The Memento Effect** — No persistent world model. Context must be reconstructed each session. The delta between what was captured and what's actually true grows silently. The agent doesn't feel the drift; the operator does.
2. **No ontological grounding** — The agent works from text approximations of a world it has never directly perceived. When the world changes, the text doesn't automatically update.
3. **Satisficing** — The agent doesn't modulate reasoning depth by stakes. Same confidence applied to critical forks as to trivial ones.

### What the operator is actually doing during engagement

Not primarily answering questions, reviewing output, or making escalated decisions. Primarily: **patrolling the boundary of the agent's awareness** — watching for the moments when reality has outpaced the model, when a load-bearing assumption has quietly become false, when a fork has appeared that the agent doesn't even know is a fork.

Continuous not because the system is always failing, but because **you can never know when it's about to fail.**

### The horizon problem

Neither operator nor agent has complete knowledge of the future. The project advances into partially unformed territory. Engagement isn't "make sure the agent doesn't drift from the known path" — it's **continuously scan the horizon together, assemble emerging reality into a coherent picture, and update the path before the agent walks off the edge of what's been mapped**.

Distribution of knowing (asymmetric, dynamic):

| Operator holds | Agent holds |
|---|---|
| Intuitions not yet articulated | Explicit state that's been externalized |
| Weak signals from the environment | Deep context on the bounded task |
| Strategic pattern recognition | Execution capability within the known horizon |
| The felt sense that something is off | No access to that feeling |

The most autonomous a project can ever become is bounded **not by tooling or spec quality** but by how far the known horizon extends. Fire-and-forget is only truly achievable when the future is fully mapped. For any novel, strategic, or environmentally dynamic project, horizon-scanning cost is permanent and irreducible. The leverage play is efficiency at it, not elimination.
