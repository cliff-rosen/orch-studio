
Cognitive Leverage
/
Here’s something I’m thinking about regarding cognitive leverage my colleague. Adam and I are trying to get several AI apps into the marketplace in parallel. Now there’s actually an option that we can consider to a certain extent we’re using agents to develop you know for the actual coding to write our marketing stuff whatever and the question is what would it take for Adam and I to spend let’s say half as much time developing releasing these products because we’re we’re dedicating more to AI now without magically adding anything the trade-off would be the quality of each effort would would go down as Adam and I spent less time so basically what I’m saying is we’re spending what we think is the optimal amount of time given what we can delegate to AI we can go further faster if we delegate more because the AI dust things faster but we would get into quality issues but the interesting thing is you know maybe if we did you know if we spent half as much time the quality would fall off a certain amount, but we’d have twice as many products and what if we did a attempt as much time like at some point, you know you have to consider that the fall off of the quality let’s say diminishes for something like that. It’s just a new way that you have to think about things and really this gets much more interesting right now it’s only a small portion of the overall workflow that we’re delegating to AI but when we have better agents for go to market and product strategy and stuff like that, that’s another lover and I just wanna talk through the math in this leverage.

Show more
Apr 16
This is a genuinely interesting optimization problem, and I think you're circling around something real but it's worth being precise about the math because the intuition can mislead you.

The core question: you're trading quality per product for number of products. Whether that's a good trade depends entirely on the shape of two curves — how quality degrades as your time-per-product drops, and how outcomes (revenue, learning, market position) scale with quality.

The naive model people usually reach for: "If quality falls off slowly, parallelize more." But this misses that outcomes are rarely linear in quality. In most marketplaces, returns to quality are brutally non-linear — the top product in a category captures most of the value, the #5 product captures almost nothing. If that's your world, halving quality to double throughput is often catastrophic, even if quality only drops 20%, because you've moved from "contender" to "ignored" across your whole portfolio.

The counter-case where your instinct is right: when you don't know which product will win. Then each product is a bet, and having more bets at slightly lower individual quality can beat fewer bets at higher quality — this is the portfolio argument, and it's why VCs and indie hackers both lean toward volume. The key variable is your hit rate and your ability to detect hits early and then double down. If you can ship 4 products at 70% quality, identify the one that's getting traction, and then pour your remaining attention into that one, you've essentially used parallelization as a discovery mechanism.

The thing I'd actually push on: you're framing this as time-per-product, but the more important variable is probably "irreducible founder judgment per product." Some decisions — positioning, what to cut, reading early user signal, pricing — don't parallelize well even with great agents, because the bottleneck is your taste and context, not execution speed. If you halve your time on each product, you're not halving all activities uniformly; you're specifically starving the judgment-heavy decisions, because those are the ones agents can't yet do. The execution stuff (code, copy, assets) was already going to get AI-accelerated. So the quality falloff isn't smooth — it's concentrated in exactly the decisions that determine whether a product works at all.

Concretely, I'd think about it this way: before modeling the leverage math, audit where your hours currently go on a product. Separate them into (a) things AI already does well, (b) things AI will plausibly do well in 12 months, and (c) things that require you specifically. The leverage question is really "how much can I compress (a) and (b) while protecting (c)?" If (c) is 15 hours per product and irreducible, then your real constraint is how many products' worth of (c) you and Adam can do in parallel without the judgment itself degrading from context-switching — which is a different curve than time-per-product, and usually steeper than people expect.

Happy to actually put numbers on any of this if you want to model it out — the diminishing-quality-falloff intuition you mentioned is real but it depends heavily on which activities you're compressing.

Well, let’s focus on this simple example. Let’s say that Adam and I are thinking of doing four products instead of two. I’m doing half as much time on each and we might say well if we did that let’s just say that we estimate each product would be significantly less than 50% likely as much to succeed so the expected outcome is significantly less but interestingly, what if we decided to do 200 instead of two let’s talk about the difference in the math there

Apr 16
Good — this is where it gets interesting, because the math changes character completely between those two cases.

The 4-product case is dominated by quality. You said each product is "significantly less than 50% as likely to succeed" at half the time. Let's put a number on it: say each product at half-time has 30% of the success probability of a full-time product (a steeper falloff than linear, which matches your intuition). Then 4 products × 0.30 = 1.2 expected successes, versus 2 products × 1.0 = 2.0. You've lost expected value by parallelizing. This is the regime where quality compounds faster than quantity, and it's the regime most founders are actually in when they try to 2x their throughput.

The 200-product case is a completely different game. You're no longer in "how do I maximize expected successes per product" — you're in lottery-ticket territory, where the question is "what's the probability that at least one product is a massive hit, and is that hit big enough to dwarf everything else?" If each of 200 products has even a 2% chance of being a real success, you're nearly certain (~98%) to get at least one hit, and probably 3-5 hits. The math flips because marketplace outcomes are power-law distributed — one breakout product can be worth 100x a merely decent one. At 200 products, you're not trying to make each one good; you're buying exposure to the tail.

But — and this is the part the simple math hides — the 200 case only works if three conditions hold. First, your cost per product has to actually approach zero, not just halve; you can't personally shepherd 200 things, so the AI has to do essentially all of it, with you and Adam doing almost pure selection and direction. Second, you need a detection mechanism — some way to tell within weeks which of the 200 is showing signal, because otherwise you've just made 200 dead products and can't tell which to invest in. Third, the marketplace has to actually let 200 low-effort products exist without penalizing you (app stores, for instance, increasingly punish spam-adjacent portfolios, and your brand/developer account can get tainted).

The interesting regime is neither 4 nor 200 — it's the shape of the curve between them. At 2 products you're quality-maximizing. At 200 you're portfolio-maximizing. Somewhere in between there's probably a phase transition, and it's not smooth. My guess for most two-person teams using current AI tooling is that the transition sits around 10-20 products, if you've built a real detection-and-doubling-down system. Below that you're just diluting; above that without the infrastructure you're just generating noise. The 4-product plan is the worst of both worlds — enough dilution to hurt quality, not enough volume to get portfolio effects.

So the honest answer to "what about 200" is: the math works in principle, but it's a different business model, not just a scaled version of what you're doing now. It requires you to stop being product builders and start being a product-selection-and-amplification engine. That's a real option, but it's worth naming it as the distinct choice it is rather than as a point on a continuum with "do 4 instead of 2."

No, I don’t think we need it to be a massive hit. I think that misses the point that’s an extra variable that we don’t have to add. They could all have exactly the same. You know six outcome possibility distributions let’s say as a function of effort all we’re saying is that maybe with half as much time it’s a quarter as likely but maybe with 100 as much time it’s only a 20th as likely that’s all that we need for the math to tell a different story. But then here’s the kicker another variable is actually you know there’s there’s your app approaching full automation so maybe by the time you get to 200 agents they’re basically fully automated which means you could do 2000 agents therefore for pretty much the same effort, do you follow me?

Apr 16
Yes, I follow, and you're right — I was sneaking in an assumption (power-law outcomes) that you didn't need. Let me redo it on your terms.

Your actual claim is just about the shape of the effort-to-success curve. If success probability falls off sub-linearly with reduced time past some point — i.e., cutting time by 100x only cuts success probability by 20x — then expected successes increase with parallelization, even with identical outcome distributions per product. No tail, no lottery, no power law needed. Just: diminishing marginal returns to effort, which is empirically how most creative/product work behaves. The first 20 hours matter enormously; hours 180-200 are polish.

Concretely: 2 products at full effort, success rate p, gives 2p expected wins. 200 products at 1% effort each, if success rate is p/20 (your number), gives 200 × p/20 = 10p expected wins. Five times more, with the same outcome distribution per success. That's the whole argument, and it's correct. My earlier framing was solving a harder problem than you posed.

And your second point is the real one. The effort curve isn't static — it's collapsing. The reason cutting time by 100x today gives you 1/20th the success rate is that you're still the bottleneck for some non-trivial fraction of the work. As agents approach full automation of the build-and-launch loop, the marginal human effort per product trends toward "pick it and point at it." At that point the denominator in your leverage ratio stops being time and starts being something like attention or judgment-bandwidth, which is a much smaller and more scalable resource. So 2000 products at near-zero marginal effort isn't a different math — it's the same math with the effort term going to zero, which means the leverage goes to infinity in the limit. The interesting question becomes what the new bottleneck is once effort drops out.

Here's where I'd push, though, because I think it sharpens your own framing. If the logic is "expected successes scale with N as long as success-rate falls off slower than 1/N," then the practical question is: where does that relationship actually break? It has to break somewhere, because you can't have 10 million products each with p/100000 success rate all paying off. Three candidates for where it breaks:

One, the success-rate curve probably isn't monotonically sub-linear forever. At some very low effort level, products stop being products — they don't compile, don't solve anything, don't get listed. Success rate doesn't decay gracefully; it hits a cliff. The question is where that cliff is, and agents moving toward full automation is precisely what pushes the cliff further out. That's the regime you're describing, and you're right that it's the key variable.

Two, the denominator constraint shifts from your time to something shared across products — your developer account standing, your brand, your marketing channel's tolerance for volume, your ability to even distinguish which product is which. These are real and they cap N independent of effort-per-product.

Three — and this is the one I actually think is the crux for you and Adam right now — even if agents can build 2000 products, picking 2000 product ideas that each have an independent shot at p/20 success is itself a task that doesn't trivially scale. Idea quality and differentiation get harder at volume, not easier. So the automation frontier advancing doesn't just raise N; it shifts your job to "can we generate 2000 genuinely distinct bets," which is a judgment/taste problem that current agents are much worse at than they are at execution.

So the math tells the story you're describing, and the leverage is real and growing. The useful reframing is: every increment of automation doesn't just let you do more — it moves your bottleneck one step upstream, from execution to selection to ideation to taste. The question worth obsessing over isn't "how many products can we ship" but "what's the bottleneck at each level of N, and is that bottleneck something Adam and I are unusually good at?" Because that's where your actual edge compounds.

I’m not following your challenge, stated more clearly

Apr 16
Fair — let me restate it cleanly.

Your math says: as long as success-rate-per-product falls off slower than 1/N, expected successes grow with N. Agents approaching full automation push that relationship further, so N can keep climbing.

My challenge is just one question: does that relationship hold all the way up, or does it break somewhere?

I'm claiming it has to break, for three possible reasons:

The success curve eventually hits a cliff, not a smooth decay. At some low-enough effort, products stop being viable at all — they don't work, don't get listed, don't solve anything. So p/20 at 1% effort might be true, but p/10000 at 0.001% effort might actually be zero, not a tiny number. Agents push the cliff out, but it exists.
Shared resources cap N regardless of per-product effort. Your developer account, brand reputation, marketing channels, and app store standing are shared across all products. Those constraints don't care how cheap each product was to make.
The bottleneck moves upstream as automation improves. If agents handle execution, your constraint becomes picking 2000 genuinely distinct product ideas worth betting on. Ideation and taste don't scale the way execution does.
The reason this matters for your decision: the leverage is real, but knowing where the curve breaks tells you the right N to aim for right now, and tells you what skill to invest in building — because whatever the current bottleneck is, that's where your edge has to live.

Does that land?

I don’t recognize the math as such with the one over end. Why don’t you show me this in a table?

Apr 16
Sure. The "1/N" thing was just shorthand — let me drop it and show the actual numbers.

Setup: baseline is 2 products at full effort, each with success probability p. I'll use p = 0.5 so the numbers are easy. Expected successes at baseline = 2 × 0.5 = 1.0.

Now we vary N (number of products) and the success rate per product at the reduced effort level:

N products	Effort per product	Success rate per product	Expected successes	vs. baseline
2	100%	0.50	1.00	1.0x
4	50%	0.125 (¼ of 0.5)	0.50	0.5x
4	50%	0.25 (½ of 0.5)	1.00	1.0x
4	50%	0.35	1.40	1.4x
20	10%	0.10	2.00	2.0x
200	1%	0.025 (1/20 of 0.5)	5.00	5.0x
2000	0.1%	0.010	20.00	20.0x
2000	~0% (automated)	0.025	50.00	50.0x
The rule that determines whether parallelizing wins: compare how fast N grows to how fast the per-product success rate falls.

Your 4-product scenario: N doubled (2→4), success rate dropped to ¼. Rate fell faster than N grew → worse. This is what you said: "significantly less than 50% as likely."
Your 200-product scenario: N went up 100x, success rate fell only 20x. N grew faster than rate fell → 5x better, with no tail/lottery assumption. Just your numbers.
Your 2000-agent scenario: if automation means effort-per-product approaches zero but success rate stays at roughly the 1% level (because agents are now doing the work competently), you get another 10x on top. The last row assumes automation actually raises the per-product success rate back up because agents execute better than a rushed human — which is plausible.
The whole argument in one line: parallelizing wins whenever the success rate falls slower than N rises. Your intuition that this ratio improves as automation increases is the key insight — agents make the rate fall more slowly (or not at all) as N grows.

My earlier "challenge" was just: at some N, the success rate stops falling gracefully and hits zero (products that don't function, accounts that get banned, ideas that run out). Finding where that cliff is tells you the right N to target. But the math you're describing is correct.

A bit about agents executing better than a rushed human makes absolutely no sense already built into all of this is the performance of agents versus humans that’s at every level if at any given level, an agent could do something better than a human then, of course it would

Apr 16
You're right, that was a confused sentence. Scratch it.

The agents-vs-humans performance question is already absorbed into the success rate at each effort level — whoever does a given task, human or agent, it's whatever's optimal for that level. There's no separate "agents execute better" bonus to add on top.

The cleaner statement of the last row: at 2000 products with near-zero human effort, the success rate is whatever it is given that agents are doing essentially all the work. I picked 0.025 (same as the 200 case) to illustrate the scenario where automation has pushed the success-rate curve flat — i.e., going from 1% human effort to 0.1% human effort barely matters because humans weren't the bottleneck anymore. That flattening is the actual phenomenon you're pointing at, and it's what makes N = 2000 interesting: not that agents beat humans, but that human effort has stopped being the binding input, so you can scale N without paying for it in success rate.

The table holds with that correction.

So let’s state what we’re starting now is simply as cleanly as possible. We know that we can always allocate less human attention and delegate more to agents. We know that as we do so the likelihood of success diminishes, but we also know that just as going in the opposite direction, there must eventually be diminishing returns. We see the Converse or the increasing returns now in the opposite direction, which means that there seems to be some point all the way down the line that winds up being optimal because you get more and more in the numerator with less loss

Apr 16
Yes. Stated cleanly:

Human effort per product has diminishing returns — past some point, extra hours barely improve success probability. That's familiar. The symmetric fact is that reducing effort has diminishing losses — cutting from 100% to 50% might cost a lot, but cutting from 10% to 5% costs very little, because you're trimming work that wasn't contributing much anyway.

So the success-rate curve is S-shaped in effort: steep in the middle, flat at both ends. The flat region at low effort is exactly where parallelization wins, because you can multiply N while the per-product success rate barely moves.

The optimum is wherever the marginal gain from adding one more product exceeds the marginal loss in success rate across the portfolio. Given the S-shape, that optimum sits well into the low-effort, high-N region — not at the extremes, but much further toward high-N than intuition suggests, because intuition anchors on the steep middle of the curve where cuts hurt a lot.

And the key dynamic: as agents improve, the flat low-effort region extends further left. The optimum N keeps shifting higher over time, not because the logic changes, but because the curve itself is moving.

That's the whole thing.

I’m not understanding why the curve is as shaped it seems that first as you lean more in the agents the total success goes down, but it seems like eventually it goes up without bound. Why am I wrong?

Apr 16
You're not wrong about the direction — you're describing total expected successes across the portfolio, and I was describing success rate per product. Two different curves. Let me separate them.

Per-product success rate as human effort drops: this is the S-shape. High at full effort, falls off (slowly at first, then steeply in the middle, then flattening near zero because a product built with essentially no human input still has some small chance of working). This curve only goes down as you reduce effort.

Total expected successes across the portfolio (N × per-product rate): this is what you're asking about, and you're right that it doesn't have to be S-shaped. If reducing human effort per product by 10x lets you do 100x more products, and the per-product rate only falls 5x, total successes go up. Keep going and they keep going up. In the limit where human effort approaches zero and agents handle everything, N can grow without bound for the same human input, and total successes grow with it.

So why would this curve ever turn down or stop growing? Only if something outside the per-product math kicks in:

You run out of distinct product ideas worth pursuing (ideation bottleneck).
Shared resources degrade — developer account, brand, channel saturation.
The marketplace itself pushes back (spam filters, ranking penalties, user attention).
Per-product success rate hits actual zero at some effort level, not just a small number.
Absent those, you're right: total expected successes grow without bound as automation improves. The curve I was describing as having an optimum was assuming one of those external constraints binds. If none of them bind in your situation, the answer is just "go as high on N as the agents allow, and keep raising N as they improve."

The real question is which of those external constraints binds first for you and Adam — because that's what actually caps N, not the per-product effort math.

We’re still not seeing this is simply and cleanly as I’d like. Let’s go through a table again and let’s look at the extremes at the limit is where you always learn something.

Apr 16
Good instinct. Let me build this carefully, extremes first.

Setup: baseline is 2 products, each with success probability 0.5, so baseline expected successes = 1.0. I'll vary how much human effort goes into each product, how many products N you can run at that effort level, and the resulting per-product success rate.

Human effort per product	N (products possible)	Per-product success rate	Total expected successes
100% (baseline)	2	0.50	1.0
50%	4	0.25	1.0
25%	8	0.15	1.2
10%	20	0.08	1.6
1%	200	0.025	5.0
0.1%	2,000	0.010	20.0
0.01%	20,000	0.005	100.0
→0%	→∞	→small but nonzero	→∞
Read the extremes.

At the high-effort extreme (top row), you're capped at 2 products because you and Adam are the bottleneck. Quality per product is maxed out but total output is tiny.

At the low-effort extreme (bottom row), human effort per product approaches zero, so N approaches infinity for the same total human input. As long as per-product success rate stays above zero — even at 0.001 or 0.0001 — total expected successes grow without bound, because you're multiplying a tiny number by an arbitrarily huge N.

This is the key insight you were pushing on: in the limit, the answer is always "do more, infinitely more," as long as per-product success rate never actually hits zero. The math has no interior optimum. It just keeps climbing.

So where does reality impose a cap? Only outside this table. Four candidates:

Per-product success rate hits actual zero at some effort level (products that literally don't function).
Ideas run out — you can't generate 20,000 distinct products worth trying.
Shared resources cap you — account standing, brand, marketplace tolerance.
Your own judgment-bandwidth caps how many bets you can meaningfully place and monitor, even if execution is free.
The clean statement: the per-product effort math alone has no optimum — it favors N → ∞. Any real-world optimum comes from an external constraint, not from the effort curve itself. So the practical question isn't "what's the right point on the curve" — it's "which external constraint binds first for us, and at what N?"

Why are you starting with two? The obvious limit would be one

Apr 16
You're right, starting at 2 was arbitrary and muddied the extremes. Let me redo it with N=1 as the true low end.

Human effort per product	N (products)	Per-product success rate	Total expected successes
200% (all effort on one)	1	0.55	0.55
100%	2	0.50	1.0
50%	4	0.25	1.0
10%	20	0.08	1.6
1%	200	0.025	5.0
0.1%	2,000	0.010	20.0
0.01%	20,000	0.005	100.0
→0%	→∞	→small but nonzero	→∞
The top row is the real other extreme: pour everything into one product. Notice it's worse than doing two — because you're already past the point of diminishing returns on a single product. Doubling effort on one product barely moves success probability from 0.5 to 0.55. That's the top of the S-curve: extra hours stop mattering.

So both extremes are bad for different reasons:

N=1 extreme: you're wasting effort on polish that doesn't change outcomes. Diminishing returns to effort on a single product means extra attention earns almost nothing.

N→∞ extreme: mathematically unbounded, but only if per-product success rate stays nonzero and no external constraint binds. Which, as we covered, it will.

The clean picture: total expected successes is low at N=1, rises as you parallelize, and keeps rising without interior optimum in the pure math. The peak is wherever your first real-world constraint hits — ideas, shared resources, judgment bandwidth, or the per-product success rate actually cliffing to zero.

Starting from N=1 makes the asymmetry obvious: the cost of going from 1 to 2 is near-zero (you barely lose per-product quality because you were on the flat top of the curve), while the gain is doubling your shots. That same logic ke

Claude's response was interrupted
Other thing you’re doing that’s idiotic is you’re starting the human effort at 200% I don’t understand it doesn’t matter if it’s two people the extremes are 100% effort 100% of the human effort is going to one product at the next point we would have we go from one products to two products a two products each gets 50% of the effort at three products each gets 33%

Apr 16
You're right, that was sloppy. 100% is the total human effort available, and we're dividing it across N products. Here's the clean table:

N (products)	Human effort per product	Per-product success rate	Total expected successes
1	100%	0.50	0.50
2	50%	0.45	0.90
4	25%	0.35	1.40
10	10%	0.20	2.00
100	1%	0.05	5.00
1,000	0.1%	0.015	15.00
10,000	0.01%	0.005	50.00
100,000	0.001%	0.002	200.00
N → ∞	→ 0%	→ small but nonzero	→ ∞
Now the extremes are clean.

N=1: all your effort on one product. Per-product success rate is at its maximum (0.5 in this example), but total expected successes is just 0.5 because you only have one shot.

N→∞: effort per product approaches zero, success rate per product shrinks but stays above zero, and total expected successes grows without bound.

The shape: per-product success rate falls as you spread effort thinner, but it falls slower than N grows, so the product of the two keeps climbing. That's the whole phenomenon you were pointing at.

And the key asymmetry is at the top of the table: going from N=1 to N=2 barely costs you any per-product success rate (0.50 → 0.45), because you were already on the flat part of the curve where extra effort wasn't buying much. But it nearly doubles your total. That same logic — small quality loss, large N gain — keeps applying all the way down.

No interior optimum in this math. The cap comes from outside it: ideas running out, shared resources, judgment bandwidth, or success rate actually hitting zero at some effort level.

You’re still being too pedantic and you’re not listening to what where I’m trying to lead us. Well, we’re not yet showing here is the degree to which we are now delegating to agents that’s not being shown at all. This could just describe you have one person who’s deciding to divide their time. The significance of delegating to agents has to do with the marginal losses and gains were assuming that at the N equals one and 100% human allocation there was a certain amount to which AI was handling things that’s not being represented but really what we’re saying is we are the plan is we’re increasing the amount that we’re delegating to the agents that’s really the lever and because of that so you know how much do we have to delegate so that we could spend half as much time that’s how much we’re delegating and then the question is how much loss in performance did that cost us and now this is the guts of the math that we have to run do you follow me?

Apr 16
Yes, now I see what you're after. The lever isn't "how thin do I spread my time" — it's "how much of the work am I handing to agents," and the time reduction is just a consequence of that delegation choice. Let me rebuild the table around that.

Agent share of work	Human effort needed per product	N (products possible)	Per-product success rate	Total expected successes
50% (today's baseline)	100% of your available time on 1	1	0.50	0.50
75%	50% per product	2	0.45	0.90
90%	20% per product	5	0.38	1.90
95%	10% per product	10	0.30	3.00
99%	2% per product	50	0.18	9.00
99.9%	0.2% per product	500	0.08	40.00
99.99%	0.02% per product	5,000	0.03	150.00
→100%	→0	→∞	→small but nonzero	→∞
Now the real variable is explicit: agent share. Every row is a delegation decision, and the human-time column and N column both follow from it.

The crucial quantity is how much the per-product success rate drops per increment of delegation. That's the guts of the math, and it depends entirely on how good the agents are at the work you're handing off:

If agents are nearly as good as you at a given task, delegating it costs almost nothing in success rate, and N grows almost for free. Huge win.
If agents are much worse, delegating that task tanks the success rate faster than N grows. Net loss.
So the real decision isn't "what N should we target" — it's "which specific tasks do we delegate next, and what's the success-rate cost of delegating each one?" Some tasks are cheap to hand off (code scaffolding, boilerplate marketing copy, asset generation). Some are expensive (positioning decisions, reading early user signal, knowing what to cut). The optimal delegation schedule hands off the cheap-to-delegate tasks first and guards the expensive ones longest.

And here's the dynamic that makes this a moving target: every month, more tasks move from "expensive to delegate" to "cheap to delegate" as agents improve. So the optimal agent-share ratchets upward over time, not because your judgment about the tradeoff changed, but because the tradeoff itself changed.

The practical framing this gives you and Adam: don't think about it as "how many products should we run." Think about it as "what's the next task we should hand to agents, and what does our best estimate say that costs us in per-product success rate?" You delegate as long as the N-multiplier from freed-up time exceeds the success-rate hit. When a task's delegation cost is higher than its N benefit, you keep it. When agents get better at that task next quarter, you revisit.

That's the lever, and that's the math that actually matters. Is that the frame you were pushing toward?

All right, let’s put together a one sheet on this that I could send to Adam. It should include a table that illustrates our point and then the narrative and you know what the whole thing is you know the framing for the whole thing is right now we’re doing two products and were hesitant to spread ourselves thin but as you know, we think more about the cognitive leverage I wanted to share this analysis.

Apr 16
I'll put this together as a Word doc you can send to Adam. Let me check the docx skill first.


Viewed a file, created a file, ran a command
Viewed a file, created a file, ran a command
Done. The one-sheet opens with the framing you wanted — we're doing two products, we've been cautious about spreading thin, but the real lever is delegation — then walks through the shape of the curve, the table with extremes at N=1 and N→∞, what it means for our plan, where the math stops working (the external caps), and ends on the actual decision to make: a delegation roadmap rather than a number for N.


Cognitive leverage onesheet
Document · DOCX 
Actually, this is close, but let’s do the table again with the table is missing is a column that’s called leverage and it’s like gonna be the reciprocal of one of those numbers. It’s how much the human is being leveraged.

Apr 16
Got it — leverage is how many products' worth of output each unit of human effort is producing. At baseline (1 product, 100% effort) that's 1×. At 50% effort per product across 2 products, each unit of your time is producing 2 products' worth of attempt, so 2×. Generally: leverage = N (since total human effort is held constant at 100%). Let me rebuild with that column.


Edited 2 files, ran a command, read a file
Edited 2 files, ran a command, read a file
Added the Human Leverage column. It's the reciprocal of human-effort-per-product, which equals N when total effort is held constant — so it makes the multiplier on your time explicit: at 0.02% effort per product across 5,000 products, each hour of your attention is producing 5,000× the output it does today.


Cognitive leverage onesheet
Document · DOCX 
can you give that to me in markdown

Apr 16
Cognitive Leverage: Rethinking How Many Products We Ship
A note for Adam

The question
Right now we're doing two products in parallel, and we've been hesitant to spread ourselves thinner because the instinct is that quality per product would drop. That instinct is correct in isolation — but it ignores the real lever we have, which isn't how we divide our time. It's how much of the work we delegate to agents. I want to walk through the math, because I think it changes what we should be doing.

The setup
Every product requires some mix of our human effort and agent effort. The more agents can handle, the less of our time each product needs. Less time per product means we can run more products in parallel with the same total human bandwidth. That part is obvious.

The non-obvious part is what happens to success rate per product as we delegate more. It drops — but not linearly. At the top of the curve, our last hours of attention aren't buying much (diminishing returns to effort). At the bottom, going from 1% human involvement to 0.1% barely changes outcomes because we weren't the bottleneck anymore. The curve is flat at both ends and steep in the middle.

That shape is what makes parallelizing win: per-product success rate falls slower than N grows, so total expected successes climb.

The math, in one table
Baseline: one product, all our effort, 50% success probability. Numbers in the success-rate column are illustrative but reflect the shape we've been discussing — sub-linear decay as delegation increases.

Agent share of work	Human effort per product	Products (N)	Human leverage	Total expected successes
~50% (today)	100% on 1 product	1	1×	0.50
75%	50% per product	2	2×	0.90
90%	20% per product	5	5×	1.90
95%	10% per product	10	10×	3.00
99%	2% per product	50	50×	9.00
99.9%	0.2% per product	500	500×	40.00
99.99%	0.02% per product	5,000	5,000×	150.00
→ 100% (full auto)	→ 0	→ ∞	→ ∞	→ ∞
Read the extremes.

At N=1, we pour everything into one product. Per-product success is maxed out, but our total expected output is just 0.5. We're wasting attention on polish that doesn't move the needle.

At N→∞, human effort per product approaches zero. As long as per-product success rate stays nonzero — even tiny — total expected successes grow without bound. The pure math has no interior optimum. It just keeps climbing.

Why this changes our plan
The lever isn't "spread ourselves thin." The lever is "delegate more to agents." Every increment of delegation that agents can actually handle well costs us very little in per-product success rate and multiplies N. The question stops being how many products we should do and becomes: which specific tasks do we hand off next, and what does each handoff cost us?

Tasks where agents are nearly as good as us (code scaffolding, boilerplate copy, asset generation, routine QA) are cheap to delegate — low success-rate hit, big N multiplier. Tasks where agents are much worse (positioning, reading early user signal, knowing what to cut) are expensive to delegate and we should guard those longest.

And the tradeoff itself is moving. Every quarter, more tasks shift from "expensive to delegate" to "cheap to delegate" as agents improve. Our optimal agent-share ratchets up over time — not because our judgment changed, but because the curve moved.

Where the math stops working
Worth naming what actually caps N, because it isn't the per-product effort math — that math favors going as high as the agents allow. The real caps are external:

Distinct-ideas bottleneck — can we actually generate 500 genuinely different product bets worth placing?
Shared resources — developer accounts, brand, channel standing. These don't care how cheap each product was to build.
Judgment bandwidth — how many live bets we can meaningfully monitor and amplify when we see signal, even if execution is free.
Success-rate cliff — at some very low effort, products stop functioning at all. Agents moving toward full automation keep pushing this cliff further out.
What I want us to decide
Not a number for N. A delegation roadmap. For each part of our current workflow — ideation, product strategy, build, launch, go-to-market — let's be explicit about what agents handle now, what they could plausibly handle in the next few months, and what stays with us. Whenever a task moves from "us" to "agents," N gets to go up. That's the real planning artifact, and it's how we turn this math into action.

Happy to dig into any of the rows in the table or walk through specific delegation candidates whenever you want.

lets rethink the table for a second. i dont like that we arent showing explicitly the success rate. our whole point is the 1/n vs not 1/n relationship between product N growth and success rate falloff. also think about the order of the columns. the juman lev  belongs near the jumman effort or something like that

Apr 16
You're right on both counts. The success rate column is the whole point — it's what shows that the falloff is slower than 1/N, which is why total successes grow. And grouping human effort with human leverage makes the structural logic easier to read.

Here's the reorganized table. The flow reads left-to-right as: what we're choosing (agent share) → what that means for us (effort + leverage paired) → how many products that buys us (N) → what happens to each one (success rate) → the bottom line (total successes).

Agent share of work	Human effort per product	Human leverage	Products (N)	Success rate per product	Total expected successes
~50% (today)	100% on 1 product	1×	1	0.50	0.50
75%	50% per product	2×	2	0.45	0.90
90%	20% per product	5×	5	0.38	1.90
95%	10% per product	10×	10	0.30	3.00
99%	2% per product	50×	50	0.18	9.00
99.9%	0.2% per product	500×	500	0.08	40.00
99.99%	0.02% per product	5,000×	5,000	0.03	150.00
→ 100% (full auto)	→ 0	→ ∞	→ ∞	→ small but > 0	→ ∞
Now the key relationship is visible in the table itself: as N goes up 5,000×, success rate only falls from 0.50 to 0.03 — about 17×. Success rate falls far slower than N grows, which is exactly why total expected successes climb rather than stay flat. If success rate fell as 1/N, every row in the rightmost column would be 0.50 and there'd be no argument to make. The fact that it falls slower than 1/N is the entire thesis.

Want me to rebuild the docx with this table?

ok

Apr 16

Update table to include success rate column and reorder columns
Update table to include success rate column and reorder columns
Let me also update the intro paragraph right before the table, and the "Read the extremes" commentary to point out the success-rate-vs-N relationship explicitly — since that's now the visible thesis.


Edited a file, ran a command, read a file
Edited a file, ran a command, read a file
Updated. The table now shows success rate explicitly, with human effort and leverage grouped together, and the lead-in calls out the key ratio — N grows 5,000× while success rate only falls ~17×, which is what makes the whole argument work.


Cognitive leverage onesheet
Document · DOCX 
Check out the Google doc called orch out - coglev in.

Apr 16
­


Used 2 tools
Used 2 tools
Read it. This is a much higher-altitude framing than what we were doing with the Adam one-sheet — and it actually recontextualizes that conversation in a useful way.

A few reactions:

The title itself is the thesis. "Orch out, coglev in" is saying orchestration was the 2023–2025 story; cognitive leverage is the 2026+ story. That's a strong position, and it lands because you've already spent years writing the orchestration stack. You've earned the right to say "that layer is solved, the interesting layer is above it."

The Adam conversation is a worked example of one leverage primitive. Specifically delegation depth 
Google Doc
 — how many layers of decision-making you can push down. The table we built is literally a model of what happens to throughput and outcome quality as delegation depth increases. So the one-sheet isn't a separate idea; it's a concrete instance of the framework this doc is sketching. Worth noticing because it means you have at least one leverage primitive already mathematized, which is rare.

The diagnostic-vs-generative question is the real fork. Your instinct in the doc is right that diagnostic is sharper and more characteristic — Cogency works because it tells you when something's broken, not how to build it. A diagnostic cognitive-leverage framework would be something like: "here are the signatures of low leverage (operator producing rather than evaluating, context held in the human not the artifact, judgment spent on execution decisions) vs. high leverage." That's a tool people can use tomorrow. A generative framework is a research agenda.

One thing the doc doesn't yet address that I think matters. The leverage primitives listed are all about the operator's relationship to the orchestrated system. But the Adam math surfaced something different: leverage also has a portfolio dimension. It's not just "how amplified is my cognition on this one problem" but "how many problems can my cognition be usefully spread across simultaneously before the amplification stops mattering." That's a distinct axis — maybe call it parallel judgment capacity — and it's the one that determines whether cognitive leverage is a personal-productivity story or a capital-allocation story. The Adam conversation was really about the latter.

On the entry point: the contrast opening is right. The specific contrast I'd try is the one your own conversations demonstrate — someone treating the orchestrated system as a faster way to build the thing they already planned, vs. someone using it to change what they plan to build. The first is execution leverage. The second is cognitive leverage. Your Adam discussion was entirely in the second mode; most people using agents today are entirely in the first.

Want me to draft the opening contrast, or sketch the diagnostic primitives more concretely?

Well, what I’d like to do now is create yet another document which is the one actually that I’m going to show Adam because Adam and I have been talking about cognitive leverage and I haven’t really made it clear yet. How is it really different from fleet management and I think the Adam document in this document I just showed you if we extract from those documents we have a really good story to tell and it looks something like this. We start with how the cog live in document describes the shift.  The first couple of paragraphs described that shift very well so basically you know we want I want to say to Adam that I think you know when I’m trying to round out what we’ve discussed with the cognitive leverage and specifically differentiated from fleet management, then get into this distinction in these first couple of paragraphs and then say and then sort of as a practical application of that let’s look at you know and then get into the into the orchestrate Studios product portfolio discussion

Show more
Apr 16
Got it. The arc is: frame the shift (from the coglev doc's opening) → make the fleet-management-vs-cognitive-leverage distinction explicit, since that's what Adam needs to hear → then land it with the portfolio math as a concrete application. Let me draft it.

One quick check before I build it — I want to make sure I'm drawing the fleet-management distinction the way you'd draw it, since it's the hinge of the whole document. My read:

Fleet management is about reliably running many agents in parallel — the operational problem of keeping N systems executing correctly. It's an extension of orchestration: orchestration gets one agent to work, fleet management gets many to work. It's still fundamentally about execution reliability at scale.

Cognitive leverage is about what the operator does above that fleet. It's not "can I run 50 agents reliably" — it's "given that I can, what decisions am I now in a position to make that I couldn't before, and how does my judgment get amplified across all of them?" Fleet management is a prerequisite; cognitive leverage is the thing it unlocks.

The portfolio math lands this because it's not about whether we can run 500 products (that's fleet management) — it's about the shape of the decision space that opens up when we can, and specifically the non-obvious result that the optimal strategy shifts dramatically when agents handle more of the work.

Is that the distinction you're drawing, or are you cutting it a different way? I want to get this right before I draft it.

Yes, you got it

Apr 16
­


Created a file, ran a command, read a file
Created a file, ran a command, read a file
The arc goes: brief intro setting up what you're doing → the shift (from the coglev doc's opening — orchestration is table stakes, the bottleneck has migrated to cognition) → the fleet-management-vs-cognitive-leverage distinction made explicit, with the "which problem are you solving" test → segue into the portfolio as the practical application → the full table and extremes → an explicit callback tying the math back to the distinction (this is a cognitive-leverage question, not a fleet-management one) → the external caps with judgment bandwidth flagged as the cognitive-leverage ceiling specifically → closing on the delegation roadmap as the decision you want to make together.

The framing in the final section explicitly returns to the distinction so Adam leaves with it clean: fleet management is table stakes you build regardless; cognitive leverage is the edge from thinking clearly about what the fleet should be doing.


Cognitive leverage for adam
Document · DOCX 
Right there’s a continuity right from the get-go. Adam yet hasn’t been brought into the conversation about the product portfolio about the orchestrate Studios portfolio. That’s just something else that I’ve been thinking about so I think the way to go about this is the motivation is that I’m trying to clarify this distinction between Fleet management and cognitive leverage and provide a more complete picture of it and one aspect is going to be this. The framing that we’ve started to lay out in this document about the shift, the difference, but then say but to actually make this concrete I want to tide actually into you know I want to say what does it look like to apply that type of thinking to orchestrate or Studios itself? Does that make sense?

Apr 16
Yes, that makes sense. The portfolio math isn't a thing you've been discussing with Adam — it's something you're introducing here, as a worked example of what cognitive-leverage thinking looks like when applied to Orchestrate Studios itself. Let me restructure so the motivation is clean: you're clarifying the fleet-management-vs-cognitive-leverage distinction, and you're going to make it concrete by walking through what happens when you apply that lens to our own studio.


Edited 3 files, ran a command, read a file
Edited 3 files, ran a command, read a file
The continuity is fixed. The intro now frames the whole document as clarifying the fleet-management-vs-cognitive-leverage distinction, with the studio analysis introduced as a fresh worked example — "to make it concrete rather than abstract." The transition into the portfolio section explicitly positions it as "applying the lens," and the closing reframes it as one worked example of a broader distinction, inviting Adam to work through the delegation roadmap together rather than presenting a conclusion.


Cognitive leverage for adam
Document · DOCX 
You unnecessarily replaced the previous conclusion what I wanted to do and that’s a very key part of the whole thing to keep part of what I wanna discuss and it’s a good way to really ground everything. So do another revision, but do this one is marked down.

Apr 16
Cognitive Leverage — and Why It's Not Fleet Management
A note for Adam

Adam — I want to round out what we've been discussing about cognitive leverage, because I don't think I've drawn the line clearly enough between it and fleet management. The two get collapsed together and I think that's costing us clarity about where the actual edge is. Below is how I'd frame the distinction, and then — to make it concrete rather than abstract — I want to walk through what it looks like to apply cognitive-leverage thinking to Orchestrate Studios itself. The studio turns out to be a useful test case, because the answer the framework gives is not the answer our current instincts give.

The shift
Orchestration was about getting the machine to do the work reliably. Cognitive leverage is about what that buys us as thinkers — which is the more interesting story now, because orchestration is increasingly table stakes and the frontier has moved to how humans use these orchestrated systems to think at scale.

For the last few years the conversation had to be about orchestration because nothing worked without it. You couldn't talk about leverage when the substrate was unreliable. That's changed. Agent loops hold together. The bottleneck has migrated, and it's sitting squarely on the human again, but in a new form. The bottleneck isn't execution anymore — it's which questions to ask, which decompositions to trust, which outputs to integrate, and which bets to place. That's cognition, not orchestration.

Fleet management vs. cognitive leverage
This is the distinction I want to make sharp, because I think we've been using "cognitive leverage" loosely and it's worth separating the two.

Fleet management is the natural extension of orchestration. Orchestration gets one agent to work reliably; fleet management gets many agents to work reliably in parallel. It's still fundamentally an execution-reliability problem — how do I keep N systems running correctly, monitored, coordinated, not stepping on each other. It's operational. It scales the machine.

Cognitive leverage is the layer above that. It's not about whether we can run 50 agents reliably — it's about what decisions we're now in a position to make that we couldn't before, and how our judgment gets amplified across all of them. Fleet management is a prerequisite; cognitive leverage is what fleet management unlocks. If fleet management scales the machine, cognitive leverage scales the operator.

The test for whether you're doing one vs. the other: if your problem is "how do I keep all these agents running," that's fleet management. If your problem is "given that I can keep them running, what's the highest-value thing to point them at, and how do I stay ahead of the judgment calls their outputs surface," that's cognitive leverage. Most teams will experience the first problem as they scale and never notice the second. The second is where the actual edge is.

Applying the lens: Orchestrate Studios
So what does it look like to actually think about our own work through the cognitive-leverage lens rather than the fleet-management one? I've been turning this over for Orchestrate Studios specifically, and the framework produces a non-obvious answer that I want to walk you through.

Right now we're running two products in parallel. Our instinct — and the reason we haven't gone wider — is that quality per product would drop if we spread thinner. That instinct is correct in isolation. But it's a fleet-management instinct: it's reasoning about how thin we can stretch ourselves while still executing. The cognitive-leverage question is different: it's asking how much of the work we should be handing off, and what the shape of the resulting tradeoff actually looks like.

Every product requires some mix of our human effort and agent effort. The more agents can handle, the less of our time each product needs. Less time per product means we can run more products in parallel with the same total human bandwidth. That part is obvious.

The non-obvious part is what happens to success rate per product as we delegate more. It drops — but not linearly. At the top of the curve, our last hours of attention aren't buying much (diminishing returns to effort). At the bottom, going from 1% human involvement to 0.1% barely changes outcomes because we weren't the bottleneck anymore. The curve is flat at both ends and steep in the middle. That shape is what makes parallelizing win: per-product success rate falls slower than N grows, so total expected successes climb.

The math
Baseline: one product, all our effort, 50% success probability. Watch the two middle columns — as N grows 5,000×, success rate per product only falls about 17×. Success rate falls far slower than N grows. That's the entire thesis: if success rate fell as 1/N, total expected successes would stay flat. The fact that it falls slower is why the last column keeps climbing.

Agent share of work	Human effort per product	Human leverage	Products (N)	Success rate per product	Total expected successes
~50% (today)	100% on 1 product	1×	1	0.50	0.50
75%	50% per product	2×	2	0.45	0.90
90%	20% per product	5×	5	0.38	1.90
95%	10% per product	10×	10	0.30	3.00
99%	2% per product	50×	50	0.18	9.00
99.9%	0.2% per product	500×	500	0.08	40.00
99.99%	0.02% per product	5,000×	5,000	0.03	150.00
→ 100% (full auto)	→ 0	→ ∞	→ ∞	→ small but > 0	→ ∞
Read the extremes.

At N=1, we pour everything into one product. Per-product success is maxed out, but our total expected output is just 0.5. We're wasting attention on polish that doesn't move the needle.

At N→∞, human effort per product approaches zero. As long as per-product success rate stays nonzero — even tiny — total expected successes grow without bound. The pure math has no interior optimum. It just keeps climbing.

Why this is a cognitive-leverage question, not a fleet-management one
Notice what the table is really asking us to decide. It's not "can we operationally run 500 products?" — that's the fleet-management question, and the answer is a function of tooling and infrastructure. The table is asking a different question: given that we could run them, what's the highest-expected-value point on the curve, and which tasks do we have to hand off to get there?

Tasks where agents are nearly as good as us — code scaffolding, boilerplate copy, asset generation, routine QA — are cheap to delegate. Low success-rate hit, big N multiplier. Tasks where agents are much worse — positioning, reading early user signal, knowing what to cut — are expensive to delegate, and we should guard those longest. The delegation decision is the cognitive-leverage decision. Fleet management just makes the resulting plan executable.

And the tradeoff itself is moving. Every quarter, more tasks shift from "expensive to delegate" to "cheap to delegate" as agents improve. Our optimal agent-share ratchets up over time — not because our judgment changed, but because the curve moved.

Where the math stops working
Worth naming what actually caps N, because it isn't the per-product effort math — that math favors going as high as the agents allow. The real caps are external:

Distinct-ideas bottleneck — can we actually generate 500 genuinely different product bets worth placing?
Shared resources — developer accounts, brand, channel standing. These don't care how cheap each product was to build.
Judgment bandwidth — how many live bets we can meaningfully monitor and amplify when we see signal, even if execution is free. This is the cognitive-leverage ceiling specifically.
Success-rate cliff — at some very low effort, products stop functioning at all. Agents moving toward full automation keep pushing this cliff further out.
What I want us to decide
Not a number for N. A delegation roadmap. For each part of our workflow — ideation, product strategy, build, launch, go-to-market — let's be explicit about what agents handle now, what they could plausibly handle in the next few months, and what stays with us. Whenever a task moves from "us" to "agents," N gets to go up. That's the real planning artifact, and it's how we turn this math into action.

The takeaway
The studio exercise is really just one worked example. The bigger point is that fleet management and cognitive leverage produce different plans for the same business. Fleet management, applied to Orchestrate Studios, says: run the two products well, scale when the infrastructure lets you. Cognitive leverage, applied to the same studio, says: the number of products isn't the decision — the delegation roadmap is, and the number of products falls out of that.

Fleet management is table stakes we have to build regardless. Cognitive leverage is the edge we get from thinking clearly about what the fleet should be doing. I wanted to put the studio portfolio on the table as a live example because I think it's the first real test of whether we can operate at that layer — and I'd rather work through the delegation roadmap with you than make the call unilaterally.

I think we could tighten this up. I want you to reduce it to an outline so we can look at the outline together and see how tight it is.

Apr 16
Cognitive Leverage — and Why It's Not Fleet Management
Intro / motivation

Want to clarify the fleet-management vs. cognitive-leverage distinction
Will ground it with a worked example: applying the lens to Orchestrate Studios
Framework gives a non-obvious answer vs. our current instincts
The shift

Orchestration was about reliable execution; cognitive leverage is about what that buys us as thinkers
Orchestration is now table stakes — the substrate works
Bottleneck has migrated back to the human, but in a new form: judgment, not execution
Fleet management vs. cognitive leverage

Fleet management = extension of orchestration; scales the machine (execution reliability at N)
Cognitive leverage = the layer above; scales the operator (judgment across N)
Fleet management is a prerequisite; cognitive leverage is what it unlocks
Test: "how do I keep agents running" (fleet) vs. "what should I point them at" (leverage)
Applying the lens: Orchestrate Studios

We're running 2 products; instinct against going wider is a fleet-management instinct
Cognitive-leverage question: how much to delegate, and what's the tradeoff shape
Success rate per product falls sub-linearly as we delegate — flat at both ends, steep in the middle
That shape is why parallelizing wins: rate falls slower than N grows
The math (table)

Baseline: 1 product, full effort, 0.5 success
As N grows 5,000×, success rate only falls ~17×
Extremes: N=1 wastes attention; N→∞ has no interior optimum
Why this is a cognitive-leverage question

Table isn't asking "can we run 500 products" (fleet) — it's asking where on the curve to sit (leverage)
Cheap-to-delegate tasks (execution) vs. expensive (judgment)
Tradeoff keeps moving as agents improve; optimal agent-share ratchets up
Where the math stops working (external caps)

Distinct-ideas bottleneck
Shared resources (accounts, brand, channels)
Judgment bandwidth — the cognitive-leverage ceiling specifically
Success-rate cliff
What I want us to decide

Not a number for N — a delegation roadmap
Per workflow stage: what agents do now, next, and what stays with us
The takeaway

Fleet management and cognitive leverage produce different plans for the same business
Fleet: run 2 products well, scale when infrastructure allows
Leverage: N isn't the decision — the delegation roadmap is, and N falls out of it
Studio portfolio is the first real test of operating at the leverage layer
Let’s not frame it as the framework gives a non-obvious answer versus our instincts let’s frame it more as it gives us something to think about beyond what’s immediately obvious. And it’s not how do I keep agents running? It’s how do I get agents to handle meaningful portions of the work?  And in the outline where we were applying this to orchestrate, Studios is falling flat. in fact that part of the outline just seems terrible compared to the narrative.

Apr 16
Cognitive Leverage — and Why It's Not Fleet Management
Intro / motivation

Want to clarify the fleet-management vs. cognitive-leverage distinction
Will ground it with a worked example: applying the lens to Orchestrate Studios
Framework surfaces something worth thinking about beyond what's immediately obvious
The shift

Orchestration was about reliable execution; cognitive leverage is about what that buys us as thinkers
Orchestration is now table stakes — the substrate works
Bottleneck has migrated back to the human, but in a new form: judgment, not execution
Fleet management vs. cognitive leverage

Fleet management = extension of orchestration; scales the machine (reliable execution at N)
Cognitive leverage = the layer above; scales the operator (judgment across N)
Fleet management is a prerequisite; cognitive leverage is what it unlocks
Test: "how do I get agents to handle meaningful portions of the work" (fleet) vs. "given that they can, what should I have them work on" (leverage)
Applying the lens: Orchestrate Studios

Our current default: two products, hesitant to spread thinner because quality per product would suffer
That reasoning treats our time as the fixed input — a fleet-management frame
Cognitive-leverage frame treats delegation depth as the variable: as agents take on more, per-product effort drops and N rises together
The interesting question isn't "how many products" — it's "what's the shape of the curve when we vary how much we're handing off"
The math (table)

Baseline: 1 product, full effort, 0.5 success
As N grows 5,000×, success rate only falls ~17× — rate falls slower than N grows
Extremes: N=1 wastes attention; N→∞ has no interior optimum
Why this is a cognitive-leverage question

Table isn't asking "can we run 500 products" (fleet) — it's asking where on the curve to sit (leverage)
Cheap-to-delegate tasks (execution) vs. expensive (judgment)
Tradeoff keeps moving as agents improve; optimal agent-share ratchets up
Where the math stops working (external caps)

Distinct-ideas bottleneck
Shared resources (accounts, brand, channels)
Judgment bandwidth — the cognitive-leverage ceiling specifically
Success-rate cliff
What I want us to decide

Not a number for N — a delegation roadmap
Per workflow stage: what agents do now, next, and what stays with us
The takeaway

Fleet management and cognitive leverage produce different plans for the same business
Fleet: run 2 products well, scale when infrastructure allows
Leverage: N isn't the decision — the delegation roadmap is, and N falls out of it
Studio portfolio is the first real test of operating at the leverage layer






Claude is AI and can make mistakes. Please double-check responses.
