# Case Study — Orchestrator Studios

Anchor case for the framework. Walks through how the canonical optimization plays out against real fixed inputs. Used in the *internal strategic memo* use case (see `positioning.md`).

Primary sources: `sources/memo-original-teaser.md`, `sources/conv-1.md`, `sources/conv-7.md` (production of the memo). Evolution notes for the memo→conv-1 refinement: `sources/archive/memo-to-conv-1-evolution.md`.

---

## The case

**Founding commitment.** Adam and Cliff started with two fixed inputs and a clear purpose:
- Combined cognitive capacity `C` — bounded (different per person, known, not expandable).
- Dollar budget `B` ≈ $1,000/month.
- Purpose: apply core competency to capture value from a corner of the market they understood.

**Pre-AI counterfactual (`t_i` pre-AI)**: at human labor rates, `B = $1k/month` buys essentially no cognitive offload. `t_i` for any serious product is close to all of `C`. **N=1 wasn't a choice; it was the only feasible answer.** The threshold constraint disqualified everything else.

**What actually happened**: `B` spent on agents — cheap AND capable (Driver A) — lowers `t_i` on products substantially. Same inputs, dramatically different exchange rate. `t_KH` drops enough that `C` comfortably covers two products above their thresholds. **N=2 is the first, unspoken cognitive-leverage move** — the operators re-ran the optimization with the new `t_i`s without writing it down.

**Current state**: two products (Knowledge Horizon, TableThat), both above their thresholds. The math-in-the-head that got them to N=2 hasn't yet been applied rigorously to the question of N=3, N=10, N=100 — which is exactly what the canon is built to answer.

## Numerical anchor (from the original teaser memo)

Baseline: one product, all operator effort, 50% success probability. Key observation: as N grows 5,000×, success rate per product falls only ~17×. If success fell as `1/N` the last column would be flat; the fact that it climbs is the leverage phenomenon.

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

### How the table reads under the canon

Each row is a feasible portfolio when `t_i ≤ C/N`. The "Success rate per product" column is `R_i(x_i)` at `x_i = C/N`. "Total expected successes" is `Σ R_i = N · R_i(C/N)` under an equal-split allocation.

The total keeps climbing because `R_i(x_i)` is relatively flat in the productive zone above `t_i`: halving `x_i` doesn't halve `R_i`. The combinatorial gain from more projects beats the per-project loss. This only holds as long as `x_i = C/N ≥ t_i` — once `N` grows past `C/t_i`, the threshold constraint cuts further growth.

**The N=1 → N=2 move** corresponds to rows 1→2: a 10% per-product success drop traded for doubling portfolio return (0.50 → 0.90). Adam and Cliff made this move in their heads — the math was available; they just hadn't written it down.

### Caveats
- The curve shape was originally presented as vague "diminishing returns." The refined treatment derives the shape from the threshold structure: below `t_i`, zero return; above `t_i`, diminishing-returns growth. The numbers in the table assume this shape.
- The column labeled "Success rate per product" is really a composite of functionality and quality — the framework tries to keep these separable but the anchor table collapses them for simplicity. Treat the numbers as illustrative of the dynamic, not a model to calibrate against.
