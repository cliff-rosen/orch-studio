# Chat Orchestration Pattern — Reference Architecture

Extracted from the TableThat implementation. This documents the key abstractions
and schemas that form a reusable pattern for building LLM-powered chat systems
embedded in applications.

---

## Design Premise: Two Modes of Chat

The system serves two fundamentally different use cases through a single chat interface:

1. **Navigation Mode** — The LLM is a help copilot. It guides the user through
   the app's features. It must never improvise or speculate about how things work.
   It looks up answers via the help tool and defers to that content as source of truth.

2. **Analytical Mode** — The LLM is a functional extension of the app. It reasons
   over the user's actual data, generates proposals, and uses tools (compute, search,
   data queries) to do original work.

The global preamble explicitly frames both roles and directs the LLM to the help
tool for navigation questions. This prevents the classic failure where the LLM
confidently describes features that don't exist.

The help tool is load-bearing infrastructure, not a nice-to-have. It requires a
sync/generation pipeline that keeps help content aligned with the actual codebase
and functionality.

---

## Core Abstractions

### 1. ChatConfig (Admin Override Table)

The universal override mechanism. Everything has a code default; the database
provides an override point so admins can customize without code deploys.

```
ChatConfig
├── scope:       'page' | 'help' | 'system'
├── scope_key:   identifier within the scope
├── content:     the actual text/config value
└── updated_by:  audit trail
```

**Scope examples:**
- `scope='page', scope_key='table_view'` → page persona override
- `scope='help', scope_key='narrative'` → help tool usage instructions
- `scope='system', scope_key='global_preamble'` → global system prompt

**Resolution order:** DB override → code default → global fallback.

---

### 2. PageConfig + PageLocation (Scope-Aware Composition)

The system knows where the user is and assembles everything accordingly.

```
PageLocation
├── current_page:   'table_view' | 'tables_list' | 'table_edit'
├── active_tab:     optional tab name
└── active_subtab:  optional subtab name
```

```
PageConfig
├── context_builder:  function(context_dict) → LLM context string
├── persona:          page-specific system prompt
├── tools:            [tool_name, ...]
├── payloads:         [payload_type_name, ...]
├── client_actions:   available UI actions
└── tabs:             {tab_name: TabConfig}
```

```
TabConfig
├── tools:    [tool_name, ...]
├── payloads: [payload_type_name, ...]
└── subtabs:  {subtab_name: SubTabConfig}
```

The hierarchy enables fine-grained capability control. A user on the "table_view"
page with the "data" tab active gets a different tool set than one on the "schema"
tab — without needing separate page configs.

---

### 3. Tool Registry (Per-Scope Resolution)

Tools are registered centrally and resolved per request based on page, tab, and user role.

```
ToolConfig
├── name:           unique identifier
├── description:    what the tool does (sent to LLM)
├── input_schema:   JSON schema for parameters
├── executor:       async callable
├── category:       'general' | 'research' | 'data' | ...
├── is_global:      if true, available on all pages
└── required_role:  role-gated access (e.g., 'platform_admin')
```

**Resolution:** `get_tools_for_page(location, user_role)` returns:
```
global tools + page tools + tab tools + subtab tools
  → filtered by user_role
    → converted to LLM tool format
```

---

### 4. Payload Types and the Proposal Pattern

Payloads are the mechanism for structured LLM outputs. But one of their most
important functions is enabling **human-gated data updates** — a deliberate
architectural choice about where the LLM's authority ends.

#### The key design decision

The LLM is never given direct write access to the user's data. It has no tool
that can insert, update, or delete rows. Instead, when a conversation leads to
a data change, the LLM is forced to express its intent as a **proposal** — a
structured payload that describes what it wants to change and why.

The proposal is sent to the frontend, which renders it as a visual diff
(green highlights for additions, inline changes for edits). The user reviews
and either accepts or dismisses.

**When the user accepts, the frontend calls a data endpoint directly.** The
LLM is completely out of the loop at execution time. It never touches the
actual write path. This means:

- The LLM cannot accidentally corrupt data through a malformed tool call
- The human gate is not advisory — it's structural. There is no code path
  where the LLM's output is applied without human review.
- The execution endpoint can enforce its own validation, constraints, and
  permissions independently of anything the LLM produced

#### PayloadType schema

```
PayloadType
├── name:             'schema_proposal' | 'data_proposal' | custom
├── description:      human description
├── schema:           JSON Schema for validation
├── source:           'tool' | 'llm'
├── is_global:        available on all pages?
├── parse_marker:     text marker for extraction (e.g., "SCHEMA_PROPOSAL:")
├── parser:           extract structured JSON from LLM output
├── llm_instructions: when/how to produce this payload
└── summarize:        create brief summary for conversation manifest
```

**Key payload types:**
- **schema_proposal** — add/modify/remove/reorder columns. Modes: 'create' or 'update'.
- **data_proposal** — add/update/delete rows using exact column IDs from context.

#### Data flow

```
LLM generates proposal (structured JSON in response)
  → Backend parses and validates against payload schema
    → Frontend renders as interactive diff
      → User accepts or dismisses
        → On accept: frontend calls data API directly (LLM not involved)
          → Data API enforces its own validation and applies the change
```

The LLM learns the outcome through the conversation manifest — it sees that
a proposal was accepted or dismissed — but it never participates in execution.

---

### 5. Help System (Grounded Navigation)

The help system is what makes navigation mode trustworthy. It's structured,
role-filtered, and admin-overrideable.

```
HelpSection
├── category:  'general' | 'tables' | 'data' | 'chat'
├── topic:     specific topic identifier
├── title:     display title
├── summary:   brief description (sent in TOC to LLM)
├── roles:     ['member', 'org_admin', 'platform_admin']
├── content:   full markdown
└── order:     display order
```

**Data flow:**
1. YAML files define defaults (organized by category)
2. HelpContentOverride table stores admin customizations per topic
3. Help narrative and TOC preamble are configurable via ChatConfig
4. At runtime: `get_help_toc_for_role(role)` returns filtered section list

**What the LLM sees:**
- A narrative explaining when and why to use the help tool
- A table-of-contents organized by category with summaries
- The ability to search/retrieve full content at runtime via the help tool

The preamble explicitly instructs: use the help tool for product questions,
don't answer from training data.

---

### 6. Context Builders (Live State → LLM Context)

Each page registers a function that transforms the current application state
into structured context for the LLM.

**What context builders produce (example: table_view):**
- Table name, column schema, row count
- Sample rows (first N, structured)
- Currently selected rows
- Active filters and sort
- User role

Context is always live — built at request time from current state, not cached.
This addresses correctness (never stale) and sufficiency (actual values, not
just schema).

---

### 7. Conversation Data Manifest

Carries forward structured outputs from prior messages in the conversation.
Gives the LLM awareness of what it already proposed and what the user
accepted or dismissed.

Used for multi-turn consistency — prevents contradicting prior actions in
the same conversation.

---

## System Prompt Assembly

The system prompt is assembled in layers, each with its own override mechanism:

```
1. GLOBAL PREAMBLE
   DB override (scope='system') → code default
   - What the app is
   - The two-mode role (navigation + analytical)
   - Critical rules ("you are not a data source")

2. PAGE INSTRUCTIONS
   DB override (scope='page') → PageConfig.persona → global fallback
   - Page-specific behavior, tone, constraints

3. CURRENT CONTEXT
   Generated by context_builder(context_dict)
   - User role, table schema, sample data, filters, selections

4. CONVERSATION DATA
   Payload manifest from prior messages
   - Summaries of previous proposals

5. CAPABILITIES
   Resolved from tool registry + payload types
   - Tool names + descriptions
   - Payload format instructions
   - Available client actions

6. HELP
   Narrative + TOC, role-filtered, with DB overrides
   - When/why to use the help tool
   - Category-organized topic listing

7. FORMAT RULES
   Hard-coded
   - SUGGESTED_VALUES format
   - SUGGESTED_ACTIONS format
```

---

## Runtime Protections

- **Proposal Pattern** — Human reviews every destructive action before it's applied
- **Max Tool Iterations** — Configurable cap (default 5) prevents runaway agent loops
- **Streaming + Cancellation** — User sees progress and can abort
- **Execution Traces** — Full trace per message (inputs, outputs, tool calls, tokens)
- **Token Budget Tracking** — Warns when context pressure exceeds threshold
- **Conversation Scope Binding** — Each conversation bound to a single scope, preventing cross-contamination

---

## What Makes This Extractable

The pattern separates cleanly into:

| Concern | Mechanism |
|---|---|
| What the LLM knows about the app | Help system + sync pipeline |
| What the LLM can do | Tool registry + per-scope resolution |
| What the LLM sees | Context builders + conversation manifest |
| How the LLM responds | Payload types + format rules |
| Who controls it | ChatConfig + admin UI + override hierarchy |
| Where the user is | PageLocation + PageConfig composition |

Each of these is independently configurable per page, per tab, and per user role.
The admin override table (ChatConfig) provides a single, uniform mechanism for
runtime customization across all of them.
