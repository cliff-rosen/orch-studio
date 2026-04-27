# Living Workspace Plugin

A Claude Code plugin that turns the file system into a browser-native workspace UX. The user runs `claude` in a terminal, opens a browser tab, and works there — no code editor required. Chat stays in the terminal where Claude Code already lives. The plugin is the *browser half* of a two-window experience.

## What it does

1. **Bootstrap.** Slash command spins up a local server, opens a browser tab. The tab is the workspace.
2. **Live render.** Watches the workspace folder; renders schemas, data, and views as Claude edits files.
3. **Contract enforcement.** Reads machine-readable contracts (schemas + state machine rules) and enforces them — only valid transitions appear, writes get validated, the substrate stays trustworthy across long sessions.

## What it isn't

- **Not a wrapped chat.** No chat panel in the browser, no relay of prompts. Wrapping chat turns this from a plugin into an application and absorbs Claude Code's distinctive feature.
- **Not a code editor replacement.** This is for knowledge workers whose substrate is documents, records, and views — not source code.
- **Not domain-specific.** The plugin knows nothing about competitive analyses, CRMs, or to-do lists. Domain shape is fabricated by Claude per workspace.

## The pattern

In the modes-of-chat-and-substrate framework, this is the **Chat-Driven App** pattern: chat handles writes, UI handles reads. Because the substrate is the file system — low-level enough that chat can fabricate higher-level structure on top of it — the same configuration is also a **Living Workspace**: building, using, and enhancing happen in one continuous session.

## Where to look next

- [`architecture.md`](./architecture.md) — design reference: components, storage, widgets, substrate types, lifecycle, process flows, open questions.
- [`schemas/`](./schemas/) — the plugin's canonical meta-schemas (`meta`, `goal`, `workflow`, `contract`, `view`) — JSON Schemas the plugin uses to validate any workspace.
- [`templates/`](./templates/) — what the plugin instantiates into a workspace (dashboard render template, workspace skeleton, substrate-type starter packs, contract patterns, view descriptor templates).
- [`../projects/master-todo/`](../projects/master-todo/) — worked example: a personal task-management workspace with populated goal, workflow, contracts, data, and a rendered dashboard.
