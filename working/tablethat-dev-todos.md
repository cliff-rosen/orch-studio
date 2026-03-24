# TableThat Chat System — Gap Bridging TODO

Priority: H = high (addresses dangerous/invisible failure modes), M = medium, L = low

## Validation Gaps

### 1. Tool Output Validation Layer [H]
**Failure modes:** Tool Failure (soft), Consistency (plausibility)
**Problem:** Tool results pass directly to LLM with no validation. Schema-compliant but wrong results propagate silently.
**Tasks:**
- [ ] Add `ToolResultValidator` interface in tool registry
- [ ] Implement validators for each tool:
  - Web search: check for empty results, error messages in response body, known bad patterns
  - Google Places: validate required fields present, check for "ZERO_RESULTS" status
  - Compute: verify output is numeric when expected, check for NaN/Infinity
  - Table data: confirm row counts match expectations, check for empty responses
- [ ] Add validation step between tool execution and LLM consumption in agent loop
- [ ] On validation failure: retry once, then surface error to LLM explicitly ("tool returned invalid results")
- [ ] Log validation failures in trace for pattern detection

### 2. Search Result Quality Assessment [M]
**Failure modes:** Consistency (plausibility), Correctness
**Problem:** Web search results incorporated without quality assessment. SEO-gamed or low-authority sources treated same as authoritative.
**Tasks:**
- [ ] Add source authority scoring (prefer .gov, .edu, known-good domains)
- [ ] Filter or deprioritize results from known low-quality sources
- [ ] For critical factual claims, require multiple corroborating sources
- [ ] Surface source URLs in tool result text so LLM can reference them

### 3. Proposal Validation Against Data Constraints [M]
**Failure modes:** Genuine LLM Failure, Correctness
**Problem:** Proposals reviewed by user only. No automated validation.
**Tasks:**
- [ ] Before presenting proposal to user, validate against:
  - Column type constraints (e.g., numeric column getting text)
  - Value range constraints (if configured)
  - Uniqueness constraints
  - Required field constraints
- [ ] Flag violations in proposal UI (red highlights alongside green change highlights)
- [ ] Add constraint definition capability to table schema

## Adaptivity Gaps

### 4. Agent Self-Assessment / Uncertainty Surfacing [H]
**Failure modes:** Sufficiency, Consistency (plausibility)
**Problem:** Agent never evaluates its own input quality. Proceeds regardless. Never asks "what am I missing?"
**Tasks:**
- [ ] Add optional pre-execution assessment step (configurable per page):
  - "Based on the context provided, what assumptions am I making?"
  - "What information might be missing?"
  - "How confident am I in this response?"
- [ ] Surface uncertainty markers in response (e.g., "Note: I don't have X, which could affect this analysis")
- [ ] Consider a confidence score on proposals
- [ ] Add to preamble: explicit instruction to flag when context seems insufficient

### 5. Adaptive Context Sampling [H]
**Failure modes:** Sufficiency, Density
**Problem:** Context builders include first N rows. Tasks about rows outside the sample get unrepresentative context.
**Tasks:**
- [ ] Add `query_table` tool — agent can request specific rows by filter criteria
- [ ] Add `get_table_stats` tool — summary statistics per column (min, max, mean, distinct count, nulls)
- [ ] Add `get_rows_by_ids` tool — fetch specific rows the agent identifies as relevant
- [ ] Reduce default sample size (leaner initial context) now that agent can pull more on demand
- [ ] Update page personas to instruct agent when to use these tools

### 6. Context Compression / Sterile Context [M]
**Failure modes:** Density, Completeness (long conversations)
**Problem:** Conversation history accumulates without compression. Long conversations become noisy.
**Tasks:**
- [ ] Implement compress-and-carry-forward for conversations exceeding N turns (e.g., 10)
  - Summarize prior turns into a concise context block
  - Preserve: decisions made, proposals accepted/dismissed, key facts established
  - Discard: tangents, failed attempts, conversational debris
- [ ] Add configurable compression threshold to system settings
- [ ] Preserve full history in DB (traces) but compress what goes into context window
- [ ] Consider per-step sterile context for tool-heavy operations

### 7. Dynamic Iteration Budgets [L]
**Failure modes:** Tool Failure, Genuine LLM Failure
**Problem:** Max tool iterations is a flat cap regardless of task complexity.
**Tasks:**
- [ ] Add `complexity_hint` to interaction types or derive from message analysis
- [ ] Map complexity to iteration budget:
  - Simple lookup/question: 2 iterations
  - Data modification: 3 iterations
  - Research/enrichment: 8-10 iterations
- [ ] Allow per-tool-call timeout configuration
- [ ] Surface iteration usage in trace metrics

## Consistency Gaps

### 8. Persona-Tool Consistency Enforcement [M]
**Failure modes:** Consistency (internal)
**Problem:** Consistency between persona text and available tools maintained by developer convention only.
**Tasks:**
- [ ] Add startup validation:
  - Parse tool names referenced in each persona text
  - Check against registered tools for that page
  - Warn on: tools referenced but not registered, tools registered but not referenced
- [ ] Add to CI/CD pipeline as a check
- [ ] Consider generating the "Available Tools" section of the persona automatically from the registry

### 9. Preamble Density Audit [L]
**Failure modes:** Density
**Problem:** Global preamble is ~1,067 lines. No mechanism to verify model attends to all sections.
**Tasks:**
- [ ] Audit preamble for:
  - Redundant sections
  - Rules that could be moved to page personas (more targeted)
  - Formatting that could be more concise
- [ ] Add preamble section importance weighting (critical rules first)
- [ ] Consider splitting into "always include" and "include when relevant" sections
- [ ] Test: create evaluation suite that checks model compliance with buried rules

## Operational Gaps

### 10. Admin Change Management [M]
**Failure modes:** Consistency, Correctness (for configuration changes)
**Problem:** Admin changes go live immediately. No preview, testing, or rollback.
**Tasks:**
- [ ] Add configuration versioning (store prior versions)
- [ ] Add "preview mode" — test a prompt change against sample inputs before going live
- [ ] Add one-click rollback to previous version
- [ ] Add audit log of who changed what and when
- [ ] Consider A/B testing capability for prompt changes

### 11. Automated Trace Analysis [L]
**Failure modes:** All (system-level pattern detection)
**Problem:** Traces capture everything but analysis is manual.
**Tasks:**
- [ ] Build trace aggregation dashboard:
  - Tool failure rates per tool, per page
  - Average iteration count per interaction type
  - Token budget utilization trends
  - Proposal acceptance/dismissal rates
- [ ] Automated anomaly detection:
  - Alert when tool failure rate exceeds threshold
  - Alert when average iterations spike
  - Alert when token budget warnings increase
- [ ] Add to admin panel as "System Health" tab
