# The Chat System: Embedded LLM Orchestration for Applications

A complete reference for building context-aware, tool-using chat systems embedded in production applications. This document covers the motivating principles, the architectural pattern, and the concrete implementation details — including a walkthrough of every configuration surface.

---

## Part 1: Why This Pattern Exists

### The Opportunity

All knowledge work reduces to sequences of atomic cognitive operations: search, extraction, summarization, classification, analysis, comparison, synthesis. LLMs can now execute these operations — and, critically, they can participate in planning which operations to execute. This is what makes agentic systems possible.

But LLMs have three structural shortcomings that don't go away with better models:

**The Memento Effect.** No persistent memory. Finite context window. The model doesn't know what it doesn't know — and when it's planning, that means it confidently skips steps it didn't realize were necessary. Those errors are invisible.

**Satisficing.** Always in fast-thinking mode. Complex tasks get shallow treatment. Critical sub-decisions happen in passing rather than getting dedicated attention. You see this in the "do better" phenomenon — ask the model to improve its own output and it often does, significantly. The capability was there; nothing triggered it.

**No Ontological Grounding.** The model generates plausible text, not verified claims. "I've completed steps 1-3" is generated text about progress, not tracked progress. Plans are text about plans. Verification is what verification sounds like.

### The Remedy: Principled Orchestration

Six principles guide system design that accounts for these shortcomings:

1. **Decompose into Explicit Steps** — Don't let critical decisions happen in passing. Force each decision point into a dedicated step with focused context. *(Addresses satisficing.)*

2. **Curate Sterile Context** — Each step gets exactly what it needs. Not accumulated history, not everything that might be relevant — precisely what this operation requires. *(Addresses the Memento Effect.)*

3. **Externalize State and Control Flow** — Loops, counters, progress tracking, and conditional logic live outside the LLM. The system tracks reality; the LLM reasons about language. *(Addresses lack of grounding.)*

4. **Bound Before Delegating** — When you enter an agentic loop, the degrees of freedom should already be appropriate. That's defined by the instructions and tools you provide. Too broad a mandate is a design failure, not an agent failure. *(Contains all three problems.)*

5. **Encode Expertise in Tool Abstraction** — Higher-level tools encode "the right way to do this." Every decision point for an agent is a potential failure point. Three well-designed macro-capabilities beat ten micro-steps. *(Captures expertise.)*

6. **Quality Gates at Critical Junctions** — Verify outputs before proceeding. Don't trust the model's self-assessment. If step 3 fails, fix it before step 4. *(Catches failures before they propagate.)*

### How the Chat Pattern Applies These Principles

The chat system described in this document is a direct application of these principles to a specific problem: embedding an LLM assistant inside a multi-page application where the assistant must both help users navigate features and reason over their data.

| Principle | How It Manifests |
|---|---|
| Decompose | Two explicit modes (navigation vs. analytical) with different instruction paths |
| Sterile Context | Context builders produce fresh, page-specific context per request — never cached, never stale |
| Externalize State | Agent loop, iteration limits, scope binding, conversation persistence — all in code |
| Bound Before Delegating | Tool and payload resolution narrows the agent's capabilities to exactly what's appropriate for the current page/tab |
| Encode Expertise | The help tool, proposal pattern, and structured payloads encode domain expertise |
| Quality Gates | The proposal pattern is a structural human gate — the LLM cannot execute data changes |

---

## Part 2: The Two Modes of Chat

The system serves two fundamentally different use cases through a single interface:

### Navigation Mode

The LLM is a help copilot. It guides the user through the app's features. It must never improvise or speculate about how things work. It looks up answers via the help tool and defers to that content as source of truth.

The help tool is load-bearing infrastructure, not a nice-to-have. Without it, the LLM confidently describes features that don't exist.

**Expected flow:** User asks "how do I..." → Assistant calls `get_help` → Retrieves documentation → Explains to user.

### Analytical Mode

The LLM is a functional extension of the app. It reasons over the user's actual data, generates proposals, and uses tools to do original work.

**Expected flow:** User asks about their data → Assistant selects appropriate tool → Calls with correct inputs → Interprets results.

The global preamble explicitly frames both roles. This distinction is critical for troubleshooting — navigation failures and analytical failures have completely different root causes.

---

## Part 3: Core Architecture

### The Layered System

When a user sends a message, the system assembles a complete prompt from layered configuration:

```
1. GLOBAL PREAMBLE (System tab)
   DB override → code default
   Identity, tone, universal rules, two-mode framing

2. PAGE PERSONA (Pages tab)
   DB override → PageConfig.persona → fallback
   Page-specific behavior, task framing, constraints

3. CURRENT CONTEXT (from context builders)
   Generated live at request time
   User role, data state, UI state, selections, filters

4. CONVERSATION DATA MANIFEST
   Summaries of prior proposals (accepted/dismissed)
   Multi-turn consistency

5. CAPABILITIES (Tools + Payloads tabs)
   Resolved from registries based on page/tab/role
   Tool definitions + payload format instructions

6. HELP CONTENT (Help tab)
   Narrative + TOC, role-filtered, DB overrides
   When/why to use the help tool

7. FORMAT RULES
   Hard-coded
   SUGGESTED_VALUES, SUGGESTED_ACTIONS formats
```

### The Resolution Model

Everything resolves through a single pattern: **global + page + tab + subtab**.

The system knows where the user is via `PageLocation`:

```
PageLocation
  current_page:   "table_view"
  active_tab:     "data"
  active_subtab:  null
```

Tools, payloads, and instructions all resolve the same way:

```
Available = (all where is_global=True)
          + (page-wide declarations)
          + (tab-specific declarations)
          + (subtab-specific declarations)
```

This means a user on `table_view` with the `data` tab active gets a different capability set than one on the `schema` tab — without needing separate page configs.

### The Override Hierarchy

Everything has a code default. The database provides an override point via `ChatConfig`:

```
ChatConfig
  scope:       'page' | 'help' | 'system'
  scope_key:   identifier within scope
  content:     the actual value
  updated_by:  audit trail
```

Resolution order: **DB override → code default → global fallback.** Admins can customize without code deploys.

---

## Part 4: The Five Configuration Tabs

The admin UI exposes five tabs that correspond to the system's configuration surfaces. Each controls a different aspect of how the assistant behaves.

### 4.1 System Tab

**What it controls:** The foundation of all chat behavior — universal rules that apply everywhere.

**Key fields:**

| Field | Purpose | Default |
|---|---|---|
| Global Preamble | Identity, tone, uncertainty handling, query classification, critical rules | Hard-coded in code |
| Max Tool Iterations | Cap on tool calls per request (prevents runaway loops) | 5–10 |
| Guest Turn Limit | API rate limiting for unauthenticated users | 8 |

**The global preamble is the single most important configuration surface.** It sets:
- What the app is and what the assistant's role is
- The two-mode framing (navigation + analytical)
- Style rules (concise, no flattery, no boasting)
- Uncertainty handling (admit when unsure, don't hallucinate)
- Ambiguity handling (when to interpret vs. ask for clarification)
- Query classification hints (when to use help vs. data tools)
- Critical rules ("you are not a data source", "use the help tool for product questions")

**Common style/behavior fixes belong here:**

| Symptom | Preamble Fix |
|---|---|
| Too verbose | "Be concise. One paragraph unless more detail is requested." |
| Too complimentary | "Don't praise the user or say things like 'Great question!'" |
| Overconfident | "When uncertain, say so. Don't present guesses as facts." |
| Hallucination | "Only state facts you've verified via tools or help content." |
| Asks too many questions | "Make reasonable interpretations rather than asking for clarification." |

---

### 4.2 Pages Tab

**What it controls:** Per-page behavior — what the assistant knows about each page and what capabilities are available there.

Each page registers a `PageConfig`:

```
PageConfig
  context_builder:  function(context_dict) → LLM context string
  persona:          page-specific system prompt section
  tools:            [tool_name, ...]     — page-wide
  payloads:         [payload_name, ...]  — page-wide
  client_actions:   [ClientAction, ...]
  tabs:             {tab_name: TabConfig}
```

Each `TabConfig` can further specialize:

```
TabConfig
  tools:    [tool_name, ...]
  payloads: [payload_name, ...]
  subtabs:  {subtab_name: SubTabConfig}
```

**Context builders** are the mechanism for giving the LLM live awareness of application state. They run at request time and produce a markdown string describing what the user sees:

- Table name, column schema, row count
- Sample rows (structured)
- Currently selected rows
- Active filters, sort, pagination
- User role
- Form field values, modal state

**Design principle: If the user sees it on screen and it's dynamic, it should be in the context.** Without this, the LLM can't diagnose obvious issues ("why so few results?" when the answer is a narrow date filter).

**Page personas** specialize the assistant for each page. They define:
- What users do on this page
- What tools/capabilities are available
- Page-specific interpretation rules
- Task-specific constraints

Personas are DB-overrideable — admins can adjust page behavior without code deploys.

---

### 4.3 Tools Tab

**What it controls:** The actions the assistant can perform.

Each tool is a `ToolConfig`:

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

**Resolution:** `get_tools_for_page(location, user_role)` returns:

```
global tools + page tools + tab tools + subtab tools
  → filtered by user_role
    → converted to Anthropic API tool format
```

**Global vs. page-specific:**
- `is_global=True` (default): Available everywhere. Example: `get_help`, `search_web`.
- `is_global=False`: Only where explicitly added. Example: `compare_reports` (only on reports page).

**Tool execution flow:**

```
User message
  → LLM decides to call a tool
    → Agent loop executes the tool's executor
      → Tool returns ToolResult(text=..., payload=...)
        → LLM sees the text, formulates response
          → Frontend renders any payload as rich UI
```

**Streaming tools** can yield progress updates for long-running operations:

```python
async def execute_research(params, db, user_id, context):
    yield ToolProgress(stage="searching", message="Searching...", progress=0.2)
    results = await search(...)
    yield ToolProgress(stage="processing", message="Processing...", progress=0.8)
    return ToolResult(text="Found results", payload={...})
```

**The admin UI shows tools as view-only** — tool definitions require code changes because they include executable functions. But seeing what tools exist (and their descriptions) is essential for troubleshooting: if the assistant isn't doing something, the first question is whether the tool is available on that page.

---

### 4.4 Payloads Tab

**What it controls:** Structured data types that the assistant can produce — the mechanism for rich, interactive outputs.

Payloads serve two critical functions:
1. **Rich rendering** — Tool results and LLM outputs that display as interactive cards, tables, and diffs rather than plain text
2. **Human-gated data updates** — The proposal pattern, where the LLM expresses intent as structured data that the user must accept before anything executes

Each payload is a `PayloadType`:

```
PayloadType
  name:             identifier
  description:      human description
  schema:           JSON Schema for validation
  source:           'tool' | 'llm'
  is_global:        available on all pages?
  parse_marker:     text marker for extraction (LLM payloads)
  parser:           extract structured JSON from LLM output
  llm_instructions: when/how to produce this payload
  summarize:        create brief summary for conversation manifest
```

**Two sources of payloads:**

**Tool payloads** (`source="tool"`) — A tool returns structured data alongside its text result:
```python
return ToolResult(
    text="Found 15 articles matching your query...",
    payload={"type": "pubmed_search_results", "data": {...}}
)
```

**LLM payloads** (`source="llm"`) — The LLM outputs a marker in its text that gets parsed:
```
LLM output: "Here's my proposed schema change:
SCHEMA_PROPOSAL: {"mode": "update", "operations": [...]}"

→ Backend finds SCHEMA_PROPOSAL: marker
→ Extracts and parses JSON
→ Validates against payload schema
→ Sends to frontend as structured payload
```

**The Proposal Pattern**

This is the most important architectural decision in the payload system. The LLM is never given direct write access to user data. When a conversation leads to a data change, the LLM must express its intent as a proposal:

```
LLM generates proposal (structured JSON)
  → Backend parses and validates
    → Frontend renders as interactive diff
      → User reviews: Accept or Dismiss
        → On Accept: frontend calls data API directly
          → Data API enforces its own validation
```

The LLM is completely out of the loop at execution time. This is not advisory — it's structural. There is no code path where the LLM's output is applied without human review.

**Key payload types in TableThat:**

| Payload | Source | Global? | Purpose |
|---|---|---|---|
| `schema_proposal` | LLM | No | Add/modify/remove/reorder columns, create tables |
| `data_proposal` | LLM | No | Add/update/delete rows |

**Resolution follows the same pattern as tools:** `global payloads + page payloads + tab payloads`.

**The admin UI shows payloads as view-only.** Like tools, payload definitions require code because they include parsers and schemas. But visibility is important for understanding what structured outputs the assistant can produce.

---

### 4.5 Help Tab

**What it controls:** The documentation that makes navigation mode trustworthy.

The help system is structured, role-filtered, and admin-overrideable:

```
HelpSection
  category:  'general' | 'tables' | 'data' | 'chat' | ...
  topic:     specific topic identifier
  title:     display title
  summary:   brief description (sent in TOC to LLM)
  roles:     ['member', 'org_admin', 'platform_admin']
  content:   full markdown
  order:     display order
```

**Data flow:**
1. YAML files define defaults (organized by category)
2. `HelpContentOverride` table stores admin customizations per topic
3. Help narrative and TOC preamble are configurable via `ChatConfig`
4. At runtime: `get_help_toc_for_role(role)` returns a filtered section list

**What the LLM sees:**
- A narrative explaining when and why to use the help tool
- A table-of-contents organized by category with summaries
- The ability to search/retrieve full content at runtime via the help tool

**The preamble explicitly instructs:** use the help tool for product questions, don't answer from training data.

**When navigation questions fail, this is usually what needs updating.** Common failures:

| Symptom | Cause | Fix |
|---|---|---|
| Answers from memory instead of calling help | Preamble doesn't emphasize help tool | Add to preamble: "always use get_help for product questions" |
| Calls help but can't find answer | Topic not in help content | Add topic to appropriate category |
| Finds help but explains it wrong | Content is ambiguous | Make help content more explicit |
| Says "I don't know" when help exists | Bad title/summary | Improve discoverability |

---

## Part 5: Runtime Protections

Beyond configuration, the system includes several runtime safeguards:

**Proposal Pattern** — Human reviews every destructive action before execution. The LLM never touches the write path.

**Max Tool Iterations** — Configurable cap (default 5–10) prevents runaway agent loops. If the LLM keeps calling tools without converging, it's forced to respond.

**Streaming + Cancellation** — The user sees real-time progress (status messages, tool starts, progress bars) and can abort at any time.

**Execution Traces (AgentTrace)** — Full diagnostic trace per message: what was sent to the model, what it responded, every tool call with inputs/outputs, token counts, timing. Three diagnostic views:
- **Messages** — Step-by-step execution (what happened)
- **Config** — What was available (tools, prompt, model)
- **Metrics** — Performance (iterations, tokens, timing, outcome)

**Token Budget Tracking** — Monitors context window usage. Warns when approaching limits.

**Conversation Scope Binding** — Each conversation is bound to a single scope (e.g., `"tables_list"` or `"table:42"`), preventing cross-contamination between unrelated contexts.

---

## Part 6: Diagnosing Failures

When something goes wrong, the diagnostic sequence mirrors the agent failure framework:

### Step 1: Classify the Question

Was this a **navigation** question (help/how-to) or an **analytical** question (data/tools)? The failure trees are completely different.

### Step 2: Walk the Failure Tree

**Navigation:**
```
Did assistant call get_help?
  NO  → Preamble doesn't classify well → Fix preamble
  YES → Did help return useful content?
          NO  → Missing help content → Fix help tab
          YES → Did assistant explain correctly?
                  NO  → Ambiguous content → Clarify help or persona
                  YES → Success
```

**Analytical:**
```
Did assistant call a tool?
  NO  → Doesn't know tools exist → Fix page persona
  YES → Right tool?
          NO  → Tool selection unclear → Fix persona or tool descriptions
          YES → Right inputs?
                  NO  → Misunderstood intent → Fix preamble/persona
                  YES → Tool return expected data?
                          NO  → Tool bug → Check diagnostics, fix code
                          YES → Interpreted correctly?
                                  NO  → Fix persona or domain instructions
                                  YES → Success
```

### Step 3: Identify the Fix Layer

| Problem | Fix Layer |
|---|---|
| Wrong question classification | System → Global Preamble |
| Wrong tool selection | Pages → Page Persona |
| Missing help content | Help → Add topic |
| Wrong interpretation | Pages → Persona or domain instructions |
| Tool bug | Code (tools) |
| Style/behavior issue | System → Global Preamble |

### The Deeper Diagnostic Framework

Most agent failures cluster into four categories, and you should work through them in order:

1. **Incoherent Inputs** — Instructions, context, and tools don't tell a consistent story. Most common, most fixable.
2. **Missing/Degraded Context** — The right information wasn't loaded. The LLM reasons confidently from an incomplete picture.
3. **Tool Failure** — The tool didn't return what it should have. Wrong data, timeout, malformed response.
4. **Genuine LLM Failure** — Everything was set up correctly and the model still went off the rails. Least common, least actionable.

Most debugging stops at category 1 or 2. That's where most of the leverage is.

---

## Part 7: What Makes This Extractable

The pattern separates into independently configurable concerns:

| Concern | Mechanism | Config Surface |
|---|---|---|
| What the LLM knows about the app | Help system + sync pipeline | Help tab |
| What the LLM can do | Tool registry + per-scope resolution | Tools tab |
| What the LLM sees | Context builders + conversation manifest | Pages tab |
| How the LLM responds | Payload types + format rules | Payloads tab |
| Who controls it | ChatConfig + admin UI + override hierarchy | System tab |
| Where the user is | PageLocation + PageConfig composition | Pages tab |

Each is independently configurable per page, per tab, per subtab, and per user role. The `ChatConfig` table provides a single, uniform mechanism for runtime customization across all of them.

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
| Tool Implementations | `tools/builtin/*.py` | Individual tool executors |
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
