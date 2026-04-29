# Method — Harvest then Rebuild

Simple method. Two acts.

## Act 1 — Harvest

Read the source carefully, section by section. For each piece of content:

- Is it strong? → capture as a harvest item with `state: raw`, note why it works
- Is it weak / filler / repeating? → don't harvest. Implicitly cut.
- Is it good but underdeveloped? → harvest with `strength: good-but-needs-development`, note what's missing

Categories to watch for:
- **argument** — substantive logical moves
- **framing** — how something is set up / introduced
- **phrase** — specific sentences or wordings worth preserving
- **definition** — crisp explanations of a concept
- **structural-move** — how something is sequenced or organized
- **metaphor** — comparisons that land
- **example** — concrete instances that illuminate
- **summary** — compressions that work

Capture everything that's worth preserving, including stuff we may end up dropping later. Better to over-harvest now and prune at draft time than to lose something good.

## Act 2 — Rebuild

Once harvest is rich enough, write v1 of the new document:

- Decide the structure (probably close to cmr take 2's, but reorganize where the harvest suggests a better order)
- Use harvested items wherever they fit. Update each used item's state to `preserved` or `developed` (and `relocated` if it moved sections)
- Write transitions / connective tissue between harvested pieces. New writing happens in the gaps.
- Cut everything from cmr take 2 that wasn't harvested

Iterate v2, v3 as needed. Each version is a new row in `stores/versions` with a sidecar body.

## Stopping rule

When the draft reads tighter and lands harder than cmr take 2, mark the latest version `final`. Move to `wrapping-up`, then `archived`.

## Discipline

- **Don't add new sections.** We're refining, not expanding. If something seems to belong but isn't in cmr take 2, flag as escape and decide deliberately.
- **Don't synthesize across versions.** Earlier versions in `inputs` are context, not material. If a phrase from v1 deserves rescue, that's a deliberate decision; default is no.
- **Cut hard.** The point is "out with the bad." Don't sentimentally preserve.
