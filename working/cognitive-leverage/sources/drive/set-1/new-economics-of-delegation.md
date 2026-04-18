**THE NEW ECONOMICS OF DELEGATION**

*Why the math changed — and what it means for how you allocate yourself*

**What Changed**

| The Old Model Scaling delegation meant hiring. Hiring carried three distinct costs: High transaction cost to initiate — recruiting, interviewing, onboarding Significant ramp time before the resource was productive Ongoing fixed cost regardless of output — salary, overhead, management  These costs acted as a natural governor. Your portfolio stayed bounded because the economics forced it bounded. | The New Model AI delegation collapsed two of those three costs: Transaction cost to initiate → near zero. Spin up a workstream in minutes. Ramp time → near zero. No onboarding, no trust-building, no learning curve. Ongoing execution cost → a small fraction of human equivalent.  The natural governor is gone. Nothing stops portfolio expansion now. |

**The Constraint That Remains**

One cost did not go to zero: the cost of 

One cost did not go to zero: the cost of **you.** Every delegation relationship — no matter how autonomous — requires a minimum ongoing investment of cognitive capital: direction, intake, judgment, horizon-scanning. That floor always existed. AI just made it the only thing left.

| Cognitive Carrying Cost (CCC) → The minimum ongoing investment of attention and judgment required to keep a delegation relationship productive. → Below this threshold: output degrades, goes off-rails, or silently stalls. → Previously masked by resource cost. Now it's the only constraint. |

**Three Return Regimes**

Not all projects are equal. Every workstream falls into one of three regimes — and the math is very different in each.

| Regime 1  One-time effort → one-time return You build it, it pays off, you're done. No ongoing draw on cognitive capital.  Regime 2  One-time effort → ongoing return Fire-and-forget. Invest once, the system runs autonomously and keeps producing. Cognitive draw after launch approaches zero. This is the most valuable position in the model. | Regime 3  Ongoing effort → ongoing return  ← most common The reverse annuity. You must keep injecting cognitive capital to keep getting return. This is where CCC lives — and where most projects actually sit.  The return curve here is non-linear and has a critical kink: x < CCC:  project degrades, return goes negative CCC ≤ x < T:  keeping lights on, return is marginal x ≥ T:  activation threshold crossed, return jumps  Underfunding above the floor is almost as bad as falling below it — you pay carrying cost without reaching the productive zone. |

**The Leverage Parameter**

Every project has a leverage factor **L** — a measure of how autonomous its return stream is:

| L = 0    Pure reverse annuity — every unit of return requires ongoing cognitive injection L = 1    Pure fire-and-forget — capital invested once, return is perpetual  Most projects sit between 0 and 1. Crucially, L is not fixed — you can move it through architectural decisions. |

Building tighter specifications, better tooling, more autonomous pipelines — all of these shift L toward 1. The strategic goal is to run the portfolio as far right on this spectrum as possible.

**The Optimization Problem**

Given a fixed cognitive budget C (hours of focused attention per week), the portfolio question becomes:

| Maximize:  Σ [ R∞ᵢ + Rᵢ(xᵢ) ]     (total return across all projects)  Subject to:   Σ xᵢ  ≤  C                        (cognitive budget constraint)   xᵢ  ≥  CCCᵢ  for all active i     (floor constraint — every project must be funded)   xᵢ  ≥  Tᵢ  or  xᵢ = 0            (threshold rule — don't fund below activation) |

The threshold rule is the brutal insight: a project funded above CCC but below T is consuming resources and producing nearly nothing. It belongs in the portfolio at full activation or not at all.

**Parameter Reference**

| Symbol | Name | What it captures |
| --- | --- | --- |
| C | Cognitive budget | Total focused attention available per week |
| CCCᵢ | Carrying cost | Minimum investment to keep project i productive |
| Tᵢ | Activation threshold | Investment level where return on project i becomes meaningful |
| Lᵢ | Leverage factor | 0 = pure reverse annuity; 1 = fully autonomous |
| R∞ᵢ | Autonomous return | Ongoing return from the fire-and-forget component |
| Rᵢ(x) | Return curve | Return as a function of ongoing cognitive investment |
| xᵢ | Allocation | Actual cognitive investment assigned to project i |

Cognitive Leverage  ·  Economics Model  ·  2026
