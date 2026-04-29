# Method — Personal To-Do

This is the orchestration pattern Claude follows during operating for a personal-todo workspace. Read this on every operating-phase turn after `manual.md`.

## The four rhythms

Personal task management has four rhythms. Each calls for different agent behavior.

### 1. Capture (the user is dropping new items rapidly)

Signal: short messages adding tasks. *"Add: email Sarah about Tuesday."* *"Buy birthday gift for mom."*

Behavior:
- **Don't interrogate.** Land the task at `state: inbox`. Don't ask follow-ups about priority, due date, area — the user is in capture mode and slowing them down loses captures.
- Infer the area only if obvious from context (e.g., "schedule dentist" → Health). Otherwise leave area empty; clarify later.
- Don't propose contract changes during capture. If the user mentions a field that doesn't exist (e.g., "Add a budget to this project"), note it but don't act — propose during the next process moment.

### 2. Process (the user is clarifying captured items)

Signal: longer messages, asking what's in inbox, working through the inbox. *"What's in inbox?"* *"Let me clean up the inbox."*

Behavior:
- Show inbox items.
- For each: ask focused questions to clarify — what's the next action? What state? Area? Project?
- Move items out of inbox to their real state (next / someday / dropped).
- Surface items that need to be linked to a project (multi-step) and create the project if needed.

### 3. Engage (the user is doing the work)

Signal: messages like *"Mark X done."* *"I started on Y."* *"Pause Z, waiting on Tom."*

Behavior:
- Just act. Move tasks through states (next → doing → done, etc.).
- Don't propose anything. Don't surface stuck items unless the user asks.
- Validate state transitions against the contract (e.g., refuse `doing → waiting` without `waiting_on` set).

### 4. Review (cadenced — weekly or on user prompt)

Signal: *"Weekly review."* *"What's stuck?"* *"What needs attention?"*

Behavior:
- Surface tasks in `waiting` state for >7 days.
- Surface tasks in `someday` for >30 days (decide: promote or drop).
- Surface tasks in `next` that haven't moved for >14 days (stale next list).
- Look for spine candidates: contexts/tags/fields that recur on >5 tasks but aren't formal contract fields. Propose promotion.
- Surface escapes (in `workspace/escapes/`) that haven't been resolved.

## Substrate-specific opinions

- **Resist new kinds.** This blueprint has Task, Project, Area. Don't propose new kinds (e.g., "Habit," "Goal") unless the user explicitly asks and the pattern recurs ≥3 times. ongoing-system stability beats expressive richness.
- **Don't enter `wrapping-up`.** Personal-todo has no shipping moment. Skip wrapping-up; archive directly when the user wants to retire the workspace.
- **Areas don't get done.** If the user proposes "completing" an area, push back — areas are ongoing. Maybe they want to mark a project done within the area.
- **Default new tasks to `state: inbox`.** Even if the user says "add and start." Process is a separate moment from capture; respect the rhythm.

## When the user goes off-method

The four rhythms are guidance, not enforcement. If the user wants to do something out-of-pattern (rapid restructure mid-capture, etc.), follow the universal manual: classify (is this changing the rules?), confirm if structural, act otherwise.

## Where the method shows up in the dashboard

- The kanban widget displays the four mid-rhythm states (next / doing / waiting / someday) prominently and de-emphasizes terminal states (done, dropped).
- The smart-table on the dashboard filters to open tasks (inbox / next / doing / waiting) by default.
- A "review prompt" component (TODO) surfaces during periodic review: *"It's been 7 days since your last review."*
