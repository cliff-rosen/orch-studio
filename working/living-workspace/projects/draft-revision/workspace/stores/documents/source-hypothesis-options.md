---
kind: source
title: "Aftershoot LLM-based Coach (hypothesis + options framing)"
order: 3
focus: false
parent: source-updated
created_at: "2026-04-28T15:00:00Z"
---

# Aftershoot LLM-based Coach

# Hypothesis

After reviewing the proposed product requirements document for an AI driven photo editing coach, we determined that training and building out novel models to support this may not be necessary.

**Hypothesis**: do currently available LLMs have enough general training to create the type of personalized photo editing lessons that will live up to Aftershoot's brand positioning of "helping you to learn how to become a better photo editor?"

# Options

## Option 1: create robust prompting to create the lesson experience

Issues:

- LLM will naturally either follow its own probabilistic (or maybe even stochastic) sequence or will follow the order of our sliders as they are in the app. Creating a detailed prompt that directs the LLM on which sliders to focus on in which sequence for which types of photos for which types of users will be long and complex and might not ultimately be followed.
- We rely almost completely on LLM judgment - very difficult to encode professional editing judgment into the experience
- Prompt-only approaches also force the LLM to do too much at once: interpret the image, choose the workflow, remember skill level, manage prior edits, enforce constraints, prevent overediting, and teach. That produces inconsistency.
- This will also generate large token costs.

## Option 2: create an orchestration-based system to manage the lesson experience

Build an AI-assisted photo editing system that helps novices produce visibly stronger images and learn to edit more effectively in the process. The system guides users through a structured, expert-informed workflow that adapts to the image, the user's skill level, the desired outcome, and the current stage of the edit.

Division of responsibility:

- **Methodology** — encodes professional photographic judgment (sequencing, tradeoffs, failure modes, when to stop).
- **Orchestration** — manages state, selects relevant methodology modules, enforces tool constraints, ensures repeatability.
- **LLM** — explains, recommends, and adapts conversationally.
- **Evaluation loop** — measures whether outcomes are actually improving against professional references.

The LLM is not responsible for the workflow. It is responsible for communication and adaptation within a workflow the orchestration layer controls.

**Issues**:

- Slightly larger up front investment - but framework can be used with any model (or multiple models) in the future in the event we want to train new models ourselves.
