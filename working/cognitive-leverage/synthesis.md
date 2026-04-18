# Cognitive Leverage — Canonical Framework

The operating system for running a cognitive portfolio in the post-AI economy.

This file is the hub. The canon lives here; everything else is a derivation, mechanism, diagnostic, infrastructure choice, case, or positioning artifact pointing back to it.

---

## The Canon

**In one sentence:**
> Cognitive leverage is the practice of recognizing that AI has reshaped the return curves on every cognitive-allocation decision an operator makes, and optimizing the portfolio against the new shape under the constraint of fixed cognitive capacity.

**In two sentences, with the primitives:**
> An operator with fixed cognitive capacity `C` and dollar budget `B` allocates `x_i` and `d_i` per unit time to each active project, maximizing `Σ R_i(x_i)` subject to `Σ x_i ≤ C`, `Σ d_i ≤ B`, and the threshold `x_i ≥ t_i` (below which project `i` is a non-starter). Two economic shifts — delegation becoming cheap AND capable (A) and labor becoming configurable (B) — have dramatically lowered `t_i` on many projects, expanding the feasible portfolio from 2-3 projects to 10-100+, and the edge is recognizing this and rebuilding the portfolio around the new shape.

### The formal statement

```
Maximize   Σ_i R_i(x_i)              across active projects

Subject to  Σ_i x_i  ≤  C             (cognitive budget)
            Σ_i d_i  ≤  B             (dollar budget)
            x_i  ≥  t_i               (threshold: project must be viable)
```

At the interior optimum, **marginal returns are equalized** across active projects:
```
∂R_i/∂x_i  =  λ    for all active projects i
```
`λ` is the common marginal return at optimum — the opportunity cost of an incremental unit of operator attention. Projects where `∂R_i/∂x_i` exceeds `λ` should get more capacity; projects below `λ` should get less (or be cut if they can't stay above `t_i`).

### Why the canon matters *now*

Pre-AI, `t_i` on most projects was a large fraction of `C`. The portfolio capped at 2-3 projects by per-project threshold alone. Binary disqualification ("can't afford this one") was the binding filter. The optimization was trivial — it reduced to "pick one, maybe two."

Driver A collapsed `t_i` by 5-10× or more on many projects. The binding constraint shifted from per-project `t_i > available capacity` to portfolio-level `Σ t_i ≤ C`. Feasible portfolios at N=10 or N=100 opened up, and — because the return curve is relatively flat in the productive zone just above threshold — running more projects at smaller per-project allocations can produce more total return than running fewer at larger allocations. The math was always there; the *decision space* wasn't, because there was no low-end feasible region to operate in.

**The canon used to be trivially true and not decision-relevant. Now it's the actual working tool.**

---

## Primitives

### Operator resources
- **`C`** — fixed cognitive capacity per unit time. Units of directed judgment, not hours. Can't be expanded; bounded by the operator's life.
- **`B`** — dollar budget per unit time. Often non-binding under AI economics but present.

### Per-project
- **`x_i`** — cognitive allocation to project `i` per unit time.
- **`d_i`** — dollar allocation to project `i` per unit time.
- **`t_i`** — threshold. Minimum-viable cognitive allocation. Below it, the project is a non-starter (no meaningful return). Above it, the project is viable and return grows subject to diminishing returns. Driver A lowers `t_i`.
- **`R_i(x_i)`** — return curve. For projects with an autonomous component, `R_i(0) > 0` (the automated part produces return without current attention).

### The two dimensions of the operator's decision
- **Reach** — what the operator has committed to pursue (the set of active projects, i.e., the value of `n` and which candidates are in).
- **How** — for each active project, what work it takes and who does it (the composition of `x_i` + `d_i` across the project's tasks).

---

## Units of Analysis — what counts as a "project"

The canon treats "project" and "portfolio" as abstract placeholders. They need to be anchored to whatever context the operator is analyzing. The Orchestrator Studios case makes it look like "projects = products," but that's one instance. The general definition is more abstract.

### Definitions

**A project** is any distinct commitment that:
- Consumes operator cognitive capacity (`x_i > 0`) per unit time to stay productive.
- Has a threshold `t_i` below which it's a non-starter.
- Produces some return toward a goal the operator cares about.
- Can be accounted for separately from other commitments, even when it interacts with them.

That's it. Not tied to PM-style deliverables, time bounds, or formal plans. It's the generic unit of cognitive commitment.

**A portfolio** is the operator's current set of active projects — the whole collection that collectively spends `C`.

### Concrete instances

| Operator type | What "project" typically means |
|---|---|
| **Studio (Orchestrator Studios)** | Apps / products in the pipeline |
| **Single-product team** | Focus areas, features, marketing campaigns within one product |
| **CEO of small company** | Operating functions — sales, hiring, fundraising, product direction, board relations |
| **Investment partner** | Active portfolio companies / deals being worked |
| **Knowledge worker / researcher** | Active investigations, writing projects, deliverables |
| **Solo founder** | Mix of product, biz dev, customer development, recruiting currently active |
| **Executive** | Initiatives sponsored / direct reports / strategic bets personally driving |

The common thread across all rows: each is a **discrete claim on finite operator attention with its own threshold**. The framework doesn't care what the commitments are named or what kind of work they involve — it cares that they have the three properties above.

### The framework is fractal

The canon applies at any level of analysis:

- **Mandate level** — the operator's top-level portfolio. For OS this is apps; for a CEO, operating functions. Most strategic decisions live here.
- **Within-project level** — a single top-level project's internal portfolio. Within "sales," the active customer deals; within an app, the focus areas or features under development.
- **Sub-project level** — within a single deal, the individual touchpoints or negotiation threads.

Same math at every level. What varies is what `C` and `t_i` mean:
- At the mandate level, `C` is the operator's full cognitive capacity.
- At a within-project level, `C` is whatever capacity the operator has already committed to that project — the budget drops down from the level above.

**Stay at one level within a given analysis.** Mixing levels creates confusion (e.g., treating one project's sub-initiative as a peer to another project's top-level commitment).

### Choosing the right level

Most strategic work happens at the **mandate level** — where cutting or adding a top-level project is a material move, and where the two drivers' effect on feasibility is most visible. The "we could run 10 or 100, not just 2" insight is a mandate-level observation.

Lower levels are useful for *tactical* allocation within a top-level project — "given that this product is in the portfolio, how should we split attention across its focus areas?" Same math, smaller stakes, different denominator for `C`.

---

## The Framework Stack

Three layers. The confusion to avoid: teams who've solved orchestration assume fleet management is the frontier. It isn't. Cognitive leverage is the layer *above* fleet management, not next to it.

1. **Orchestration** — getting one agent to do work reliably. Table stakes now.
2. **Fleet management** — getting many agents to do work reliably in parallel. Operational. **Scales the machine.** Optimizes throughput within an inherited cognitive allocation.
3. **Cognitive leverage** — the layer above. **Scales the operator.** Treats the allocation itself as the decision variable.

**Diagnostic**: "How do I keep all these agents running?" is fleet management. "Given that I can keep them running, what's the highest-value thing to point them at, and how do I stay ahead of the judgment calls their outputs surface?" is cognitive leverage.

Deeper cuts of this distinction (supply vs. demand; human as manager vs. component; optimizing vs. culling; opportunity cost visibility; snapshot vs. portfolio-over-time) live in `positioning.md`.

---

## The Two Drivers — what actually changed

Confirmed across conv-2, conv-3, conv-6, conv-7, and the drive batch. These, and only these, are what shifted.

- **Driver A — Delegation is now cheap AND capable at once.** Agents cost orders of magnitude less than human labor *and* are genuinely good (sometimes better than the operator) at a meaningful range of work. This combination didn't exist before. Mathematically: **`t_i` drops substantially for any project whose execution is delegable.**
- **Driver B — Labor is configurable rather than pre-committed.** You start from the work and size labor to it, instantly, with no carrying cost. Decisions become continuous and reversible rather than structural bets. Mathematically: **the portfolio composition can be adjusted per-period** without hiring-cycle lag; the optimization runs continuously.

Everything else in the framework is a derivation, decomposition, mechanism, diagnostic, infrastructure choice, or application.

---

## Operating the Framework — detail files

Each of these owns one clearly-scoped zone. The hub tells you *that* they exist and what they cover; the details are in each file.

### `ccc-model.md` — what `x_i` is actually made of
Decomposition of cognitive cost: `CCC_outbound` (specification) + `CCC_intake` (digestion / *assimilation*) + `CCC_horizon` (horizon scanning) + `CCC_irreducible` (relationships, novel judgment). Engagement-point anatomy (five types: ambiguity resolution, novel judgment, quality gate failure, horizon drift, affirmation). Debt concepts (assimilation debt, horizon debt). Root cause: *"the agent doesn't know what it does not know."*

### `leverage-primitives.md` — six mechanisms that reshape the curves
Each primitive either **lowers `t_i`** or **raises / flattens `R_i(x_i)`**:
1. Delegation depth
2. Parallel judgment capacity (= reach)
3. Context compression
4. Hypothesis velocity
5. Judgment surface area
6. Compounding artifacts

### `cognitive-allocation-audit.md` — the diagnostic rubric
Five arbitrage types organized into three severity tiers:
- **Tier 1 — Constraint violations** (starved positions, hidden load)
- **Tier 2 — Structural inefficiencies** (underlevered, mistyped engagement)
- **Tier 3 — Cull decisions** (zombie positions)

Central question: *where is the market for my attention mispriced?*

### `role-shift.md` — what the operator does now
Headline: *the operator's job upgrades from doing-and-managing to maintaining-the-universe-model and directing-the-system's-posture-within-it.* What drops away from the old role (HR/onboarding/culture/org-design). What remains (decomposition, judgment, quality). What's new (system design, configuration). Skills organized by leverage primitive.

### `universe-model.md` — infrastructure for tracking state
What you need to build or externalize so `R_i` and `x_i` can actually be estimated and the optimization actually run. Two top-level services (situational awareness + optimal action). Nine-section universe schema (provisional). Tool / resource / agent hierarchy. Five CSFs. Command-and-control as product-category analogy.

### `positioning.md` — external framing
Fleet-mgmt-vs-cog-lev five cuts, execution-vs-cognitive cut, two use cases (internal memo vs. external pitch), clone thought experiment, gold rush framing, 2026/2027 positioning line, rhetorical principles. The canon stays here; rhetoric lives there.

### `case-orchestrator-studios.md` — anchor case
Adam + Cliff, fixed `C`, ~$1k/month `B`. Pre-AI counterfactual (N=1 forced). Actual N=1→N=2 move as the first unspoken cognitive-leverage decision. Numerical anchor table (N=1 through N=5000). Illustrates the old-world-vs-new-world picture concretely.

### `case-ceo-baseline.md` — second worked case
Pre-agent CEO operating well. Seven ongoing operating functions mapped onto `CCC` components. Stress-tests the universe schema against a realistic operator. Defines the pre-agent optimal against which agent-augmented systems get compared.

---

## Terminology

Canonical vocabulary. Terms the framework actively uses; retired terms removed.

**Primitives**
- **Operator** — the human whose cognitive capacity is the binding constraint.
- **`C`** — total cognitive capacity per unit time. Fixed. *Footnote*: has texture (deep focus / oversight / relational aren't fungible) — refinement on the scalar canonical form, not canon-level.
- **`B`** — dollar budget per unit time.
- **`t_i`** — threshold: minimum-viable cognitive allocation for project `i`. Below it, project is a non-starter.
- **`R_i(x_i)`** — return curve of project `i` as a function of cognitive allocation.
- **Reach** / **How** — the two dimensions of the operator's decision.
- **CCC** — Cognitive Carrying Cost. The sum of operator cognitive cost to sustain project `i` per unit time (decomposes into outbound / intake / horizon / irreducible). Historical name for what the formal canon now calls `x_i`.
- **L** — leverage parameter. 0 = pure reverse annuity; 1 = pure fire-and-forget. Architecturally shiftable.
- **`λ`** — common marginal return at optimum. Opportunity cost of an incremental unit of operator attention.

**The shift**
- **Driver A** — delegation cheap AND capable at once.
- **Driver B** — labor configurable rather than pre-committed.
- **Cognitive-for-dollars exchange rate** — collapsed; used to be that reducing operator attention required paying humans.
- **Cognitive leverage** — the practice of operating in the regime where `Σ t_i ≤ C` is the binding constraint rather than per-project `t_i`.

**Rubrics and mechanisms**
- **Leverage primitive** — specific lever that amplifies output per cognitive unit. Six canonical. See `leverage-primitives.md`.
- **Cognitive allocation audit** — diagnostic rubric. See `cognitive-allocation-audit.md`.
- **Arbitrage (of attention)** — correctable mispricing. Five types: underlevered, zombie, starved, mistyped engagement, hidden load.
- **Deeper-vs-broader** — marginal-return decision at the portfolio edge.
- **Design rubric** — "Does this reduce `CCC_reducible` without increasing `CCC_intake` or `CCC_horizon`?" Apply before architectural investment.

**Per-project anatomy**
- **Engagement point** — unit of CCC consumption. Five types (see `ccc-model.md`).
- **Assimilation** — sharper name for `CCC_intake`. The non-reactive digestion tax.
- **Assimilation debt** — accumulates when assimilation is deferred.
- **Horizon debt** — accumulates when agent runs past operator's understanding. Unique failure mode: past a certain amount, operator doesn't know what questions to ask.
- **CCC creep** — silent inflation over time.
- **The Memento Effect** — substrate fact explaining why `CCC_horizon > 0`: no persistent world model; context reconstructed each session.

**Universe model**
- **Universe** — the operator's full environment (goals, opportunities, threats, resources, relationships, environment, agent fleet).
- **Universe schema** *(provisional)* — nine-section first-pass structure. See `universe-model.md`.
- **Universe model maintainer** — refined name for operator's irreducible role.
- **Resource** (vs. tool vs. agent) — what exists that can be read / written / consumed / related-to.
- **Gap** — schema element: derived tension between state and goals.

---

## Open Questions

- **Agent projection mechanism** — how a slice of the universe schema gets scoped and delivered to an individual agent. From `cognitive-leverage-framework.md` § X.
- **Dynamic universe** — how the schema stays current as state drifts and events occur.
- **Operator's instrument panel** — what the universe-level view looks like in practice.
- **Universe schema: commit to nine sections or keep exploratory?** The 9-section structure is a first pass. Each section (especially Ontology, Resource Registry, Agent & Fleet Registry) needs operational detail before the schema is usable by agents.
- **"Relational" resources as their own top-level slot?** Still unresolved.
- **Complete the CEO baseline → agent-augmented mapping** (`case-ceo-baseline.md`).
- **Signatures of low leverage** — three starter markers from conv-7 (operator producing rather than evaluating; context held in the human not the artifact; judgment spent on execution decisions). Extend into a usable diagnostic rubric, or drop.
- **Unify the two cognitive-leverage definitions** — strategic ("practice of using an orchestrated fleet to amplify human judgment") + operational ("ratio of output to cognitive capital") — into one sharper one-liner.
- **Derivation exercise** — verify every claim in the framework traces either to the canon, to a substrate fact (e.g., Memento Effect), or to a design choice (e.g., universe schema shape).

---

## Provenance

The framework was distilled from seven source conversations plus one memo, then extended by a Google Drive batch of ten additional artifacts. Full source log and how-sources-relate map in `sources/`.

- **Phase 1** — Source-by-source distillation, ~3,500 lines of notes organized across hub + detail files.
- **Phase 2** — Review UX (`review.html`) produced for human digestion.
- **Phase 2.5** — Drive batch integrated; optimization math revised to single-threshold form after user feedback; `positioning.md` split out; hub rewritten top-down.
- **Phase 2.5+ (this pass)** — Extraneous pre-canon content retired; files aligned to canon; evolution artifacts moved to `sources/archive/`.

Process principles: `process.md`.
