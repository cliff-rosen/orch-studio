# Case Study — CEO Baseline (Pre-Agent)

A worked example of what a CEO of a small company is doing when operating well — *without agents in the mix*. Serves two purposes in the framework:

1. **Stress-tests the universe schema** (`universe-model.md`) against a concrete operator.
2. **Defines the pre-agent optimal** against which an agent-augmented system must be compared. If we can describe the pre-agent picture clearly, the agent system becomes a precise answer to a precise question: what changes, what gets augmented, what gets replaced, what remains irreducibly human.

Primary source: `sources/conv-5.md`.

---

## The universe boundary — a test of the schema

**Instinct**: "the universe is the company." Clean corporate boundary.

**Correct**: the boundary is functional, not organizational. If the CEO's spouse is materially relevant to outcomes — business partner, source of emotional stability that affects decision quality, manages household logistics that free cognitive capacity — they're in the universe. Not because of category, because of outcome-relevance.

This forces the schema to accommodate things that don't feel "professional" but are load-bearing.

### First pass at the CEO's universe

**Goals (top level):**
- Company survives and grows
- Team is effective and retained
- CEO remains capable of leading — cognitively, physically, financially
- Key relationships maintained and developed

**Ontology — entities in the universe:**
- The company itself — product, operations, finances
- Employees and their states
- Customers and pipeline
- Investors and board
- Vendors and partners
- Competitors (observable via signals; no write access)
- The CEO personally — health, capacity, finances
- The spouse — to the degree they affect any of the above
- The household — same logic

**Resources — initial inventory:**
- Company bank accounts and financial systems
- Email and calendar
- Product and codebase
- CRM and customer data
- Employee records and HR systems
- Legal documents and contracts
- CEO's personal finances (if entangled)
- Spouse's schedule and availability (if relevant to CEO capacity)
- Physical office, equipment
- **The CEO's own time and attention** — a resource in the registry
- Agent fleet — as resources

**Signals:**
- Financial dashboards
- Email and Slack inflow
- Customer feedback and churn indicators
- Team sentiment — formal and informal
- Market and competitor signals
- **The CEO's own energy and stress level** — a real signal

### Pressure points the schema must handle

- **The spouse question** — under what conditions are they in the universe? If they co-own the company, yes. If they manage the household that enables the CEO to function, arguably yes. If unrelated, no. The schema should represent the boundary explicitly, not just leave them out.
- **The CEO's personal health** — clearly relevant. Probably touches resources (capacity), state (current condition), and signals (energy/stress indicators). May need to live in multiple sections.
- **Competitors** — in the ontology but no write access. Observable partially through signals. Stress-tests the registry: a resource the operator can read weakly but not act on directly.
- **Agents as resources with schema access** — the agents are resources, and they also receive a projection of the schema. The loop needs clean representation without circularity.

## What the CEO is actually doing when operating well

At the highest level, the CEO is continuously solving one meta-problem:

> **How do I configure and direct the available resources — human, financial, systemic — so that the universe moves from its current state toward my goals, given everything that's happening and everything I can see?**

Everything they do is a sub-answer.

### Foundational decisions (designed once, revisited)

**Structural:**
- How the company is organized — what functions need to exist
- What gets built internally vs. bought vs. outsourced
- Who owns what — roles, accountability, authority
- Operating rhythms — when information flows, when decisions are made

**Systemic:**
- What tools and systems the company runs on
- How information gets captured and shared
- What processes make outcomes repeatable

These are the CEO designing the universe's operating system. Not daily decisions — but they shape everything downstream. A good CEO knows these are never truly done; they get revisited when the universe shifts enough that the current structure is no longer well-matched.

### Ongoing operating functions (seven, done simultaneously)

| Function | What the CEO is doing | CCC component |
|---|---|---|
| **Reading the universe** | Scanning signals — financial, human, market, operational. Maintaining accurate current picture of state. Continuously asking: "is what I believe about my universe still true?" | `CCC_intake` at universe scope |
| **Detecting gaps** | Noticing where state has diverged from goals. Some obvious (customer churned, cash tight), some subtle (culture drift, competitor gaining ground). | `CCC_intake` + pattern recognition |
| **Prioritizing** | Triage under uncertainty. What needs attention now, what can wait, what will resolve itself. | Part of `CCC_horizon` |
| **Configuring resources** | Hiring, firing, promoting, restructuring. Allocating budget. Choosing which initiatives get attention. Acting on the universe. | `CCC_outbound` |
| **Maintaining relationships** | Employees, customers, investors, partners. Partly signal gathering (relationships reveal what dashboards don't). Partly resource maintenance (relationships require investment to remain available). | `CCC_irreducible` (relational) |
| **Irreducible judgment calls** | Novel situations, high-stakes decisions, things that don't fit existing processes. Require direct pattern recognition and wisdom. | `CCC_irreducible` (novel judgment) |
| **Horizon scanning** | Looking ahead of current state — what's coming, what might change, what opportunities or threats are forming before they're visible in current signals. | `CCC_horizon` |

### Core tensions

The CEO continuously navigates:
- **Breadth vs. depth** — staying current on everything vs. going deep on what matters most
- **Reactive vs. proactive** — responding to what's happening vs. anticipating what's coming
- **Operating vs. designing** — running today's system vs. improving the system itself
- **Present vs. future** — delivering now vs. building for what's next

A great CEO navigates these tensions well. **Most CEOs get pulled toward reactive, operational, present-focused work because that's where the immediate pressure is — and the strategic, proactive, future-focused work quietly starves.** This is the gravitational pull.

## The cognitive portfolio problem (pre-agent)

Through the CCC lens, the CEO's pre-agent situation has a clean structural description:

- **C is roughly fixed.** Doesn't scale with the company.
- **Universe complexity grows as the company grows.** More entities, more relationships, more signals, more gaps.
- **The mix of demands is largely outside the CEO's control.** The universe generates them, not the CEO.
- **The highest-value uses of C (horizon scanning, structural design) are continuously crowded out by the most urgent (reactive gap-closing, relationship maintenance).**

So the CEO without agents faces a **cognitive portfolio problem**:
- Too many legitimate claims on C
- No mechanism to prioritize them systematically
- Strong gravitational pull toward reactive operational work at the expense of strategic proactive work

This is the problem the agent system solves — or more precisely, the cognitive bandwidth problem the universe schema + agent fleet is designed to reduce.

## What this tells us about where agents actually help

With the baseline in place, the question becomes precise:

> **Which claims on `C` can be reduced or eliminated, and which remain irreducible?**

The universe schema (`universe-model.md`) is the answer to: *what does the CEO need to maintain in their head right now, and how much of that can be externalized so `C` is freed for what only the CEO can do?*

The agent-augmented mapping — walk function-by-function through the seven ongoing operations and classify each as:
- **Fully delegable** — agents can do it as well or better; operator `x_i` contribution drops to near-zero.
- **Co-handled with tooling** — operator `x_i` contribution drops but doesn't vanish; `CCC_outbound` or `CCC_intake` portion of `x_i` reduces via architectural investment.
- **Irreducibly CEO** — lives in `CCC_horizon` + `CCC_irreducible`. Relationships, novel judgment calls, universe-model maintenance.

This mapping isn't yet done in the sources — flagged as an open question in `synthesis.md`.
