# Living Workspace Plugin

A Claude Code plugin that turns the file system into a browser-native workspace UX — so a knowledge worker can run `claude` in a terminal, open a browser tab, and have everything else happen there. No code editor required.

**Status:** Early. This README is stakes in the ground, not a spec. Architecture decisions documented here are deliberate but revisable; implementation has not started.

---

## What this is

A small plugin that does three things:

1. **Bootstrap.** Slash command from Claude Code spins up a local server and opens a browser tab. The tab is the workspace.
2. **Live render.** Watches the workspace folder and renders schemas, data, and views in the browser as Claude edits files in the terminal.
3. **Contract enforcement.** Reads machine-readable contracts (schemas + state machine rules) and enforces them at the rendering layer — only valid transitions appear, writes get validated, the substrate stays trustworthy across long sessions.

Chat stays in the terminal where Claude Code already lives. The plugin is the *browser half* of a two-window experience.

## What this isn't

- **Not a wrapped chat.** The plugin does not embed a chat panel, relay prompts, or wrap the Claude CLI. The moment you wrap chat, you've stopped shipping a plugin and started shipping an application — and you've absorbed Claude Code's distinctive feature (chat in a terminal). The terminal is intentionally preserved.
- **Not a code editor replacement for developers.** This is for knowledge workers whose substrate is documents, records, and views — not source code. Developers can keep using their IDE.
- **Not domain-specific.** The plugin understands schemas, contracts, and views generically. The competitive analysis, the spec, the personal CRM, the study planner — all fabricated by Claude in the running session, not built into the plugin.

## The pattern this enables

In the modes-of-chat-and-substrate framework, this is the **Chat-Driven App** pattern:

- Chat handles the writes (move state by description, in the terminal).
- UI handles the reads (browse, view, consume, in the browser).
- The user has whatever side-access the substrate naturally affords (open the folder in Finder, edit a file by hand if they want).

Because the substrate is the file system — low-level enough that chat can fabricate higher-level structure on top of it — the same configuration is also a **Living Workspace**: building, using, and enhancing happen in one continuous session. The plugin is the rendering half of that pattern made concrete for non-developers.

## The model's operating discipline

The plugin only earns its keep if Claude reasons in layers. The substrate layout and the slash commands are designed to keep Claude pinned to this discipline:

```
Goal → Workflow → Contract → Data → Views
```

- **Goal.** A short, durable anchor. *"Produce a competitive landscape memo for the April 30 strategy meeting, three named competitors, citation-disciplined."* Single artifact at the top of the workspace. Reread when orientation drifts.
- **Workflow.** The stages of work and the artifact-state at each. Often state-machine-flavored.
- **Contract.** Schema (kinds of objects, fields) plus rules (valid states, transitions, invariants). The load-bearing layer. Machine-readable so the plugin can enforce.
- **Data.** Instances of the schema, evolving per the contract. Folder-per-kind, file-per-instance.
- **Views.** Derived, not authored. Plugin ships generic views; custom views are HTML Claude generates against a known contract.

Operating rules:

1. **Bootstrap top-down.** First session, vague request: model elicits the goal, proposes a workflow, sketches a contract, gets buy-in *before* generating data or views.
2. **Classify every request.** *"Add credibility tag to sources"* is contract. *"Show items stuck in 'extracted' for 3+ days"* is view. *"It's a board deck now"* is goal. Classification determines propagation.
3. **Propagate top-down.** Goal change ripples through workflow, contract, data, views. Don't patch the bottom when the change is at the top.
4. **Flag schema-fit.** Real work generates objects that resist the current contract. Mark them *escapes* / *candidates*; don't mash them in.
5. **Identify spine.** As the substrate accumulates, propose what's load-bearing for promotion to contract.

## Substrate layout (provisional)

```
goal.md                 The anchor.
workflow.md             Stages, transitions, what exists at each stage.
contracts/
  source.contract.json  Schema + state machine + invariants.
  claim.contract.json
data/
  sources/
    src-001.json
  claims/
    cl-014.json
views/                  Mostly empty. Plugin renders defaults; Claude drops custom HTML here.
process.md              How the workspace evolved + key decisions (a paper trail).
escapes/                Things that don't fit the contract yet — flagged, not forced.
```

## What the plugin provides

**At the rendering layer:**
- Live file system watcher → WebSocket push to browser.
- Generic view primitives: list, detail pane, form, dashboard, kanban.
- A slot for Claude-generated custom HTML views, sandboxed and contract-aware.
- Navigation between workspaces, between views within a workspace.

**At the contract layer:**
- A contract format (JSON Schema for shapes + a declarative state-machine format for transitions).
- A validator the plugin runs on writes Claude makes through the substrate.
- View affordances driven by contract — only valid transitions surface as actions; required fields surface as form prompts; invariants surface as warnings.

**At the orchestration layer:**
- Slash commands that pin Claude to the right layer (e.g., a `/scaffold` to drive the bootstrap loop, a `/spine` to ask Claude to propose what's load-bearing).
- A workspace bootstrap — point at any folder and run.
- Optional: lightweight click-to-copy prompts on view actions, so the user can route browser intent into the terminal without a back channel into Claude Code's running session.

## Out of scope (for now)

- A back channel that injects prompts into the running Claude Code session. Standard Chat-Driven App behavior is enough for v1; the user types in the terminal.
- Multi-user collaboration. Single-user, single-machine.
- Hosted / cloud version. Local-first, file-system-native.
- Migrations between contract versions. We'll handle that when we hit it.

## Open questions

- **Slash command naming.** `/workspace`, `/canvas`, `/scaffold`, `/render`? Picking one that's intuitive without being too generic.
- **Contract format details.** JSON Schema is fine for shapes. State machines need a format — XState-style declarative? Custom? Looking at prior art.
- **View descriptor format.** How does Claude tell the plugin *"render this folder as a list with these columns"*? Probably a small declarative file per view.
- **Plugin packaging.** What does *"installing the plugin"* actually look like in the Claude Code plugin model? This determines what shape the deliverable is.
- **Browser ↔ server transport.** WebSocket is the obvious answer. Confirm no surprises around localhost permissions on different OSes.
- **Error visibility.** When a contract violation happens during Claude's work, how does the user find out? Surface in the browser, the terminal, or both?

## Working principles

- **The plugin understands no domain.** Schema, views, actions — fabricated by Claude per workspace. Plugin code is a generic substrate-renderer + contract-enforcer.
- **The terminal is the chat.** Don't wrap it.
- **Contracts are real.** Machine-checkable, plugin-enforced. If contracts are just prose, the substrate decays under long sessions.
- **Views are derived, not authored.** Generic primitives first; custom HTML only when the work calls for it.
- **The substrate is the source of truth.** The browser is a window onto it; closing the browser changes nothing.

---

## Next steps

1. Decide slash command naming and basic plugin packaging (Claude Code plugin manifest shape).
2. Pick a contract format and write a worked example for one domain (e.g., the competitive analysis).
3. Stub the local server, file watcher, and one generic view (list).
4. End-to-end smoke test: scaffold a workspace from chat, render it in the browser, watch it update as Claude edits.
