# The Chat System: Embedded LLM Orchestration for Applications

A complete reference for building context-aware, tool-using chat systems embedded in production applications.

---

## Part 1: The Three Essentials and a Cross-Cutting Pattern

Every agent call — every interaction where an LLM is expected to do useful work — depends on three inputs:

**Instructions.** What you're asking the LLM to do. The task definition, constraints, expected output format. Instructions tell the model what role it's playing and what a good result looks like.

**Context.** The information the LLM needs to reason about. Documents, data, conversation history, prior results — whatever the model needs to have in front of it to make informed decisions. An LLM can only work with what's in its context window. Everything else might as well not exist.

**Tools.** The capabilities the LLM can act through. Search functions, APIs, databases, calculation engines — the mechanisms by which the agent interacts with the world beyond generating text.

### The Cogency Requirement

Having all three isn't enough. They need to be **cogent** — and cogency is more demanding than it first appears.

Cogent inputs have five properties, forming a progressive chain where each assumes the previous ones hold:

1. **Coherent** — the inputs are unambiguous, internally consistent (they align with each other), and externally consistent (they are plausible given world knowledge). If the inputs are ambiguous or contradict each other, "correct" doesn't even mean anything.

2. **Correct** — the right instructions, the right context, the right tools for the actual goal. The inputs might form a perfectly clear picture and still be wrong — clear and wrong.

3. **Complete** — all the pieces are present for a coherent attempt from start to finish. Does the specification cover the full task? Are all necessary tools available? Do the instructions address every phase?

4. **Sufficient** — there is enough information to produce the right outcome for *this specific case*, not just a plausible one. A complete specification can still be insufficient when reality presents something it didn't anticipate.

5. **Dense** — the signal-to-noise ratio is high enough that the model can actually find what matters. The right information can be present and still fail to influence the output if it's buried in noise.

### Payload Type Definitions: A Pattern That Cuts Across the Essentials

Most of what shapes an agent's behavior falls cleanly into one of the three essentials. But some patterns cut across them. The most important in this system is the **payload type definition** — a formal structure that prescribes what a domain object looks like: its fields, types, constraints, valid values.

A payload type definition is simultaneously instruction and context. As instruction, it tells the LLM: "when you produce this kind of object, this is the shape." As context, it teaches the LLM what a domain entity *is* — the definition for a `data_proposal` with operations like add/update/delete, each with typed fields, tells the LLM what a data modification looks like in this system. A payload type definition is also an extraordinarily dense artifact — it encodes a large amount of domain knowledge about how the system models its entities in a compact, formal structure. Maximum information per token.

This pattern — prescribed type definitions that function as both instruction and compressed domain knowledge — is the foundation of the **payload system** described in Part 4. The three essentials describe what the LLM needs as inputs. Payload type definitions address what happens when the LLM (or a tool) needs to produce structured domain objects as output — and they do it by threading back into instructions and context rather than sitting outside them.

(A note on terminology: the word "schema" appears in two senses in this system. A payload type definition *has* a schema — the prescribed structure that constrains the shape of the output. But some payloads *contain* schemas as their content — for example, when the LLM proposes a table structure, the payload's content is itself a schema. The first sense is a constraint flowing *to* the LLM. The second is knowledge flowing *from* the LLM. Part 4 explores this distinction.)

### Why Cogency Matters More for Agents Than Humans

A human analyst given messy inputs would push back: "What exactly do you want here?" "These two requirements contradict each other." An LLM doesn't. It takes whatever you gave it and produces output. It doesn't have a threshold for "this doesn't make sense, I should stop."

An LLM isn't reasoning about truth. It's finding the strongest pattern in whatever you gave it. If you gave it a cogent picture, it finds the right pattern. If you gave it a mess, it finds the best pattern available in the mess — which looks fluent, sounds confident, and is wrong. The output isn't random garbage. It's a perfectly reasonable response to the wrong inputs.

The cogency requirement exists because the LLM won't create it for itself. With a human, you can be sloppy and they'll compensate. With an agent, whatever you put in comes out the other side — transformed into fluent, confident output regardless of whether the inputs warranted that confidence.

---

## Part 2: Principles That Shape the System

The chat system described in this document is designed around three principles, each directly motivated by the cogency requirements.

### Bound Before Delegating

When the LLM runs, its degrees of freedom should already be appropriate. This system applies that principle at three levels, from broadest to narrowest:

**1. Constrain the reasoning strategy.** An LLM has two paths for any factual question: look it up via a tool, or answer from training knowledge. The training data path is faster, more confident, and wrong more often — the LLM has no way to distinguish what it "knows" accurately from what it'll hallucinate. The global preamble explicitly closes this degree of freedom: "you are not a data source," "use the help tool for product questions," "use retrieval tools for factual claims." This forces the LLM through grounded, verifiable channels. The LLM's world knowledge doesn't disappear — it still informs how the LLM interprets results, formulates queries, and reasons about context — but it's not treated as a source of truth.

**2. Constrain which tools and payloads are available.** The system knows where the user is (`PageLocation`) and assembles exactly the right capabilities for that location:

```
Available tools    = global tools + page tools + tab tools → filtered by role
Available payloads = global payloads + page payloads + tab payloads
Instructions       = global preamble + page persona + format rules
Context            = page context builder output + conversation manifest
```

A user on the `table_view` page with the `data` tab active gets a different capability set and different context than one on the `schema` tab — automatically. The LLM doesn't choose what tools it has or what context it sees. The system decides, based on where the user is and who they are.

**3. Constrain how tools execute.** Even after the LLM selects a tool, the tool itself enforces workflow structure. This is the subject of the next section.

Each level narrows the degrees of freedom further. The preamble says *use tools, not training knowledge*. The resolution model says *these specific tools, on this page, for this role*. The tool design says *this specific workflow, with these enforced steps*. By the time the LLM is actually doing work, the space of possible actions has been narrowed from "anything an LLM can do" to "exactly what's appropriate for this user, on this page, through verified channels."

This addresses **coherence** (instructions, context, and tools are aligned by construction — the system can't assemble a persona that references tools it didn't provide), **correctness** (the right instructions and tools for the actual task, derived from the user's real state rather than guessed), and **external consistency** (factual claims flow through grounded retrieval rather than unverifiable training knowledge).

### Encode Expertise and Enforce Workflows in Tools

Tools aren't just API wrappers. They can be that, but they can also be where you move workflow logic out of the LLM and into deterministic code. The LLM decides *what* to do; the tool enforces *how* it gets done.

Every decision point for an agent is a potential failure point. Instead of giving the LLM raw capabilities and hoping it manages a coherent process, you build tools that encapsulate the correct workflow — including iteration, strategy enforcement, and multi-step sequencing.

**Research tools.** Instead of giving the LLM `search_web` and `fetch_webpage` and hoping it manages a coherent research process, a `research_web` tool encapsulates the full workflow. Internally, it runs its own agent loop with enforced structure: the first step *must* be a search (forced via `tool_choice`), middle steps allow free exploration, and when steps are exhausted the tool *forces* a structured answer submission. The LLM inside the tool does the cognitive work — evaluating results, deciding what to fetch — but the workflow skeleton is deterministic. Thoroughness levels (exploratory vs. comprehensive) control step budgets and token allocations, enforced in code.

**Enrich column.** Two layers of externalization. First, the tool iterates across a fixed row set using `asyncio.gather` with semaphore-based concurrency — the LLM doesn't track which rows it has processed or manage parallelism. Second, once a strategy is specified (lookup, research, computation, Google Places), the strategy is enforced through a class hierarchy with a shared `RowStrategy` base. Each strategy defines its own `execute_one()` method with its own step limits and validation. The LLM can't drift mid-execution or switch strategies partway through.

**The help system.** The `get_help` tool is another example of this principle. Product knowledge is organized into a structured, searchable repository with role-filtered access. The LLM doesn't answer product questions from training data. It calls a tool that retrieves vetted documentation. The entire "navigation mode" of the chat — answering "how do I..." questions — is implemented as a tool with an enforced workflow: scan TOC, identify topic, retrieve content, explain.

This addresses **coherence** (the workflow is internally consistent by construction, not by LLM compliance), **correctness** (the right process is baked in, not hoped for), and **completeness** (the tool covers all phases of the workflow, including edge cases the LLM might skip).

### Curate Context for Density and Freshness

Each request gets exactly the context it needs — assembled fresh, never cached, with explicit density management.

**Context builders** run at request time and transform current application state into structured context for the LLM. On the `table_view` page, the context builder produces: table name, column schema, row count, sample rows, selected rows, active filters, sort state, user role. The context is always live — pulled from current state, never stale.

Design principle: **If the user sees it on screen and it's dynamic, it should be in the context.** Without this, the LLM can't diagnose obvious issues ("why so few results?" when the answer is a narrow date filter).

**The payload manifest** solves a specific density problem: prior structured outputs (proposals, search results, enrichment results) are valuable for multi-turn consistency but expensive in tokens. The manifest provides a lightweight index — brief summaries of what was generated in prior turns — that's always present. The LLM can retrieve full payload data on demand. This keeps prior work accessible without flooding the context window.

**The help TOC** applies the same pattern for product knowledge. A category-organized table of contents with summaries is always in the system prompt. Full help content loads only when the LLM calls the help tool for a specific topic.

This addresses **density** (the context window contains signal, not noise), **sufficiency** (the information is accessible when needed, even if not loaded by default), and **coherence** (fresh context means the LLM reasons from current state, not stale data).

---

## Part 3: How It Works — Instructions, Context, Tools

### Instructions

Instructions are assembled in layers, each with its own override mechanism:

**Global preamble** (System tab) — The foundation. Identity, tone, uncertainty handling, critical behavioral rules. This is the single most important configuration surface. It sets what the app is, the assistant's role, style rules, and classification guidance (e.g., when to use the help tool vs. data tools).

**Page persona** (Pages tab) — Per-page specialization. What users do on this page, what capabilities are available, task-specific constraints. Each page gets a distinct persona because each page represents a different task domain.

**Format rules** — Hard-coded output conventions. How to structure suggested values, suggested actions, and payload markers. Not configurable because consistency is more important than flexibility here.

**The override hierarchy:** Everything has a code default. The database provides an override point via `ChatConfig`:

```
ChatConfig
  scope:       'page' | 'help' | 'system'
  scope_key:   identifier within scope
  content:     the actual value
  updated_by:  audit trail
```

Resolution order: **DB override → code default → global fallback.** Admins can customize preambles and personas without code deploys. When a latent gap surfaces — a scenario the original instructions didn't cover — an administrator can patch behavior in minutes.

### Context

Context comes from three sources, each addressing a different need:

**Page context builders** provide live application state. Each page registers a function that transforms the current UI state into a structured markdown string. Context is always fresh — built at request time, never cached.

```
table_view context builder produces:
  - Table name, column schema (IDs, names, types)
  - Row count, sample rows (first N, structured)
  - Currently selected rows
  - Active filters, sort, pagination
  - User role
```

**The conversation data manifest** provides multi-turn awareness. It carries forward summaries of structured outputs from prior messages — what proposals were made, what was accepted or dismissed. This gives the LLM awareness of prior actions without loading full payload data into every turn.

**The help TOC** provides lightweight product knowledge. A category-organized index with summaries is always present. Full content is retrieved on demand via the help tool.

### Tools

Tools are registered centrally and resolved per request:

```
ToolConfig
  name:           unique identifier
  description:    what it does (sent to LLM)
  input_schema:   JSON schema for parameters
  executor:       async callable
  category:       'general' | 'research' | 'data' | ...
  is_global:      available on all pages?
  payload_type:   structured data it returns (references PayloadType by name)
  required_role:  role-gated access
```

**Resolution:** `get_tools_for_page(location, user_role)` returns global tools + page tools + tab tools + subtab tools, filtered by role, converted to Anthropic API format.

**Global vs. page-specific:**
- `is_global=True` (default): Available everywhere. Example: `get_help`, `search_web`.
- `is_global=False`: Only where explicitly added to a page or tab config. Example: `enrich_column` (only on `table_view`).

**Streaming tools** can yield progress updates for long-running operations. An async generator yields `ToolProgress` events (stage, message, progress percentage) before returning a final `ToolResult`. The frontend renders these as real-time progress indicators.

**Tool execution flow:**

```
User message
  → LLM decides to call a tool
    → Agent loop executes the tool's async executor
      → Tool yields ToolProgress events (streamed to frontend)
      → Tool returns ToolResult(text=..., payload=...)
        → LLM sees the text result, formulates response
          → Frontend renders any payload as rich UI
```

---

## Part 4: Payloads — The LLM as a Producer of Domain Objects

Part 1 introduced payload type definitions as a pattern that cuts across the three essentials — the prescribed structure that constrains output shape and teaches the LLM what domain entities look like. This section unpacks the full mechanism: why the LLM needs to produce structured domain objects in the first place, why payloads are the right solution, and what they enable.

### The Multiple Roles of the LLM

The LLM plays several distinct roles in this system:

1. **Natural language gateway** — It makes natural language a viable interface. The user says what they want in plain English; the LLM interprets.

2. **Reasoning and planning** — It evaluates what to do, what tools to call, how to interpret results, how to respond.

3. **Tool caller** — As part of reasoning and planning, it invokes external capabilities: search, database access, computation, help retrieval.

4. **World knowledge bank** — It has broad training knowledge, though the system explicitly discourages relying on this in favor of grounded retrieval via tools.

5. **Built-in tool** — The LLM itself can do substantive work: designing a table structure, composing a data modification, drafting a structured query. This is original cognitive output — not routing, not summarizing tool results, but generating domain objects from its own capability.

Roles 1–4 are well-understood and well-served by the standard model of instructions, context, and tools. Role 5 is what makes payloads necessary.

### Why Not Just Use a Tool?

When the LLM needs to search the web, it calls `research_web`. When it needs to look up help documentation, it calls `get_help`. So why doesn't it call a `generate_proposal` tool when it needs to propose a table structure or a data modification?

Two reasons.

**First, the work is inseparable from the conversational reasoning.** A proposal isn't a separate task you can farm out — it emerges from the conversation itself. The LLM's understanding of what the user wants, what columns make sense, how to structure the table — that understanding is built up across the conversation and lives in the current context window. If you routed this through a tool, you'd have to re-supply all of that context to the tool's own LLM call. You'd be paying the cost of a second invocation to duplicate work the first LLM is already positioned to do.

**Second, the kind of knowledge involved is different from factual data.** Part 2 established that the system explicitly discourages the LLM from using its training knowledge as a source of factual claims — that's what tools are for. But consider what the LLM is actually doing when it proposes a table structure for tracking restaurants: it's drawing on structural, ontological knowledge — knowing that restaurants have names, cuisines, price ranges, ratings. Or when it composes a data modification: it's reasoning about how the user's request maps to specific row operations given the current table state. This kind of knowledge is more evergreen than factual data, more generalizable, and it's exactly the kind of pattern-recognition LLMs excel at. The "don't use training knowledge" constraint applies to claims about the world that could be wrong or stale. It doesn't apply to structural reasoning about how to organize information, or to reasoning about operations on data the LLM already has in context.*

This gives us a principled distinction about when to use tools vs. when to let the LLM work directly:

- **Use a tool** when the work requires capabilities the LLM doesn't have (search, database access, computation), when the workflow should be enforced externally (research steps, row iteration), or when domain-specific knowledge is required that the LLM's general training doesn't cover.
- **Let the LLM work directly** when the work is conversational reasoning that's inseparable from the current context, and when the knowledge required is structural/ontological rather than factual.

*\* There are cases where even structural content generation should go through a tool — specifically when domain verticalization requires outputs grounded in specialized knowledge rather than the LLM's general training. The system is being enhanced to support this, routing generation through domain-specific tools when the context calls for it.*

The problem is that "let the LLM work directly" normally means you get unstructured text. The LLM designs a great table structure... and expresses it in a paragraph, or a bullet list, or an inconsistent hybrid. The frontend can't parse it. You can't validate it. You can't render it as an interactive preview.

### What Payloads Do: Container and Content

Payloads solve this by **capturing the LLM's own work as typed, validated domain objects** — subjecting them to the same rigor as tool outputs.

There are two layers to understand, and they work in opposite directions:

**The payload type definition (the container)** is the cross-cutting pattern introduced in Part 1. It's prescribed by the developer and flows *to* the LLM as constraint and knowledge. The definition for a `schema_proposal` specifies that it must have a `mode` (create/update), an array of `operations` (each typed — add, modify, remove, reorder), each with required fields. This definition simultaneously acts as instruction (telling the LLM the exact shape its output must take) and as compressed domain knowledge (teaching the LLM what a schema change *is* in this system — what operations exist, what fields they require, what values are valid). It's an extraordinarily dense way to convey both "what to produce" and "what this kind of domain object means."

**The payload content (what the LLM fills in)** is knowledge and reasoning flowing *from* the LLM. When the LLM proposes a table with columns for name, cuisine, and price range — that content is the LLM's own work product, drawing on its structural knowledge and the conversational context. The container constrains the shape; the LLM supplies the substance.

In some cases, this creates a schema-of-a-schema situation: the payload type definition prescribes the structure of a `schema_proposal`, and the LLM's content within that structure is itself a proposed table schema. The container and the content are both "schemas" in different senses — one is a design-time constraint, the other is the LLM's runtime output.

This is the bounding principle applied on a new axis. Tools narrow degrees of freedom on the **action** side — what the LLM can do. Payload type definitions narrow degrees of freedom on the **output** side — the shape of the domain objects the LLM produces. Together they bound the agent on both sides:

- **Tools** = constrained actions
- **Payload type definitions** = constrained output shape

And everything downstream — validation, custom rendering, manifests, the proposal pattern — is only possible *because* the output conforms to a prescribed structure. You can't build a human gate on unstructured text. You can't build a manifest summarizer on free-form descriptions. You can't build a per-type component registry on "whatever the LLM felt like producing."

### Two Sources, One System

Once you see payloads as typed domain objects the system can handle rigorously, it's natural that they can come from either source. Tools also produce domain objects — search results, enrichment data. The source doesn't matter. What matters is that the object conforms to a defined schema.

**Tool payloads** (`source="tool"`) — A tool returns structured data alongside its text result:

```python
return ToolResult(
    text="Found 15 articles matching your query...",
    payload={"type": "search_results", "data": {"articles": [...]}}
)
```

The text goes to the LLM for reasoning. The payload goes to the frontend for rich rendering. They're decoupled — the LLM gets what it needs to think, the UI gets what it needs to display.

**LLM payloads** (`source="llm"`) — The LLM outputs a marker in its text that the backend parses:

```
LLM output: "Here's my proposed schema change:
SCHEMA_PROPOSAL: {"mode": "update", "operations": [...]}"

→ Backend finds SCHEMA_PROPOSAL: marker
→ Extracts JSON, parses via registered parser
→ Validates against payload schema
→ Sends to frontend as structured payload
```

Each LLM payload type defines: a `parse_marker` (the text trigger), a `parser` (extraction function), and `llm_instructions` (explicit instructions for when and how to produce this payload, included in the system prompt when the payload type is active for the current page/tab).

### What Rigorous Domain Objects Enable

**Custom UX rendering and handlers.** Because each payload type is registered with a name and schema, the frontend maintains a handler registry that maps type names to React components. A `schema_proposal` renders as a live table preview with a Create Table button. A `data_proposal` renders as inline diffs in the table — green-tinted additions, amber-highlighted edits with hover tooltips, red strikethrough deletions — with per-row checkboxes and Accept/Dismiss buttons. Search results render as interactive cards. The rendering is specific to the domain object, not generic text formatting.

**The proposal pattern.** The LLM never has direct write access to user data. When a conversation leads to a data change, the LLM expresses its intent as a proposal payload. The frontend renders the proposal as a visual diff. The user accepts or dismisses. On accept, the frontend calls the data API directly — the LLM is completely out of the loop at execution time. This gate is structural, not advisory. There is no code path where the LLM's output is applied without human review. This is only possible because the proposal is a rigorous domain object the system can validate, render, and act on — not text it has to interpret.

**Manifests for density management.** Each payload type can define a `summarize` function that produces a brief summary (e.g., `"Schema proposal: 2 additions, 1 modification"`). These summaries form the conversation data manifest — a lightweight index of all structured outputs from prior turns. The LLM sees what happened (proposals made, accepted, dismissed) without the full payload data consuming context. Full data is available on demand.

### Payload Registration

All payload types are defined in a single registry — the single source of truth:

```
PayloadType
  name:             identifier (e.g., "schema_proposal")
  description:      human description
  schema:           JSON Schema for validation
  source:           'tool' | 'llm'
  is_global:        available on all pages?
  parse_marker:     text marker for extraction (LLM payloads)
  parser:           extraction function
  llm_instructions: when/how to produce this payload
  summarize:        brief summary for manifest
```

Payloads resolve the same way tools do: `global payloads + page payloads + tab payloads`. Definitions are pure — they describe what a payload is, not where it's used. Pages declare which payloads they use by name.

---

## Part 5: The Config Tabs (Reference)

The admin UI exposes five tabs corresponding to the system's configuration surfaces. Now that the architecture is clear, here's what each controls practically.

### System

The global foundation. Key fields:

| Field | Purpose | Default |
|---|---|---|
| Global Preamble | Identity, tone, uncertainty handling, critical rules | Code default |
| Max Tool Iterations | Cap on tool calls per request | 5–10 |
| Guest Turn Limit | Rate limiting for unauthenticated users | 8 |

Common behavior fixes applied here:

| Symptom | Fix |
|---|---|
| Too verbose | "Be concise. One paragraph unless more detail is requested." |
| Too complimentary | "Don't praise the user or say things like 'Great question!'" |
| Overconfident | "When uncertain, say so. Don't present guesses as facts." |
| Hallucination | "Only state facts you've verified via tools or help content." |

### Pages

Per-page behavior. Each page registers a `PageConfig` with: context builder, persona, page-wide tools and payloads, tab configs, client actions. Personas are DB-overrideable.

The context builder is the critical piece — it's what gives the LLM live awareness of application state for that page.

### Tools

View-only in admin. Shows all registered tools with names, descriptions, input schemas, categories, and global/page-specific scope. Essential for troubleshooting: if the assistant can't do something, check here first.

### Payloads

View-only in admin. Shows all registered payload types with names, schemas, sources, scope, and (for LLM payloads) parse markers and instructions. Understanding what structured outputs the assistant can produce.

### Help

Editable documentation organized by category and topic. Role-filtered. Admin can override defaults per topic. The help tool retrieves from this system at runtime.

When "how do I..." questions fail, this is usually what needs updating.

---

## Part 6: Runtime Protections and Diagnostics

### Runtime Protections

**Proposal pattern** — Human reviews every data mutation before execution. Structural, not advisory.

**Max tool iterations** — Configurable cap prevents runaway agent loops.

**Streaming + cancellation** — Real-time progress via SSE (status messages, tool starts, progress updates). User can abort at any time.

**Execution traces (AgentTrace)** — Full diagnostic record per message: system prompt, each iteration's input/output, every tool call with inputs/outputs/timing, token counts. Three views: Messages (what happened), Config (what was available), Metrics (performance).

**Token budget tracking** — Monitors context window usage, warns at threshold.

**Conversation scope binding** — Each conversation bound to a single scope (e.g., `"table:42"`), preventing cross-contamination.

### Diagnosing Failures

When something goes wrong, work through the cogency requirements in order:

1. **Are the inputs coherent?** Unambiguous? Do instructions, context, and tools align with each other? Plausible given world knowledge?
2. **Are the inputs correct?** Right instructions, context, and tools for the actual goal?
3. **Are the inputs complete?** Can the agent make a coherent attempt from start to finish?
4. **Are the inputs sufficient?** Enough information for the right outcome in this specific case?
5. **Are the inputs dense enough?** Signal-to-noise ratio high enough for the model to find what matters?
6. **Did the tools work?** Did every tool call return expected results? Soft failures (well-formed but wrong data) are the most dangerous.
7. **If all six were fine** — genuine LLM failure. Note it, add a quality gate, move on.

Most debugging resolves at steps 1–5. That's where most of the leverage is.

**Practical diagnostic entry points:**

| Problem | First place to look |
|---|---|
| Wrong question classification | System → Global Preamble (coherence) |
| Wrong tool selection | Pages → Persona or tool descriptions (correctness) |
| Missing help content | Help tab (completeness) |
| Shallow or wrong analysis | Context builder output (sufficiency/density) |
| Tool returned bad data | Execution trace → tool call details (tool failure) |
| Style/behavior issue | System → Global Preamble |

---

## Appendix A: Entity Relationships

```
DEFINITIONS (don't know about pages)
  PayloadType  — name, schema, source, is_global, parse_marker, parser, llm_instructions
  ToolConfig   — name, input_schema, executor, is_global, payload_type (ref)

         │ referenced by name
         ▼

CONFIGURATIONS (how pages use them)
  PageConfig   — context_builder, persona, tools[], payloads[], tabs{}
    TabConfig  — tools[], payloads[], subtabs{}
      SubTabConfig — tools[], payloads[]
```

Definitions are pure — they describe *what* something is, not *where* it's used. Pages declare what they use by referencing definitions by name. This keeps definitions reusable and pages composable.

## Appendix B: System Prompt Assembly Order

```
1. Global Preamble        — from ChatConfig(scope='system') or code default
2. Page Persona           — from ChatConfig(scope='page') or PageConfig.persona
3. Current Context        — from context_builder(request.context)
4. Conversation Data      — payload manifest from prior messages
5. Capabilities           — resolved tools + payload instructions
6. Help                   — narrative + TOC, role-filtered
7. Format Rules           — hard-coded (SUGGESTED_VALUES, SUGGESTED_ACTIONS)
```

## Appendix C: Key Implementation Files (TableThat)

| Category | File | Purpose |
|---|---|---|
| Page Config Framework | `services/chat_page_config/registry.py` | PageConfig, TabConfig, PageLocation, resolution functions |
| Page Configs | `services/chat_page_config/<page>.py` | Per-page context builders, personas, tool/payload declarations |
| Tool Registry | `tools/registry.py` | ToolConfig, registration, page-aware resolution |
| Tool Implementations | `tools/builtin/*.py` | Individual tool executors (research, enrich, search, etc.) |
| Payload Registry | `schemas/payloads.py` | PayloadType, registration, parsers, schemas |
| Streaming Service | `services/chat_stream_service.py` | System prompt assembly, SSE streaming |
| Agent Loop | `agents/agent_loop.py` | Tool execution, iteration control, trace collection |
| Persistence | `services/chat_service.py` | Conversation CRUD, scope management |
| Help Content | `help/chat.yaml` | YAML-based documentation defaults |
| Chat Types | `schemas/chat.py` | Message, Conversation, AgentTrace, stream events |
| Frontend Context | `context/ChatContext.tsx` | React state management |
| Frontend UI | `components/chat/ChatTray.tsx` | Main chat component |
| Admin Config | `components/admin/ChatConfigPanel.tsx` | Configuration UI |
| Frontend Types | `types/chat.ts` | TypeScript mirrors of backend schemas |
