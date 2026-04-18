# Update Plan — Optimization Math + Drive Batch Integration

Phase 2.5 update. A mid-review integration prompted by (a) the user flagging that the synthesis lacks an explicit statement of what cognitive leverage is actually optimizing for, and (b) the drive batch surfacing additional primitives that should fold in alongside.

---

## What this fixes

The current synthesis describes cognitive bankruptcy in experiential terms — "the fleet humming along while you're overextended across intake and judgment." That's impressionistic. It could describe an operator whose portfolio is actually optimal but feels busy, or an operator whose portfolio is genuinely misallocated. The framework can't tell you which.

**All the pieces for the actual optimization exist** in the synthesis (CCC, T, R(x), R∞, L, C) — they just haven't been stitched into a stated objective and decision rules. The drive batch's `new-economics-of-delegation.md` already has a clean formal statement that we dropped; it belongs in the hub.

Symptoms of the gap:
- No mathematical answer to "should we go deeper on existing commitments or broader by adding new ones?" The Direction 1 / Direction 2 framing states the choice but not how to decide.
- The five arbitrage types in the audit are presented as parallel, but some are *mathematically primary* (starved positions violate the threshold rule) and some are *secondary* (hidden load expands the portfolio scope). The hierarchy isn't visible.
- "Overextended" has no falsifiable test.
- When a new source adds a primitive (context compression, hypothesis velocity, etc.), there's no canonical place to slot it — we get a growing list rather than a principled taxonomy.

## The core addition — the optimization, stated explicitly

Draft content to fold into `ccc-model.md` and surfaced in the hub's rubrics section. Sanity-check this math before I commit it:

---

### What cognitive leverage optimizes

**Decision variables:**
- `n` — number of active projects (itself a variable)
- `{x_i}` for `i = 1..n` — cognitive allocation to each active project
- Implicit: which projects from the candidate set are active; architectural investment that shifts `L_i` over time

**Objective:**

```
Maximize  Σ_i [ R∞_i + R_i(x_i) ]
```

Total return across the portfolio, summing both the autonomous component (`R∞_i`, from whatever part of project i has been architected to Regime 2 — fire-and-forget) and the ongoing-effort component (`R_i(x_i)`, the Regime 3 return curve at current allocation).

**Constraints:**

```
Σ_i x_i  ≤  C                          (budget constraint)
x_i  ≥  CCC_i   for all active i       (floor constraint — no degraded projects)
x_i  ≥  T_i   OR   x_i = 0              (threshold rule — no starved positions)
```

Three constraints, doing different work:

1. **Budget constraint.** Total cognitive allocation cannot exceed what the operator has. Hard ceiling.
2. **Floor constraint.** Any project in the portfolio must be funded above its carrying cost, or it's not really in the portfolio — it's decaying. Falling below CCC doesn't produce less return; it produces *negative* return (assumptions drift, output quality erodes, state becomes unreliable).
3. **Threshold rule.** A project funded above CCC but below its activation threshold T is the worst economic position — paying carrying cost without reaching the productive zone. The rule says: fund at or above T, or don't fund at all. Projects in the "zombie zone" between CCC and T belong culled.

**What the objective does NOT include:**
- "How busy the operator feels." Not a decision variable.
- Number of intake events per week. Not a decision variable (though it contributes to each `x_i`).
- Operator stress. Not a decision variable (though sustained violation of the budget constraint produces it).

An operator whose portfolio satisfies all three constraints is *not* overextended in any meaningful sense, even if it feels busy. An operator whose portfolio violates the threshold rule (starved projects) or carries invisible holdings (things consuming cognitive capacity without being in the portfolio accounting) *is* misallocated — regardless of how they feel.

### The deeper-vs-broader decision rule

Given the optimization, the choice between "invest more in an existing project" (Direction 1 / depth) and "open a new project" (Direction 2 / breadth) has a mathematical answer at the margin:

```
Go DEEPER on project i  when:  ∂R_i/∂x_i  at current x_i  >  marginal return of any alternative
Go BROADER              when:  best available new project's return at (T_new + buffer)
                                 >  marginal return of any existing project
```

Unpacking the mechanics:

- If every active project is near its activation threshold T (just into the productive zone), the marginal return curve `∂R_i/∂x_i` is steep — extra investment produces disproportionate gains. **Go deeper.**
- If every active project is well past T (deep in diminishing returns — "polishing"), the marginal return curve is flat. Extra cognitive capacity produces little. **Go broader** — a new project at T gives more return per unit-C than another unit on a saturated existing project.
- If opening a new project would push an existing one below T (because paying `CCC_new + T_new` requires pulling from existing x_i), compare: loss on the pulled-from project (which may fall below T and become worth zero) vs. gain from activating the new one.

**The key insight**: the optimum is *not* to pour all capacity into one project (you'd be polishing past the point of return) and *not* to open maximum projects (you'd violate the threshold rule on most of them). It's to keep every active project just above its activation threshold — in the productive zone where `∂R_i/∂x_i` is highest — and use any surplus to open new projects at their own T.

**Why this matters for the Orchestrator Studios case**: the N=1 → N=2 move wasn't "because we could afford it." Formally, it was: at N=1, x_1 = 100% human effort was well past T_1 (polishing zone); marginal return of opening a second project at T_2 exceeded the marginal cost of pulling x_1 down. The math said go broader — they just didn't write it down. The same logic extended says: at N=2, if `x_i ≈ T_i` for both, go deeper (they're productive); if both are well past T, consider N=3.

### Reframing the audit's five arbitrage types under this optimization

Not five parallel categories — three tiers of severity:

**Constraint violations (fix first):**
- **Starved positions** — violates the threshold rule directly. Maximum return per unit cognitive capacity to correct (either concentrate to push above T, or cull).
- **Hidden load** — violates the accounting implicit in the budget constraint. Until invisible holdings are surfaced, the other rules can't be applied honestly.

**Structural inefficiencies (reduce over time):**
- **Underlevered positions** — CCC_outbound or CCC_intake are higher than they need to be because architectural investment hasn't happened. Moves L toward 1, reducing future `x_i` for the same return.
- **Mistyped engagement** — CCC_affirmation is higher than it should be. Reduces `x_i` per project by engineering out friction.

**Cull decisions (discrete):**
- **Zombie positions** — projects where `R∞_i + R_i(x_i)` doesn't justify `x_i` anymore. The optimization says: set `x_i = 0`, free that capacity for higher-return alternatives.

This ordering also maps to urgency: constraint violations distort the whole optimization, structural inefficiencies waste capacity over time, cull decisions are point-in-time portfolio edits.

### "Overextended" — the falsifiable test

Under this framework, "overextended" has a concrete meaning:

- **Not overextended** if all constraints are satisfied *and* the marginal return on the next unit of cognitive capacity is well-matched across projects (no lopsided allocations). Busy is fine if the math is working.
- **Overextended** if any of: (a) the budget constraint is violated (you're drawing from reserves, which is another way of saying horizon/assimilation debt is accumulating), (b) the threshold rule is violated on one or more projects (starved), (c) invisible holdings are consuming capacity in ways the accounting doesn't see.

The remedy is prescriptive per case — not "do less" as a vague injunction, but specifically: cull starved positions, surface hidden load, re-architect to shift L on underlevered positions.

### "C has texture" — the refinement

The simple scalar form `Σ x_i ≤ C` treats cognitive capacity as homogeneous — all units of attention interchangeable. That's an idealization. In reality **C has texture**: deep focus, light oversight, and relational presence are not fungible. You can't pay an irreducible relational cost out of deep-focus capacity, and you can't pay a deep-focus cost out of oversight time.

More accurate formulation:

```
C = { C_focus, C_oversight, C_relational, ... }
Each CCC_i = { CCC_i^focus, CCC_i^oversight, CCC_i^relational, ... }
Σ_i x_i^type  ≤  C^type   for each type
```

Implication: a portfolio can satisfy total-capacity constraints but violate per-type constraints. An operator with spare oversight capacity but no remaining deep-focus time can't add a project that requires deep focus, even if the total numbers "work."

Keep the scalar form as the canonical teaching version. Add texture as a refinement noted in the synthesis, because it affects (a) which projects can actually coexist and (b) which reallocations are feasible when freed capacity is of one type and the reinvestment opportunity requires another.

---

## Also incorporating from the drive batch

Four additional integrations, smaller in scope than the optimization:

### 1. Leverage primitives — six, not two

`next-after-orchestration.md` names four candidate primitives I don't have; conv-7 named two (delegation depth, parallel judgment capacity / reach). Proposed canonical list of **six**:

- **Delegation depth** — how many layers of decision-making can be pushed down. What the N-math table operationalizes.
- **Parallel judgment capacity** (= reach) — how many problems cognition can usefully be spread across simultaneously.
- **Context compression** — operator holds the shape of a problem while the system holds the mass. Operator stays at intent/structure level; machine holds state.
- **Hypothesis velocity** — how fast a structured exploration can be spun up and yield something judgeable. Enables testing more ideas per unit of cognitive capital.
- **Judgment surface area** — proportion of operator's day spent *evaluating* outputs vs. *producing* them. High leverage flips this ratio. Nearly definitional of operational cognitive leverage.
- **Compounding artifacts** — outputs that become inputs (living kb.md, todo.md). Yesterday's thinking becomes tomorrow's context. Leverage compounds across time.

This promotes "leverage primitives" from (in flight) in the hub to a settled concept with a canonical list. Needs its own file — `leverage-primitives.md`.

### 2. The design rubric

From `cognitive-leverage-framework.md` § IX: **"Does this reduce `CCC_reducible` without increasing `CCC_intake` or `CCC_horizon`?"**

A crisp evaluation test for any tool, process, or system decision. Tools that add dashboards increase `CCC_intake`. Tools that require operator curation increase `CCC_horizon`. A good tool reduces the reducible part (specification, routine oversight) without shifting cost to parts that are already hard to pay. Belongs in `ccc-model.md` as a test applied when considering architectural investment.

### 3. The role-shift punchline

From `cognitive-leverage-framework.md` § IX: **"The operator's job upgrades from *doing and managing* to *maintaining the universe model and directing the system's posture within it*."** Punchy, non-obvious statement of the role shift. Belongs in `role-shift.md` as the headline framing.

### 4. Minor schema additions

- **"Output queue"** as a per-agent schema element — the agent's generated-but-not-yet-ingested output. Makes the inbound-pipe concept concrete at the agent level. Goes in `universe-model.md`.
- **"Opportunities" and "threats"** as first-class universe elements — currently absorbed in Ontology/Signals/Gap. The drive `universe-model.md` one-sheet calls them out explicitly. Minor refinement in `universe-model.md`.

---

## File-by-file update list

### `ccc-model.md`
- New section **"The Optimization"** — the objective, three constraints, decision variables (the formal statement above).
- New section **"The deeper-vs-broader decision rule"** — marginal-return logic.
- New note on **"C has texture"** as a refinement.
- Add the **design rubric** ("does this reduce CCC_reducible without raising CCC_intake or CCC_horizon?") in a tool-evaluation section.
- Retire "tentative" marker from "two drivers" since conv-2/3/6 plus drive batch all confirm.

### New file: `leverage-primitives.md`
- Six canonical primitives, each with operational description and how the framework operates on it.
- Cross-references from hub's terminology.

### `cognitive-allocation-audit.md`
- Reorganize the five arbitrage types into three tiers (constraint violations / structural inefficiencies / cull decisions).
- Explicit cross-reference to the threshold rule as the formal basis for "starved position" being the primary arbitrage.

### `role-shift.md`
- Add the "doing and managing → maintaining the universe model and directing the system's posture" punchline as the headline framing.

### `universe-model.md`
- Add "output queue" to the Agent & Fleet Registry section.
- Call out "opportunities" and "threats" as explicit first-class elements (currently implicit in Ontology / Signals).

### `synthesis.md` (hub)
- New section **"What cognitive leverage optimizes"** — prose version of the objective + constraints, placed between Key Concepts and Rubrics. *This becomes the most important section of the synthesis.*
- **New rubric entry** for deeper-vs-broader decision.
- **Retire "Leverage primitives (in flight)"** — replaced with reference to `leverage-primitives.md`.
- **Rewrite the "overextended" language** in the three-layer-stack sharper cuts to use the falsifiable test.
- **Add "C has texture"** in Key Concepts as a refinement to the C primitive.
- **Update terminology**: add the four new primitives, the design rubric, the falsifiable-overextension test, output queue, opportunities/threats as universe elements.
- **Update confidence markers**:
  - Retire "tentative" on two drivers (confirmed across conv-2/3/6 + drive batch).
  - Retire "in flight" on leverage primitives (canonical list now exists).
  - Keep tentative on Direction 1 / Direction 2 names (still awkward; re-examine in Phase 3).
- **Update open questions**: add "agent projection mechanism" (how a slice of the schema gets scoped/delivered to a single agent) per `cognitive-leverage-framework.md` § X.
- **Source log**: add entries for the drive batch (ten files, with which ones added substance).

### `process.md`
- Add note under Phase 2 that a mid-review source batch (Google Drive) arrived and extended the synthesis while the UX review was in progress. Call it Phase 2.5 for clarity.

### `review.html` (companion site)
- **New Tier-1 section: "What cognitive leverage optimizes"** — with the math formatted as readable blocks, constraints spelled out, and the falsifiable-overextension test highlighted in a callout.
- **New Tier-1 subsection in rubrics: "Deeper vs. Broader"** — the marginal-return decision rule, stated cleanly.
- **New Tier-2 section: "Leverage primitives"** — six primitives as collapsible subsections.
- **Reorganize audit section** into three tiers of arbitrage.
- **Update role-shift section** with the punchline.
- **Update confidence pills** throughout to reflect retirements.
- **Add a "what changed since the original review" callout at the top** — since the user is mid-review, make it clear what's new.

---

## Order of execution

Structured to keep the synthesis internally consistent at every step (so if the user reviews mid-execution, nothing's broken).

1. **`ccc-model.md`** — add optimization + deeper-vs-broader + design rubric + C has texture. This is the foundational change; everything else references it.
2. **`cognitive-allocation-audit.md`** — reorganize into three tiers, anchor to threshold rule.
3. **New file: `leverage-primitives.md`** — six primitives documented.
4. **`role-shift.md`** — headline punchline + cross-ref to primitives.
5. **`universe-model.md`** — output queue, opportunities/threats.
6. **`synthesis.md` (hub)** — add optimization section, update rubrics, update terminology, retire markers, refresh open questions. This is the heaviest hub edit.
7. **`process.md`** — Phase 2.5 note.
8. **Source log update** — drive batch entries.
9. **`review.html` regeneration** — with all the above integrated.

Estimated scope: about 1-1.5 hours of focused editing. Hub edits are the longest.

---

## What I need from you before executing

Short list:

1. **Math sanity-check.** Does the optimization formulation above match what you have in mind? In particular:
   - The objective `Σ [R∞_i + R_i(x_i)]` — is that right? Or is there a time-horizon discount I'm missing?
   - The threshold rule `x_i ≥ T_i OR x_i = 0` — is this a hard constraint or a strong preference? The drive doc states it as hard; I'd interpret it as strong (you might tolerate a project at `x_i < T_i` temporarily if T is expected to drop soon).
   - The deeper-vs-broader decision rule as marginal return comparison — does this match your intuition?

2. **"C has texture" treatment.** Keep it as a refinement (canonical teaching math stays scalar), or make it foundational (canonical form is multi-dimensional from the start)?

3. **Leverage primitives list — six?** Delegation depth, parallel judgment capacity, context compression, hypothesis velocity, judgment surface area, compounding artifacts. Anything missing? Anything redundant?

4. **Scope.** Do this update as described, or pare it back? If pared, my priority ordering would be: (1) optimization formulation, (2) leverage primitives, (3) audit reorganization, (4) minor integrations. First two are the high-value changes.

Once confirmed, I execute in the order above and produce a regenerated `review.html` that reflects all of it. The original `review.html` stays under the same filename (overwritten) since Phase 2 review is continuous, not versioned.
