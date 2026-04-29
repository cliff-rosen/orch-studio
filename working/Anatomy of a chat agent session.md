Anatomy of a chat agent session
The hierarchy
A session is the full lifespan of a user's interaction with the agent. It is identified by a session ID, and all accumulated state hangs off that ID. A session contains one or more turns. Each turn contains one or more iterations. The final iteration of every turn is a final answer to the user; all earlier iterations within that turn are tool calls.
What a turn receives
Every turn begins when the user sends a new instruction. The orchestration layer receives three things on the way in:

The session ID — the handle for everything the orchestrator already knows.
The new instruction — the user's message for this turn.
Fresh context — anything that has changed in the environment since the last turn. The user may have switched screens, toggled a setting, selected a different document, or otherwise altered the surrounding UI state. This delta is passed alongside the instruction, not buried inside it.

What the orchestrator assembles
Once the turn is in flight, the orchestrator uses the session state plus the fresh context to compose the turn's working materials:

A custom system prompt — assembled once per turn, conditioned on where the session is and what just changed. It is not a static template; it is a turn-specific composition.
A tool list — the subset of available tools that makes sense given the current session state and context. Tool availability is dynamic across the session.
The conversation history — the relevant prior exchange, drawn from session state and shaped to fit the turn.

These three artifacts — system prompt, tools, history — plus the new user instruction define the LLM's working context for this turn.
The LLM does not see the full session state
This is the crucial design point. The LLM is never handed the raw session state. The orchestrator deliberately curates what reaches the model: the right instructions in the system prompt, the right slice of history, the right subset of tools, the right context fragments — all selected based on the current state of the session.
This curation is where the LLM's degrees of freedom are intentionally reduced. An LLM given everything will use everything, often in ways that drift from what the situation calls for. By narrowing what the model sees to what the situation actually requires, the orchestrator constrains the space of possible behaviors and makes the desired outcome the path of least resistance. The system prompt tells the model who it is for this turn; the tool list tells it what it can do; the curated history tells it what matters from the past. Everything outside that frame is held back by the orchestrator, available to inform the composition of the turn but not exposed to the model directly.
The iteration loop
With the turn's materials assembled, the orchestrator enters an iteration loop:

Send the current LLM context to the model.
The model returns either a tool choice or a final answer.
If it is a tool choice: the orchestrator executes the tool, appends the tool call and its result to the conversation, and loops back to step 1.
If it is a final answer: the loop exits, the answer is returned to the user, and the turn is complete.

A turn may resolve in a single iteration (the LLM answers immediately) or may take many iterations (the LLM calls several tools before answering). The defining property of the final iteration is that it produces a final answer, not a tool call.
Turn output flows into session state
Every turn can generate output that is written back to session state — not just the final user-facing answer, but intermediate artifacts as well: tool results, derived facts, summaries, decisions, structured outputs, scratchpad reasoning the agent wants to preserve. All of it is captured and indexed against the session ID.
Subsequent turns then have access to this accumulated output, but again only through the orchestrator's curation. When preparing the LLM instructions for a later turn, the orchestrator decides what prior output to surface, in whole or in part, and in what form. A long tool result from turn three might appear verbatim in turn four, summarized in turn seven, and not at all in turn twelve — that decision sits with the orchestrator, conditioned on what the new turn needs. The session state is the durable record; what reaches the LLM on any given turn is a deliberately shaped projection of it.
Session state as the through-line
Session state accumulates from the first turn to the last. Every turn reads from it (to assemble system prompt, tools, and history) and writes back to it (the new exchange, tool results, intermediate artifacts, any state changes the agent makes on the user's behalf). State is not refreshed per turn — it grows. This is what makes a session a session rather than a sequence of independent requests: the agent's understanding of the user, the task, and the environment compounds across turns, while the LLM itself only ever sees the slice the orchestrator chooses to show it.