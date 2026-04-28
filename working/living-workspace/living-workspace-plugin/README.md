# Living Workspace Plugin

A Claude Code plugin for end-to-end knowledge work that needs structure but has no off-the-shelf tool. You chat in your terminal, a structured substrate fills in on disk, and a browser dashboard shows it live. The plumbing — contracts, validation, rendering — handles itself.

## Why this exists

Chat apps are great for parts of knowledge work — answering a question, drafting a paragraph, exploring an idea. But for *end-to-end* knowledge work — producing a research synthesis, revising a document deliberately, maintaining a system that grows over time — chat alone has nowhere to put the work. There's no substrate. Inputs, works-in-progress, derivatives, outputs all live in your head or scattered across files you have to manage yourself. Real orchestration isn't possible.

Claude Code solves the substrate problem at the lowest level: it reads and writes your file system. That's enough — every artifact, every relationship, every state can live in files. But the file system is too primitive for most knowledge workers. You end up with chat plus a folder of opaque JSON and markdown. No views, no validation, no methodology — just the user and a gazillion files, with all the burden of figuring out what to do with them.

This plugin is the layer in between. It overlays Claude Code with:

- A **higher-level substrate** — structured stores (Tables, Documents, Calendars, Trees, Graphs) with contracts, validation, and references. Files mean something.
- A **live browser UI** — a dashboard that shows your workspace as it grows. Read-only in v0.
- **Methodology blueprints** — packaged orchestration patterns for typical knowledge-work shapes (document revision, research synthesis, decision logs, etc.). Optional starting points that come with both substrate and method.
- **A bootstrap conversation** — Claude walks you through articulating the goal and choosing the substrate. You don't start from a blank workspace and have to figure out the structure yourself.

The result is turnkey: you sit at your terminal, run `claude`, open a browser. You describe what you're working on. The plugin and Claude work out the structure together. As you work, the substrate fills in and the browser updates live. Everything is accessible the way you'd use a chat app — but with structure underneath that supports real start-to-finish knowledge work.

## What it does

1. **Bootstraps a workspace.** A slash command sets up the folder with initial structure — workspace contract, state, manual, and either a blank skeleton or a methodology-laden blueprint.
2. **Renders live.** A local server watches the workspace folder and renders a browser dashboard that updates as Claude edits files.
3. **Enforces contracts.** Every file change is validated against machine-readable contracts. Bad data doesn't get written; bad contracts don't load.

Chat stays in the terminal where Claude Code already lives. The plugin is the *browser half* of a two-window experience.

## Where to look next

- [`reference/index.html`](./reference/index.html) — user-facing reference covering the whole system. **Best place to start.**
- [`operating-model.md`](./operating-model.md) — top-down conceptual design.
- [`architecture.md`](./architecture.md) — detailed implementation reference.
- [`schemas/`](./schemas/) — the plugin's meta-schemas (validators).
- [`templates/`](./templates/) — what the plugin instantiates: workspace skeleton, blueprints, contract templates, components.
- [`../projects/`](../projects/) — worked examples.
