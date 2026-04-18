# The Universe Model — Infrastructure Requirements & Schema

What has to get built for cognitive leverage to run in practice — the state-tracking infrastructure that makes `R_i` and `x_i` estimable and the optimization actually executable.

Primary sources: `sources/conv-4.md`, `sources/conv-5.md`.

---

## The premise

**Cognitive leverage is gated by how systematized and AI-legible the operator's universe is.**

The operator's ability to delegate and scale cognitive capability is a function of whether the world they're operating in can be represented in a form that agents can engage with — and kept current as reality moves.

## Portfolio is not the universe

A fundamental reframe. Earlier framings centered on the *portfolio* of agents and commitments. That's too narrow.

- **The portfolio** is one instrument within a larger model.
- **The universe** includes: goals, opportunities, threats, resources, relationships, environmental state, *and* the agent fleet as actors within it.

If your situational awareness only covers the agents themselves, you're watching the hammer, not the nail. The whole point of having agents is to act on the universe. The model has to match that scope.

## The universe is for the operator, not the agents

An important second clarification (conv-5). The universe is the **primary unit of context for the operator** — not any individual agent or the fleet collectively.

- The operator isn't managing agents. The operator is managing outcomes within a universe, and agents are just one category of resource deployed in response to what's happening there.
- Agents receive a *projection* of the universe schema — the slice relevant to their goals and tools — not the whole thing.
- **You don't build up to universe context from agent contexts. You project down from it.** This inverts the common mental model of agent systems ("good agent = good context injection"). The operative context is universe-level; individual agent context is derived from it.

## The operator's unique function: universe model maintainer

Refinement of "horizon scanner" (conv-2). The operator's irreducible role is holding a coherent, current, accurate picture of the entire environment — one no individual agent can hold, and that the fleet as a whole has no mechanism to assemble on its own. Horizon scanning is part of this; so is goal persistence, state currency, and boundary judgment.

The operator's job is **environmental, not managerial**. Not "how are my agents doing?" but "what is happening in my universe, and is the right configuration of resources — human attention, persistent agents, spawned agents, capital, whatever — flowing toward the right places?" Agent spawning is just one lever among many; it's downstream of reading the environment, not upstream.

## Universe boundaries are functional and dynamic

- **Functional, not categorical.** Drawn by relevance-to-goals, not by organizational category. If the CEO's spouse is materially relevant to outcomes (business partner, source of stability, household logistics that free cognitive capacity), they're in the universe. The instinct to draw clean corporate/professional boundaries is wrong — the boundary follows outcome-relevance.
- **Drawn by the operator, not by an org chart.** Defining the universe boundary is itself one of the operator's highest-leverage judgments. *Too narrow and you're optimizing blind. Too broad and the system has no traction.*
- **Dynamic.** Boundaries expand as the operator takes on new goals or gains access to new signals, and contract when they lose them. A fleet optimized for one universe may be badly misconfigured when the universe shifts.

## The two top-level services

Every infrastructure requirement is in service of one of these:

| Service | What it answers |
|---|---|
| **Situational awareness** | What's happening across my full universe right now? What's the current state of goals, threats, opportunities, resources, relationships, environment, and the agent fleet acting within them? |
| **Optimal action / decision support** | Given that model, what is the best deployment of my scarce cognitive capital right now? Which agents to spin up, feed, pause, kill? Which new workstreams to initiate? Where do I personally need to engage? |

These feel related but they're **two different product shapes**:
- Situational awareness is essentially a *dashboard* problem (representation + currency).
- Decision support is a *recommendation / prioritization* problem (reasoning over the model).
- Most existing tools do the first. Almost nothing does the second. Decision support is where the leverage lives.

## The Universe Schema *(in flight — first-pass structure from conv-5)*

First structured pass at the schema. Nine top-level notions. Some observations before the list:

- **Static-ish vs. dynamic.** Ontology, Goals, and Constraints change slowly and deliberately — the operator largely sets these. State, Signals, and Events change continuously — the operator tracks these. Resources sit in between (inventory slow; deployment fast).
- **Descriptive vs. normative.** State describes what *is*. Goals describe what *should be*. The gap between them is the operator's live work queue — deserves explicit representation.
- **Signals deserve special treatment.** Not just data. They're the operator's epistemic access to state. Schema should capture not just what signals exist but their coverage, lag, reliability — and where the blind spots are.

### The nine sections

1. **Ontology** — The entities, domains, and relationships that exist within this universe. The nouns. People, organizations, systems, places, concepts that are relevant to the operator's goals.
2. **Goals** — What the operator is trying to achieve. Outcomes the whole system exists to produce. Hierarchical — strategic down to operational. Goals define what matters within the universe, which partly draws the boundary.
3. **State** — Current condition of the universe. What's true right now. Drifts continuously; what the whole system tries to track and respond to.
4. **Gap** — Derived tension between current state and goals. The system's live work queue.
5. **Signals** — Epistemic access layer. What information is flowing in, from where, with what coverage, lag, and reliability. Includes explicit blind spots.
6. **Resource Registry** — Complete inventory of everything accessible and relevant. See § Resources below.
7. **Agent & Fleet Registry** — A specialized subsection of the resource registry, rich enough to deserve its own structure. See § Agents as resources below.
8. **Constraints** — What can't be changed, crossed, or violated regardless of what the universe demands. Applies at universe, resource, and agent levels.
9. **Events** — The dynamic change layer. Things that happen that should update state and potentially change system posture. Anticipated and unanticipated.

## Resources

Resources are the **interface between the system and the universe** — where the system can perceive and where it can act. Goals live in the operator's intention; state lives in the universe; resources are the points of contact.

### Four categories

- **Readable** — can be observed to understand state. File systems, email, calendars, bank statements, dashboards. Feed the signal layer.
- **Writable / Actionable** — can be modified or acted upon to change state. Sending an email, moving money, booking, posting, updating a file.
- **Consumable** — can be drawn down. Money, credit, time-limited access, API rate limits, storage.
- **Relational** — people and organizations the operator has standing with. Bidirectional, relationship-dependent. Cannot be "used" the same way a file system is used. *(in flight — may deserve its own top-level schema slot rather than sitting inside resources.)*

### Physical resources are first-class

If an operator needs a key to get into their office, that's a resource. The registry must be **universe-complete, not digitally-complete**. Reasons this matters:

- **Gaps become visible.** A physical resource in the registry with no tool coverage is meaningful information — it tells the operator this resource requires direct involvement or a human proxy to be acted upon. The absence of a tool is a fact about the system, not grounds to omit the resource.
- **Registry reflects the universe, not the system's reach.** Keeping those two things distinct is essential — otherwise the system optimizes within its own tool coverage rather than within the operator's actual environment.
- **Enables completeness reasoning.** Trace goals to the resources they depend on; ask which are covered, which require human involvement, which are completely dark. Only possible if the registry is universe-complete.

### Registry vs. coverage (separation)

- **Registry** describes what *exists* in the universe.
- **Coverage** describes what the system can currently *reach*.

Two different things. Must stay conceptually separate.

## Tools, resources, agents — the hierarchy

Clean layering for how the operator configures the system:

- **Universe holds resources.**
- **Operator decides access** — which resources are in scope, with what permissions.
- **Tools implement that access for agents** — a tool is a specific, bounded capability (send email, read file, query DB). Atomic.
- **Agents deploy tools in pursuit of goals** — reasoning and orchestration sitting above tools. The agent is the actor; tools are its limbs; resources are what those limbs can reach.

One resource may be accessible through multiple tools. One tool may touch multiple resources. Configuring the system isn't just "spin up agents with tools." It's **deciding which parts of the universe are exposed, to which agents, through which interfaces, under what constraints.**

## Agents as resources

Agents and fleets are first-class resources in the schema. This creates a *loop* — the schema knows about the agents, and the agents know (a projection of) the schema. This needs clean representation without becoming circular.

Each agent or fleet entry needs:
- Capabilities and tools available to it
- Current goals and state
- What slice of the universe schema it has access to
- Deployment status — persistent or spawned, active or idle
- Constraints on its operation
- **Output queue** — generated-but-not-yet-ingested output. Makes the inbound-pipe concept concrete at the per-agent level. Items on the queue represent pending `CCC_intake` / assimilation work. A long queue is a specific, visible signal of assimilation debt accumulating on that agent.
- **CCC and L estimates** — what the agent is currently costing, and where it sits on the leverage spectrum. First-class for cost visibility (CSF 4).

The schema is **bidirectional** — agents read from it to orient themselves, and they write back to it as they act, updating state, consuming resources, generating signals.

## Opportunities and threats as first-class universe elements

The 9-section schema absorbs opportunities and threats into `Ontology` (they're entities), `Signals` (they're partially observable), and `Gap` (some represent state-vs-goal tensions). In practice, both are load-bearing enough that operators benefit from calling them out explicitly as first-class universe elements rather than reconstructing them from the derived sections:

- **Opportunities** — things that could materially advance goals if acted on. May or may not require new agent workstreams. Maintaining a live register of opportunities keeps them from disappearing into ad-hoc thinking.
- **Threats** — environmental risks, competitive signals, things to monitor. May not be actively in any workstream but consume horizon-scanning attention and can invalidate state if ignored.

Both interact with the portfolio optimization (`synthesis.md` § The Canon): opportunities are candidate new projects to evaluate against `λ` (the common marginal return); threats can force reallocation by invalidating assumptions that existing projects depend on.

## Five Critical Success Factors

Each CSF is load-bearing. Failure mode attached to each.

1. **A unified, current model of the universe.** Accurate, up-to-date, coherent. **Failure mode**: stale, fragmented, or incomplete model → everything downstream breaks. Activity visible, meaning lost.
2. **Goal and context persistence.** Not just agent-level but portfolio/universe-level — what are we trying to accomplish and why. **Failure mode**: can see activity but not meaning.
3. **Signal extraction from agent output.** Inbound pipe does more than deliver raw output — extracts what's decision-relevant. **Failure mode**: intake becomes a full-time job; operator drowns.
4. **A cognitive cost model.** Track or estimate CCC per project. **Failure mode**: operator sees *what* is running but not *at what cost*; can't make tradeoffs.
5. **Friction-free capture.** System mostly self-maintaining. **Failure mode**: model drift — the representation and reality diverge silently until a decision is made against a stale model.

## The foundational hard problem: ontology

Underneath all five CSFs and underneath the schema itself: **how do you represent a universe that includes goals, threats, opportunities, relationships, resources, and agents in a single coherent model — that agents can engage with, that stays current, and that can be reasoned against?**

This is a genuine knowledge-representation problem, and it's the hardest unsolved piece. Everything else (dashboards, cost tracking, agent spawn) is tractable engineering on top of this foundation. The 9-section schema above is a first-pass skeleton — the hard work is filling it in operationally and making it machine-legible.

## Product-category analogy and vocabulary UX

The product-category analogy (command-and-control systems — military ops centers, trading floors, air traffic control) and the vocabulary UX principle (precise terms stay internal; UX speaks in sensations) both live in `positioning.md`. They apply to the product surface built on top of this infrastructure; they don't belong in the requirements spec.

## Defensibility

Among the five CSFs, **signal extraction from agent output** (intake) is:
- The hardest to productize
- The least solved currently
- The most defensible if done right

Dashboards, cost tracking, agent spawn — tractable engineering problems anyone can replicate. Intake requires modeling what's decision-relevant to this specific operator in this specific universe — compounding advantage as the system learns the operator's judgment surface.

## The insight this reduces to

**The product that solves cognitive leverage is the one that makes the operator's entire world machine-readable — then reasons over it on their behalf.**

Every CSF is a subproblem of that. Every product-category analogy (C2 systems) exists because that pattern has been required in other domains for a long time. Knowledge work is catching up.
