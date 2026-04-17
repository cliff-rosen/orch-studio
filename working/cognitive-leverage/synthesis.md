# Cognitive Leverage — Working Synthesis

> The next thing after orchestration and fleet management.

Living document. Raw material comes in; distilled insights, rubrics, and frameworks get lifted up here. Sections spin off into their own files once they get heavy enough. See `process.md` for how this doc is built and maintained.

**Confidence markers used throughout:**
- *(tentative)* — a claim I'm not yet sure will survive the next source. Could be renamed, reframed, or cut.
- *(in flight)* — the underlying concept is still being worked out across sources; terminology and boundaries may shift.
- Unmarked — a claim or primitive that appears stable across the sources processed so far.

---

## Core Thesis

Every operator has a fixed cognitive capacity. The entire operator's job, always, has been deciding how to use it. What AI changes is not that problem but the **option space** of viable answers to it. Fleet management optimizes execution within an inherited allocation of that capacity. **Cognitive leverage treats the allocation itself as the live decision variable.** Taking the expansion of the option space seriously — rather than inheriting an allocation from the pre-AI regime — is the edge.

## The Three-Layer Stack

1. **Orchestration** — one agent working reliably. Increasingly table stakes.
2. **Fleet management** — many agents working reliably in parallel. Operational. **Scales the machine.** It's the layer teams naturally graduate to once orchestration works, and they are right to build it; they are wrong to think it's the top of the stack.
3. **Cognitive leverage** — the layer above fleet management. **Scales the operator.** Not about whether you can run 50 agents reliably, but about what decisions you're now in a position to make that you couldn't before, and how judgment gets amplified across all of them.

**The confusion isn't between all three terms.** Orchestration is clearly its own thing. The confusion is that teams who've solved orchestration assume the next frontier is fleet management and mistake *that* for cognitive leverage. Cognitive leverage is above fleet management, not next to it.

**Diagnostic**: if your problem is "how do I keep all these agents running," that's fleet management. If your problem is "given that I can keep them running, what's the highest-value thing to point them at, and how do I stay ahead of the judgment calls their outputs surface," that's cognitive leverage.

## Key Concepts

### The two orthogonal dimensions of any operator decision
- **Reach** — what the operator has committed to pursue (the set of bets). Wider reach = more commitments.
- **How** — for each commitment, what work it requires and who does that work.

These are independent. You can have narrow reach executed many ways, or wide reach executed tightly. Operator cognitive capacity is spent across both.

### Four-factor model of any production decision
Descriptive infrastructure (not itself novel, but required to talk about the shift):
- **Inputs**: operator cognitive allocation, dollar cost
- **Outputs**: units of functionality, degree of quality

### Three features of every delegation decision
Every delegation option — junior hire, offshore team, consultant, agent — is described by:
1. How much cognitive load does it save the operator?
2. How much does it cost in dollars?
3. How does the delegated output compare to what the operator would have produced (quality, functionality)?

### Reinvestment is reallocation, not addition
Every delegation that frees cognitive capacity is a reallocation, not an addition. You give up some quality on the delegated task; the question is whether the gain at the reinvestment destination exceeds the loss at the delegation source. There is no "free quality" lying around.

### CCC — Cognitive Carrying Cost (per-project)
The minimum ongoing investment of operator attention, judgment, and leadership required to keep a given delegation productive. The "reverse annuity" framing: instead of drawing down a principal, you're making ongoing deposits of cognitive capital to keep each project alive.

Below CCC the project does not run slower — it **degrades**. Assumptions drift, output quality erodes, state becomes unreliable. **Paying below the floor is worse than not paying at all** because you're consuming C without return while the asset deteriorates.

### The two pipes (outbound vs. inbound)
Every delegation relationship has two information flows with asymmetric properties:
- **Outbound pipe (operator → agent)**: specification, direction, quality gates. *Can be engineered thin.* Efficiency gain with no downside.
- **Inbound pipe (agent → operator)**: work product, discoveries, evidence, state changes. *Cannot be thinned without information loss,* because that information feeds the operator's horizon model and shapes the next outbound. Thinning the inbound pipe compounds — it degrades your ability to specify the next outbound correctly.

**Intake is the binding constraint on delegation velocity**, not specification. An agent running fast is throttled by how fast the operator can digest its output.

### L — Leverage parameter
Where a project sits on the spectrum from pure reverse annuity (L=0, every unit of return requires ongoing C) to pure fire-and-forget (L=1, one-time C invested, return is perpetual). **L is not fixed**; architectural investment (better tooling, tighter specs, autonomous pipelines) moves L toward 1. Shifting L upward is among the highest-return uses of discretionary attention.

## Rubrics & Frameworks

### The two drivers — what's actually new *(tentative — conv-1 ended with the user noting the compressed list had dropped substance; re-derivation unfinished)*
These, and only these, are the things that changed. Everything else in the argument derives from them.

- **Driver A — Delegation is now cheap AND capable at once.** Agents cost orders of magnitude less than human labor *and* are genuinely good (sometimes better than the operator) at a meaningful range of work. This combination didn't exist before: prior delegates were expensive, or low-quality, or both.
- **Driver B — Labor is configurable rather than pre-committed.** You start from the work and size labor to it, instantly, with no carrying cost. Decisions become continuous and reversible rather than structural bets.

**Both drivers affect both dimensions** (reach and how). Together they make allocations economically viable that weren't viable before.

### The pre-AI baseline, stated precisely
The only way to reduce operator cognitive allocation was to transfer cognitive work onto another human, and humans cost dollars. So cognitive offload always had a non-trivial dollar price tag. Not that the two costs were rigidly coupled — you couldn't meaningfully buy cognitive offload without paying dollars. Agents break this because they absorb real cognitive work at a cost orders of magnitude below any human equivalent. The **cognitive-for-dollars exchange rate collapsed** for a wide range of cognitive work, leaving cognitive capacity as the sole binding constraint.

### The three-region comparative-advantage sort (Ricardian)
For a given commitment, sort all units of work by comparative advantage between operator and agent:

- **Region 1** — agent has the advantage. Delegating *improves* quality.
- **Region 2** — wash. Delegating doesn't change quality. Still delegate (frees cognitive capacity at no quality cost).
- **Region 3** — operator has the advantage. Delegating *costs* quality, and costs more the deeper you go (you're progressively handing off work where your advantage is largest).

Regions 1 and 2 are the "obvious" or "free/cheap" offloads. Region 3 is where the interesting decisions live. The three regions are not novel (they're Ricardo applied to the operator/agent pair); **what's novel is that Regions 1 and 2 are wider than they've ever been** because of Driver A.

### Rigorous Region-3 analysis (two axes per task)
For each category of work currently in Region 3, estimate:
1. **Cognitive cost consumed** — how much of the operator's per-commitment cognitive allocation this category currently takes.
2. **Quality delta if delegated** — how much quality would be lost if delegated to an agent at current capability.

**High-value delegation candidates**: high cognitive cost, small quality delta. **Hold longest**: low cognitive cost, dramatic quality delta. Both numbers move as agent capability improves, so the ranking is not locked in — it's revisited.

### Two reinvestment directions for freed cognitive capacity *(tentative — names may change)*
- **Direction 1 — Reallocate within existing commitments (depth).** Apply freed capacity to other tasks within the same commitment, where operator judgment produces a larger quality gain than was given up. The classic MVP features-vs-polish tradeoff sits here. Operators already do this well. *Not what the piece is trying to change.*
- **Direction 2 — Reallocate into reach (breadth).** Use freed capacity to extend range — more verticals, more parallel explorations, more products. Tradeoff is across commitments rather than within one.

Under pre-AI economics, Direction 2 wasn't really available — reach was economically unreachable, and any freed capacity defaulted to Direction 1 by necessity, not wisdom. Under AI economics, Direction 2 becomes a live option; the real decision is how to split between the two.

### Quality as economic threshold, not absolute
Quality should never be "as good as possible." It should be **as good as makes sense economically** — good enough to clear the threshold the market, category, and specific bet require, and no better. Under pre-AI economics, over-polishing was the default because surplus capacity had nowhere else to go; this wasn't wisdom, it was the only option. The principle is old; its practical relevance is new, because surplus capacity now has a real alternative destination (Direction 2).

### Quality threshold as a founding gate (not a sliding variable)
In the Orchestrator Studios case, there is a non-negotiable quality threshold — a floor below which they wouldn't ship an app at all. The threshold is what actually drives the N decision in both regimes:
- **Pre-AI**: cognitive cost of clearing the threshold on one product consumed all available capacity → N=1 (forced).
- **Post-AI**: cognitive cost of clearing the threshold dropped → same capacity covers two products above threshold → N=2.

The threshold itself is a constantly evolving judgment, revisited regularly (MVP-style tradeoffs are one form of this).

### One-bet vs. many-bets stance (flagged, not formalized)
How an operator thinks about the quality threshold shifts when holding many bets vs. one. With one bet, threshold is a hard floor (nothing to fall back on). With many bets, threshold softens probabilistically (portfolio buffers per-bet variance). Real, but attitudinal, not derivable from the drivers.

### The planning artifacts
Not a target N. Two artifacts:
1. **A delegation map** — rigorous Question 1 output. Each category of work estimated on the two axes, ranked. Updated as agent capability moves.
2. **A conscious stance on Direction 1 vs. Direction 2** — rigorous Question 2 output. Not a fixed rule; a commitment that Direction 2 is on the table whenever capacity frees up, rather than defaulting to Direction 1 by habit.

**N is an output of these, not an input to them.**

### Opportunism vs. rigor
The mode-shift argument. Studio has captured the exchange-rate shift opportunistically (obvious offloads). But the option space is large, fast-moving, and — because of Driver B — continuously adjustable. **Rigorous analysis isn't just higher-ROI; it's a mode of operation newly feasible because of B** (you can re-run the allocation decision often, since adjusting doesn't cost a hiring cycle).

## The CCC Model (project-level cost structure)

The reach/how framing is portfolio-level. The CCC model zooms into what actually happens *inside* a single delegation relationship — the cost structure that determines how many commitments the portfolio can sustain.

### Three return regimes
Every project generates return through one or more of:

- **Regime 1 — One-time effort → one-time return.** You invest C once, the project completes, return is realized. No ongoing draw.
- **Regime 2 — One-time effort → ongoing return.** Fire-and-forget annuity. You invest to build something autonomous (a tool, a pipeline, a system) that continues producing without further draw on C. *The most attractive position in the portfolio.* Leverage is unbounded in principle.
- **Regime 3 — Ongoing effort → ongoing return.** Reverse annuity. Return requires continuous injection of C. Most real projects live here, and this is where the CCC framework does its primary work.

### CCC decomposition (four components)
For a Regime 3 project:

```
CCC_i = CCC_outbound + CCC_intake + CCC_horizon + CCC_irreducible
```

- **`CCC_outbound`** — Specification cost. Directing the agent, scoping work, setting quality gates, articulating the next step. **Engineerable toward efficiency** via better upfront specs, bounded degrees of freedom, encoded expertise in tooling.
- **`CCC_intake`** — Digestion cost. Absorption + pattern recognition + model updating + next-step formation. *Largely irreducible.* Scales with **epistemic density** (how much the output changes what you know), not with output volume. **The binding constraint on delegation velocity.**
- **`CCC_horizon`** — Horizon scanning cost. Sensing what's coming, folding new reality back into the shared model before the gap becomes a cliff. Varies with environmental volatility and how novel the territory is. **Cannot be delegated** — requires weak signals only the operator can perceive and cross-project pattern recognition.
- **`CCC_irreducible`** — Structural human cost. Relationships/trust, novel judgment, motivational leadership. No tooling reduces this.

Shorthand split: `CCC_reducible` (outbound + some intake) vs. `CCC_irreducible` (horizon + relationships + novelty). The real leverage play is collapsing the reducible portion toward zero, then paying only the irreducible human tax.

### Return curve (kinks, not linear)
Within Regime 3, return `R(x)` against investment `x`:

| Investment level | Return |
|---|---|
| `x < CCC_i` | Negative — project **degrades** |
| `x = CCC_i` | Minimal — lights on only |
| `CCC_i < x < T_i` | Grows slowly |
| `x ≥ T_i` (activation threshold) | Return jumps — productive zone |

**Implication: underfunding above the floor is almost as bad as falling below it.** You pay the carrying cost without reaching the productive zone.

### Portfolio decision rules
- **Floor constraint**: `Σ CCC_i ≤ C` — you can only carry as many projects as the sum of their floors allows.
- **Add a project only when** `C − Σ CCC_i ≥ CCC_new + buffer`.
- **Drop a project when** `CCC_i > α_i × V_i` — you're paying more than it returns.
- **Invest to shift L** when `CCC_outbound` or `CCC_intake` can be structurally reduced. Among the highest-return uses of discretionary attention.
- **Watch for CCC creep** — projects that start cheap but inflate their carrying cost as scope expands, environmental complexity grows, or AI output quality erodes without fresh steering.

## Why Engagement Is Required (Root Cause)

Understanding *why* CCC exists at all — why any delegation requires ongoing engagement — is essential. The whole edifice traces to one fact.

### The root fact
**The agent does not know what it does not know.**

It executes within a model of the world that is necessarily incomplete. It cannot detect when reality has drifted outside that model. It cannot signal that it's operating on stale or insufficient context. It doesn't know which things it doesn't know are load-bearing. So it proceeds confidently into territory it isn't equipped for — not because it's failing, but because its bounded awareness cannot perceive the boundary.

### Three architectural realities
1. **The Memento Effect** — No persistent world model. Context must be reconstructed each session. The delta between what was captured and what's actually true grows silently. The agent doesn't feel the drift; the operator does.
2. **No ontological grounding** — The agent has no persistent structured representation of reality. It works from text approximations of a world it has never directly perceived. When the world changes, the text doesn't automatically update.
3. **Satisficing** — The agent doesn't modulate reasoning depth by stakes. It can't recognize moments that require operator judgment and slow down to flag them. Same confidence applied to critical forks as to trivial ones.

### What the operator is actually doing during engagement
Not primarily:
- Answering questions the system asks
- Reviewing output quality
- Making decisions it escalates

Primarily:
- **Patrolling the boundary of the agent's awareness** — watching for the moments when reality has outpaced the model, when a load-bearing assumption has quietly become false, when a fork has appeared that the agent doesn't even know is a fork.

That function is continuous not because the system is always failing, but because **you can never know when it's about to fail.**

### The horizon problem
Neither operator nor agent has complete knowledge of the future. The project advances into partially unformed territory. Engagement isn't "make sure the agent doesn't drift from the known path" — it's **continuously scan the horizon together, assemble emerging reality into a coherent picture, and update the path before the agent walks off the edge of what's been mapped**.

Distribution of knowing (asymmetric, dynamic):

| Operator holds | Agent holds |
|---|---|
| Intuitions not yet articulated | Explicit state that's been externalized |
| Weak signals from the environment | Deep context on the bounded task |
| Strategic pattern recognition | Execution capability within the known horizon |
| The felt sense that something is off | No access to that feeling |

The most autonomous a project can ever become is bounded **not by tooling or specification quality** but by how far the known horizon extends. Fire-and-forget is only truly achievable when the future is fully mapped. For any genuinely novel, strategic, or environmentally dynamic project, horizon-scanning cost is permanent and irreducible. The leverage play is to become more *efficient* at it, not to eliminate it.

## The Orchestrator Studios Case (anchor example)

**Founding commitment**: Adam and Cliff started with two fixed inputs — bounded cognitive allocation (different for each, known, not expandable) and a dollar budget of ~$1,000/month. Purpose: apply core competency to capture value from a corner of the market they understood.

**Pre-AI math (counterfactual)**: N=1 wouldn't have been a conservative choice; at $1k/month at human labor rates, nothing meaningfully absorbs cognitive work, so N=1 was the only feasible answer.

**What actually happened**: Same $1k spent on agents buys a dramatically different amount of cognitive offload. Inputs didn't change; the exchange rate did. Cognitive allocation per product dropped ~50%, supporting N=2. The move happened organically, not analytically. Only obvious (Region 1 & 2) offloads were used.

**Where the studio sits now**: at the Region 2/3 boundary, running two products (Knowledge Horizon and TableThat), continuing opportunistically without rigorous analysis.

### Numerical anchor (from the original teaser memo)
Concrete table from the pre-refinement memo. Keeps numbers in one place even though the *argument* built on top of these numbers was later restructured.

Baseline: one product, all operator effort, 50% success probability. Key observation: as N grows 5,000×, success rate per product falls only ~17×. If success fell as 1/N the last column would be flat; the fact that it climbs is the source of leverage.

| Agent share | Human effort per product | Human leverage | Products (N) | Success rate per product | Total expected successes |
|---|---|---|---|---|---|
| ~50% (today) | 100% on 1 product | 1× | 1 | 0.50 | 0.50 |
| 75% | 50% per product | 2× | 2 | 0.45 | 0.90 |
| 90% | 20% per product | 5× | 5 | 0.38 | 1.90 |
| 95% | 10% per product | 10× | 10 | 0.30 | 3.00 |
| 99% | 2% per product | 50× | 50 | 0.18 | 9.00 |
| 99.9% | 0.2% per product | 500× | 500 | 0.08 | 40.00 |
| 99.99% | 0.02% per product | 5,000× | 5,000 | 0.03 | 150.00 |
| → 100% | → 0 | → ∞ | → ∞ | → small but > 0 | → ∞ |

Caveats (both surfaced later in conv-1):
- The *shape* of the per-product success-rate curve was originally presented as vague "diminishing returns" (S-curve). In the refined treatment, the shape is derived from the three-region comparative-advantage sort (Region 1 improves, Region 2 flat, Region 3 steepens as you push deeper). The numbers in this table implicitly assume something like that shape.
- The column labeled "Success rate per product" is really a composite of two things (functionality and quality) that the refined treatment tries to keep separate. Treat the numbers as illustrative of a dynamic, not as a model to calibrate against.

## How the Sources Relate

Chronologically: **conv-2 (Apr 14)** → **memo-original-teaser (Apr ~15-16)** → **conv-1 (Apr 17)**. But conceptually they operate at different levels:

- **conv-2** builds the *per-project cost structure* (CCC decomposition, return regimes, root-cause analysis of why engagement is irreducible). It's inward-facing — what's happening inside a single delegation relationship. It also delivers the *market-opportunity* framing ("2026 = orchestration, 2027 = cognitive leverage") and coins the term.
- **memo-original-teaser** and **conv-1** work the *portfolio / strategic* level — how many commitments to hold, where freed capacity should go, how to think about the allocation deliberately. Outward-facing — what's happening across the portfolio.

These are **complementary layers of the same stack**, not competing frameworks:
- Conv-1's "reach vs. how" is the portfolio decision *type*. Conv-2's CCC is the per-commitment cost that makes that decision tractable.
- Conv-1's two drivers (A: cheap+capable, B: configurable labor) are the *causes*. Conv-2's collapsed transaction cost + ongoing-economics collapse are the same shifts stated in different words.
- Conv-1's delegation map (task-level, current capabilities) and conv-2's architectural investment to shift L (structural, long-horizon) are two time-horizons of the same work.

## Evolution Notes

How specific framings from the original memo (`sources/memo-original-teaser.md`) were refined in `sources/conv-1.md`:

| Original framing | Refined framing |
|---|---|
| "Bottleneck is cognition, not orchestration" | Cognitive capacity was always the binding constraint; what's new is that the *cognitive-for-dollars exchange rate collapsed* for a wide range of work |
| "Most teams will experience fleet mgmt and never notice cog lev" | The confusion isn't whether cog lev exists — it's that teams mistake fleet mgmt for the top of the stack |
| "The delegation decision *is* the cognitive-leverage decision" | Delegation (Question 1) frees capacity; **cognitive leverage is the Question 2 decision of where that capacity gets redirected** — especially into reach |
| "Plan: a delegation roadmap" | Plan: **two** artifacts — (a) delegation map (Question 1) and (b) conscious stance on Direction 1 vs. 2 reinvestment (Question 2). N is an output of both. |
| Implicit S-curve shape | Three-region Ricardian sort (agent-better / wash / operator-better) that derives the shape |
| "Quality drops slower than N grows, so total climbs" | True, but reframed: reinvestment is reallocation, not addition; every step trades quality somewhere for a larger gain elsewhere |
| "Success-rate cliff" (where products stop functioning) | Parked as a modeling assumption — the curve has no derivable interior maximum; cliff is an external constraint |
| Fleet mgmt "reasons about how thin we can stretch ourselves" | Fleet mgmt optimizes the *how* within fixed reach; cog lev treats reach as the decision variable |
| Novelty claim implicit throughout | Explicitly narrowed: the two drivers (A: cheap *and* capable; B: configurable labor). Delegation, comparative advantage, and quality/volume tradeoffs are all old. |
| Studio's current state: "running two products as fleet mgmt shop" | Refined: N=1→N=2 was itself a small, unspoken cognitive-leverage move (exchange-rate shift applied to fixed $1k/mo + fixed cog budget); studio has just ridden it opportunistically since |

## Framing / Rhetorical Principles

- **Don't overclaim novelty.** The delegation tradeoff isn't new. Comparative advantage isn't new (Ricardo). Quality-for-volume tradeoffs aren't new (pricing, manufacturing, offshoring). What's new is *specifically* the two drivers.
- **Ground abstractions in the founding commitment**, not economic theory. Two fixed inputs and a clear purpose is more concrete and persuasive than a four-factor model abstraction.
- **"Then and now" walkthrough structure** for the case: how the math worked pre-AI, what AI changed, what actually happened, what remains.
- **Pieces for partners should open conversations**, not close them. Quiet, not punchy, closes.
- **Credit the small move before the big move.** The N=1→N=2 step was an unspoken cognitive-leverage move; use that as the bridge into doing the same thing deliberately.

## Terminology Decisions

- **Reach** (preferred) vs. scope/breadth/parallelization — emphasizes territory and range.
- **How** — the other orthogonal dimension.
- **Cognitive leverage** — *(in flight — two compatible definitions, not yet unified):*
  - *Strategic* (conv-1): the practice of using an orchestrated fleet to amplify human judgment itself, so that the operator's thinking — not the machine's throughput — becomes what scales.
  - *Operational* (conv-2): the ratio of output generated to cognitive capital invested.
- **Operator** — the human whose cognitive capacity is the binding constraint.
- **N** — count of commitments at the top-level reach decision.
- **C** — total cognitive capacity. Bounded, fixed per unit time. Units of directed judgment, not hours.
- **CCC** — Cognitive Carrying Cost. Per-project minimum draw on C required to keep the project productive.
- **L** — leverage parameter. 0 = pure reverse annuity; 1 = pure fire-and-forget. Architecturally shiftable.
- **Outbound / inbound pipe** — the asymmetric information flows between operator and agent.
- **Horizon scanning** — the irreducible joint epistemic work of sensing what's not yet in the model.
- **CCC creep** — silent inflation of carrying cost over time as scope expands or output quality erodes without fresh steering.
- **The Memento Effect** — shorthand for "no persistent world model; context reconstructed each session" (named elsewhere in Cliff's work, referenced in conv-2).
- **2026 = orchestration, 2027 = cognitive leverage** — positioning line from conv-2 for naming the category shift.

## Parked Questions

Flagged as real but deliberately not formalized in the current piece:
- **When does "lower quality of the same output" become "a different output"?** Countless parameters define a work product; quality is one. A real modeling question, set aside.
- **Attempted tree models (subdividing bets vs. decomposing work)** — reduced to the cleaner two-dimension framing (reach vs. how); tree scaffolding dropped as overfitting.

### Previously parked, now addressed by conv-2's CCC model
- ~~**The quality floor where products stop functioning**~~ — conv-2 gives this a model. Below CCC, a project doesn't run slower, it *degrades*. The "floor" is the per-project CCC threshold.
- ~~**One-bet vs. many-bets shift** (attitudinal)~~ — conv-2 gives this a mechanical explanation: `Σ CCC_i ≤ C` means many bets is literally paying more simultaneous floors. Portfolio risk isn't just psychological buffering; it's whether you can sustain every CCC_i concurrently without any falling below floor and silently degrading.

## Open Questions / Loose Ends

- The conv-1 conversation ended mid-inventory with the user noting the previous compressed list had missed things (the three features of delegation were added back). An honest re-derivation exercise is warranted: **can every claim made in the piece be derived from (a) fixed cognitive capacity, (b) the two dimensions, (c) the four factors, (d) the three delegation features, (e) the pre-AI baseline, (f) the two drivers, (g) the three regions, (h) quality-as-threshold, and (i) the CCC decomposition?** Anything that can't derive is either a missing primitive or an unjustified claim.
- Whether the delegation map and the Direction 1/Direction 2 stance are the *complete* set of planning artifacts, or whether there are others (conv-2 implies at least two more: portfolio decision rules based on CCC, and architectural-investment-to-shift-L roadmap).
- Whether the **strategic** and **operational** definitions of cognitive leverage can be unified into one sharper one-liner that survives outside the memo.
- **How the two delegation analyses interact**: conv-1's delegation map (sort Region-3 tasks by cognitive-savings-per-quality-hit using *current agent capabilities*) vs. conv-2's architectural investment (structurally reduce `CCC_reducible` to shift L toward 1 over time). These are separate planning artifacts. Unclear whether they should be merged or kept distinct — probably distinct, since they operate on different timescales.
- **The "product opportunity" thread from conv-2.** Cliff ended conv-2 wondering whether there's a business to build around naming and tooling this space (awareness layer vs. operational layer, methodology vs. software, standalone vs. acquisition target). This is live strategic territory adjacent to the synthesis itself. Worth tracking separately once it gets heavy enough.

---

## Source Log

| Date | Source | Type | Notes |
|------|--------|------|-------|
| 2026-04-14 | `sources/conv-2.md` | Claude conversation transcript (~760 lines) | Earlier, deeper line of thinking. Builds the CCC model (three return regimes, four-component decomposition, return curve with kinks), the root-cause analysis of why engagement is required ("agent doesn't know what it doesn't know"), the horizon problem, the intake/two-pipes asymmetry. Ends with the coining of the term: *2026 = orchestration, 2027 = cognitive leverage*, and a market-opportunity framing. Operates at the per-project cost-structure level — complementary to conv-1's portfolio level. |
| 2026-04-17 | `sources/memo-original-teaser.md` | Original memo to Adam | The teaser that prompted conv-1. Contains the N=1 → N=5000 numerical table (preserved above as the numerical anchor) and the first framing of fleet-mgmt-vs-cog-lev. Most of its conceptual scaffolding was subsequently refined — see Evolution Notes. |
| 2026-04-17 | `sources/conv-1.md` | Claude conversation transcript (~2000 lines) | Multi-pass restructure of the teaser into a case-study form. Key insights emerged iteratively as the user pushed back on hand-waving. Major conceptual moves: four-factor model → two drivers → two dimensions (reach/how) → three-region sort → Direction 1/2 reinvestment. Ended on an inventory exercise. |
