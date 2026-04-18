# Cognitive Leverage: Rethinking How Many Products We Ship

*A note for Adam*

## The question

Right now we're doing two products in parallel, and we've been hesitant to spread ourselves thinner because the instinct is that quality per product would drop. That instinct is correct in isolation — but it ignores the real lever we have, which isn't how we divide our time. It's how much of the work we delegate to agents. I want to walk through the math, because I think it changes what we should be doing.

## The setup

Every product requires some mix of our human effort and agent effort. The more agents can handle, the less of our time each product needs. Less time per product means we can run more products in parallel with the same total human bandwidth. That part is obvious.

The non-obvious part is what happens to success rate per product as we delegate more. It drops — but not linearly. At the top of the curve, our last hours of attention aren't buying much (diminishing returns to effort). At the bottom, going from 1% human involvement to 0.1% barely changes outcomes because we weren't the bottleneck anymore. The curve is flat at both ends and steep in the middle.

That shape is what makes parallelizing win: per-product success rate falls slower than N grows, so total expected successes climb.

## The math, in one table

Baseline: one product, all our effort, 50% success probability. Numbers in the success-rate column are illustrative but reflect the shape we've been discussing — sub-linear decay as delegation increases.

| Agent share of work | Human effort per product | Products (N) | Human leverage | Total expected successes |
| --- | --- | --- | --- | --- |
| ~50% (today) | 100% on 1 product | 1 | 1× | 0.50 |
| 75% | 50% per product | 2 | 2× | 0.90 |
| 90% | 20% per product | 5 | 5× | 1.90 |
| 95% | 10% per product | 10 | 10× | 3.00 |
| 99% | 2% per product | 50 | 50× | 9.00 |
| 99.9% | 0.2% per product | 500 | 500× | 40.00 |
| 99.99% | 0.02% per product | 5,000 | 5,000× | 150.00 |
| → 100% (full auto) | → 0 | → ∞ | → ∞ | → ∞ |

**Read the extremes.**

At N=1, we pour everything into one product. Per-product success is maxed out, but our total expected output is just 0.5. We're wasting attention on polish that doesn't move the needle.

At N→∞, human effort per product approaches zero. As long as per-product success rate stays nonzero — even tiny — total expected successes grow without bound. The pure math has no interior optimum. It just keeps climbing.

## Why this changes our plan

The lever isn't "spread ourselves thin." The lever is "delegate more to agents." Every increment of delegation that agents can actually handle well costs us very little in per-product success rate and multiplies N. The question stops being how many products we should do and becomes: which specific tasks do we hand off next, and what does each handoff cost us?

Tasks where agents are nearly as good as us (code scaffolding, boilerplate copy, asset generation, routine QA) are cheap to delegate — low success-rate hit, big N multiplier. Tasks where agents are much worse (positioning, reading early user signal, knowing what to cut) are expensive to delegate and we should guard those longest.

And the tradeoff itself is moving. Every quarter, more tasks shift from "expensive to delegate" to "cheap to delegate" as agents improve. Our optimal agent-share ratchets up over time — not because our judgment changed, but because the curve moved.

## Where the math stops working

Worth naming what actually caps N, because it isn't the per-product effort math — that math favors going as high as the agents allow. The real caps are external:

- Distinct-ideas bottleneck — can we actually generate 500 genuinely different product bets worth placing?

- Shared resources — developer accounts, brand, channel standing. These don't care how cheap each product was to build.

- Judgment bandwidth — how many live bets we can meaningfully monitor and amplify when we see signal, even if execution is free.

- Success-rate cliff — at some very low effort, products stop functioning at all. Agents moving toward full automation keep pushing this cliff further out.

## What I want us to decide

Not a number for N. A delegation roadmap. For each part of our current workflow — ideation, product strategy, build, launch, go-to-market — let's be explicit about what agents handle now, what they could plausibly handle in the next few months, and what stays with us. Whenever a task moves from "us" to "agents," N gets to go up. That's the real planning artifact, and it's how we turn this math into action.

Happy to dig into any of the rows in the table or walk through specific delegation candidates whenever you want.
