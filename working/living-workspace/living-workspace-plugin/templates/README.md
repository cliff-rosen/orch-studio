# Templates

Things the plugin instantiates into a workspace. Distinct from `../schemas/`, which holds the meta-schemas the plugin uses to *validate* workspaces.

## Layout

| Path | Purpose |
|---|---|
| `dashboard.template.html` | Canonical dashboard template. The plugin renders this with workspace data substituted in. |
| `workspace-skeleton/` | What `/scaffold` copies into an empty folder when a new workspace is created. Empty placeholder values; bootstrap conversation fills them. |
| `starter-packs/<substrate-type>/` | Per substrate type: default `workflow.json` + suggested contracts + default views. Loaded after the user picks a substrate type during bootstrap. |
| `contracts/` | Boilerplate contract patterns: stateless, stateful, hierarchical. Claude copies and customizes when introducing a new kind. |
| `views/` | View descriptor templates per widget type. Claude copies and customizes when creating a saved view. |

## Substrate-type starter pack contents

Each starter pack has the same shape:

```
<substrate-type>/
├── README.md            What this substrate is, when to use it.
├── workflow.json        Default workflow shape for this substrate.
├── contracts/           Suggested contracts (kinds + states + transitions).
└── views/               (optional) Default views for this substrate.
```

Status: `ongoing-system` exists. Others are open work — see architecture.md "Open questions → Most consequential."
