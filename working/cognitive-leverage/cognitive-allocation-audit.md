# The Cognitive Allocation Audit

Diagnostic rubric. A structured instrument for surfacing where the operator's attention is mispriced — producing *actionable arbitrage signals*, not a static snapshot.

Primary source: `sources/conv-6.md`.

---

## The central question

**Where is the market for my attention mispriced?**

The audit operates on the universe (see `universe-model.md`), examines every active claim on the operator's cognitive capital, and produces a list of correctable mismatches between cost and return.

## Distinction from a productivity review

A productivity review asks "am I getting enough done?" The audit asks something sharper: **given a fixed budget of cognitive capital, is it flowing to the highest-return destinations — and where isn't it?** A productivity review tolerates bloat as long as throughput is high. The audit does not.

## What the audit maps

Every active claim on cognitive capital, including:
- Agents currently running
- Relationships requiring ongoing investment
- Decisions in progress
- Projects mentally carried even if nothing is actively happening
- **Invisible holdings** — things consuming background cognitive load that never show up on any list

The surface has to be the full portfolio, not just what appears on a formal task list. Invisible holdings are often where the audit finds the most.

## Dimensions measured per item

For each claim on cognitive capital:

- **Current cognitive cost** `x_i` — broken down by engagement type (ambiguity resolution, novel judgment, quality gate failure, horizon drift, affirmation; plus ongoing assimilation). See `ccc-model.md` § Engagement-point anatomy.
- **Threshold `t_i`** — minimum-viable allocation. Is `x_i ≥ t_i`?
- **Return `R_i(x_i)`** — what the project is producing, and at what horizon.
- **Marginal return `∂R_i/∂x_i`** at the current allocation — how it compares to the common `λ` across the portfolio.
- **Leverage parameter `L`** — how autonomous the return stream is (0 = pure reverse annuity, 1 = fire-and-forget).
- **Outstanding horizon debt** — how far the agent's trajectory has run past the operator's understanding.
- **Outstanding assimilation debt** — how much output has accumulated without being integrated into the operator's model.

## The five arbitrage types — three tiers of severity

Arbitrage types aren't parallel. They map to the canonical optimization (`synthesis.md` § The Canon) in three tiers, ordered by how directly they distort the math.

### Tier 1 — Constraint violations (fix first)

These directly violate the optimization's constraints. The portfolio math can't be solved correctly until these are resolved.

#### 1. Starved positions
**Projects sitting below their threshold `t_i`.** The minimum-viable allocation isn't being paid. The project is either decaying or producing no meaningful output — a non-starter.

**Why this is Tier 1**: directly violates the threshold constraint. A below-threshold project returns effectively zero while consuming capacity that could activate others.

**Arbitrage**: either push allocation above `t_i` (if the project's marginal return at `t_i` justifies keeping it) or cull entirely (set `x_i = 0` and reallocate to projects with higher marginal return).

#### 2. Hidden load
**Background carrying cost on items not formally in the portfolio** — relationships you're worried about, decisions you're sitting with, projects mentally carried without being tracked. Consumes C without appearing on any scorecard.

**Why this is Tier 1**: violates the accounting implicit in the budget constraint. Until invisible holdings are surfaced, `Σ x_i` understates actual consumption; every other rule applies to false numbers.

**Arbitrage**: make visible. Once hidden load competes on the same scorecard, it gets triaged like anything else — often dropped, sometimes surfaced as a real active project, occasionally externalized so someone else carries it.

### Tier 2 — Structural inefficiencies (reduce over time)

These don't violate constraints; they make each project cost more than it needs to. Correcting them shifts `L` toward 1 — reducing `x_i` needed for the same return.

#### 3. Underlevered positions
**High-return projects still requiring excessive cognitive injection because no architectural investment has been made.** You're paying ongoing `CCC_i` that architectural work could collapse.

**Arbitrage**: invest now in tooling, specs, or pipeline improvements that structurally reduce `CCC_outbound` or `CCC_intake`. Apply the design rubric (`ccc-model.md` § The design rubric) to any such investment — make sure it doesn't shift cost to `CCC_horizon` or increase `CCC_intake` by accident.

#### 4. Mistyped engagement
**Affirmation masquerading as judgment.** Real cognitive capital spent on what is actually a trust-calibration problem or authorization friction — one of the five engagement point types that's the most wasteful (`ccc-model.md` § Engagement-point anatomy).

**Arbitrage**: recognize the engagement type, engineer it out. Trust calibration, pre-approved decision envelopes, clearer authorization boundaries.

### Tier 3 — Cull decisions (discrete)

These aren't inefficiencies to reduce; they're projects to stop.

#### 5. Zombie positions
**Projects where `R_i(x_i)` doesn't justify `x_i` anymore** — persisting only because culling requires an active decision. Returns don't cover the ongoing cost of the project's share of cognitive capacity.

**Arbitrage**: set `x_i = 0`. Free the capacity for higher-return alternatives. The audit makes these visible; the rest is will — culling is an executive act, not an analytical one.

## Why the tiers matter

The ordering is not decorative. Tier-1 fixes are **maximum return per unit cognitive capacity** because they resolve constraint violations that distort the whole portfolio. Tier-2 fixes compound over time but each individual fix is smaller. Tier-3 decisions are point-in-time portfolio edits with one-shot returns.

An audit that finds only Tier-2 and Tier-3 items is diagnosing a portfolio that's broadly working. An audit that finds Tier-1 items is diagnosing a portfolio that's *mathematically misallocated* — the optimization's constraints aren't being respected.

## How the audit is used

This isn't a one-time exercise. It's a recurring diagnostic — run often enough to catch CCC creep and zombie accumulation before they compound. Each run produces a prioritized arbitrage list, executed by adjusting the portfolio accordingly.

The audit is how the operator moves from opportunistic allocation ("I'm running projects; it's probably fine") to rigorous allocation (actually checking that no constraint is violated and marginal returns are equalized). Running the canonical optimization by hand, essentially.
