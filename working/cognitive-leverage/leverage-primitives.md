# Leverage Primitives

Six specific mechanisms through which cognitive capacity gets amplified. Each primitive is a separable *way* of either **lowering `t_i`** (making more of the feasible region accessible) or **reshaping `R_i(x_i)`** (producing more return for the same allocation, or the same return for less allocation).

Improving on one primitive doesn't automatically improve the others. A portfolio strategy touches multiple primitives. The `L_i` for project `i` is a function of how well each primitive is operating for that project specifically.

Primary source: `sources/drive/set-2/next-after-orchestration.md` (which lists five); *parallel judgment capacity* is the sixth, load-bearing elsewhere as *reach*.

---

## 1. Delegation depth
**How many layers of decision-making can credibly be pushed down.**

*Canonical effect*: **lowers `t_i`**. Each additional layer delegated reduces the operator's per-project cognitive floor. The N-math table in `case-orchestrator-studios.md` operationalizes this primitive specifically — it shows how progressive delegation shifts the thresholds downward and makes portfolios at higher N feasible.

Tightly coupled to Driver A. Depth that wasn't available before is available now because agents are cheap AND capable at once.

## 2. Parallel judgment capacity (= reach)
**How many problems the operator's cognition can usefully be spread across simultaneously before amplification stops mattering.**

*Canonical effect*: **increases feasible `n`** (number of active projects in the portfolio). The same concept the canon calls *reach*. Primitive-level framing emphasizes the capacity *to spread* rather than the outcome of a wider portfolio.

Constrained by the threshold: adding parallel commitments only produces return if each can be kept above its `t_i`. Violations of that constraint are what make starved positions the worst economic state on the curve.

## 3. Context compression
**The operator holds the *shape* of a problem while the orchestrated system holds the *mass*.**

*Canonical effect*: **lowers `t_i`** on every project that touches the shared state. The operator stays at the level of intent, decomposition, and judgment. The machine holds state — running context, detailed work product, intermediate decisions, accumulated artifacts. Without it, the operator would carry full detail of every active workstream and `x_i` would grow until reach collapses.

Tightly tied to the universe schema (`universe-model.md`) — the schema is the infrastructure layer for context compression.

## 4. Hypothesis velocity
**How fast a structured exploration of an idea can be spun up and yield something judgeable.**

*Canonical effect*: **lowers `t_i`** for exploratory projects. "Doodle mode" is an early instance — impulse to artifact without a plan. Velocity compounds across a portfolio: 10× faster tests means 10× more hypotheses per unit of cognitive capital. Different from parallel judgment capacity — velocity operates on each individual exploration, not how many can run at once.

Driver B (configurable labor) is what makes this work — agents spin up instantly, so the cost of *starting* a hypothesis drops to near-zero. Under pre-AI economics, most hypotheses were never run because the overhead of structuring an exploration exceeded the expected information gain.

## 5. Judgment surface area
**The proportion of the operator's day spent *evaluating* outputs vs. *producing* them.**

*Canonical effect*: **raises `∂R_i/∂x_i`** across the portfolio — operator attention is spent where it has the highest marginal return (evaluation) rather than where it has the lowest (production the machine could do). Nearly definitional of operational cognitive leverage. High leverage *flips the ratio*.

The clearest metric the framework produces. An operator who went from producing 80% of their hours to judging 80% of them has raised their judgment surface area 4×. Directly observable. Maps to the role shift: "the game went from half logistics + half thinking to almost entirely thinking."

## 6. Compounding artifacts
**Outputs that become inputs. Living documents that accrue rather than reset.**

*Canonical effect*: **lowers `t_i` over time**. Examples: a `kb.md` that grows with every delegation session; a `todo.md` that carries forward; the universe schema as a persistent artifact. Yesterday's thinking becomes tomorrow's context. The antidote to the Memento Effect (`ccc-model.md`).

Leverage here is temporal. Thinking on day 1 reduces `CCC_outbound` on day 2 (the artifact pre-specifies). Over time, compounding artifacts lower `t_i` for every active project that relies on them — and lower the `t_new` for new projects starting fresh against a well-structured knowledge base.

---

## How the primitives interact

The primitives aren't independent — improving one often depends on improving another:

| If you want to improve... | It helps to also improve... |
|---|---|
| Delegation depth | Context compression (deeper delegation requires the machine to hold more state), compounding artifacts (deep delegation needs persistent context) |
| Parallel judgment capacity (reach) | Context compression (can't be wide without offloading state), judgment surface area (reach is only useful if operator time is spent judging, not producing) |
| Context compression | Compounding artifacts (compression requires persistent state), universe schema infrastructure |
| Hypothesis velocity | Delegation depth (the actual exploration has to get done), compounding artifacts (prior artifacts lower setup cost for new tests) |
| Judgment surface area | All of the above (each primitive that moves work to the machine frees operator time for judgment) |
| Compounding artifacts | Horizon maintenance discipline (compounding only happens if artifacts stay current) |

A portfolio strategy touches multiple primitives. The `L_i` for project i is a function of how well each primitive is operating for that project specifically.

## The relationship to the canon

Primitives are the *mechanisms* by which the canonical variables move:
- `t_i` can be **lowered** (more projects become feasible; more room under `Σ t_i ≤ C`)
- `R_i(x_i)` can be **reshaped** (higher return per unit of `x_i`, or flatter productive zone)

When considering architectural investment to shift `L_i`, the question is: *which primitive is most constrained on this project, and what would improve it?*

- Shallow delegation depth → invest in spec clarity and delegation-boundary identification.
- Weak context compression → invest in universe schema infrastructure.
- Low hypothesis velocity → invest in agent-instantiation tooling.
- Low judgment surface area → the operator is still producing too much. Identify production work that could be delegated (back to delegation depth).
- Non-compounding artifacts → invest in living documents and state externalization.

The primitives give the design rubric (`ccc-model.md`) specificity. "Does this reduce `CCC_reducible`?" becomes "*which primitive* does this lever, and does it reduce the binding constraint on that primitive for the projects I actually care about?"

## Open question — is this the complete list?

The six primitives named here are those that have surfaced clearly across sources. The list is presented as canonical but it's not closed. Candidates to consider or reject in future Phase 3 or Phase 4 passes:

- *Specification quality* — could be a primitive or could be a mechanism underneath delegation depth + context compression. Current treatment: a mechanism, not a primitive.
- *Trust calibration* — the affirmation-reduction axis. Could be a primitive. Current treatment: a mechanism that reduces mistyped engagement (Tier-2 arbitrage).
- *Horizon discipline* — the practice of maintaining `CCC_horizon` at sustainable levels. Could be a primitive. Current treatment: a discipline / practice rather than a primitive mechanism.

These three all have *some* of the character of primitives but are currently treated as mechanisms that improve one of the six named primitives. If a future source suggests one deserves primitive status, that's a signal to revisit the list.
