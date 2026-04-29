---
kind: source
title: "Aftershoot: Orchestration-Based AI-Driven Photo Editing Coach (updated)"
order: 2
focus: false
parent: source-original
created_at: "2026-04-28T15:00:00Z"
---

# Aftershoot: Orchestration-Based AI-Driven Photo Editing Coach

## 1. Goal

Make the best use of commercially available LLM models to build an AI-assisted photo editing system that helps novices and hobbyists produce visibly stronger images and learn to edit more effectively in the process. The system guides users through a structured, expert-informed workflow that adapts to the image, the user's skill level, the desired outcome, and the current stage of the edit.

Division of responsibility:

- **Methodology** — encodes professional photographic judgment (sequencing, tradeoffs, failure modes, when to stop).
- **Orchestration** — manages state, selects relevant methodology modules, enforces tool constraints, ensures repeatability.
- **LLM** — explains, recommends, and adapts conversationally.
- **Evaluation loop** — measures whether outcomes are actually improving against professional references.

The LLM is not responsible for the workflow. It is responsible for communication and adaptation within a workflow the orchestration layer controls.

## 2. Target User Experience

The user opens an image. The system analyzes it and gathers context: image type, likely strengths and weaknesses, user proficiency, desired mood or style, available tools, relevant metadata. Based on that context it selects the appropriate methodology modules and guides the user step by step.

The interaction is a closed loop: system gives the next instruction in plain language with rationale → user applies the adjustment → system observes the updated image state → system updates state and gives the next instruction. The user can ask questions or push back at any point, and guidance adapts. The loop continues until the edit reaches an acceptable result.

This is not prompt-and-response. The system sees the image evolve and teaches the user what to do next.

## 3. Why Structured Orchestration

A generic LLM checklist ("crop, expose, white balance, recover highlights...") is directionally fine but doesn't know whether the image is a portrait or a low-light scene, whether the user already overcorrected the last slider, whether the next recommendation conflicts with prior edits, whether a beginner should even see a particular tool, or whether the result is moving toward or away from a professional-quality edit.

Prompt-only approaches also force the LLM to do too much at once: interpret the image, choose the workflow, remember skill level, manage prior edits, enforce constraints, prevent overediting, and teach. That produces inconsistency.

Using generic LLMs in a prompt-only manner also produces substantially higher token costs.

Professional photographer input is what makes the methodology non-generic. Pros know which adjustments matter most for each image type, which tools beginners misuse, which technically correct adjustments make images worse, when to stop, and how to spot hidden opportunities. A novice sees a dark image and pushes exposure; a pro recognizes the real issue is subject separation, white balance, or local contrast. Capturing that judgment — and operationalizing it as conditional rules — is the actual work.

## 4. Modular Methodology with State-Based Injection

The methodology is not one large prompt. It is a library of modules, conditionally selected and injected based on tracked state.

State the orchestrator maintains:

- Image category, metadata, detected conditions
- User proficiency and preferences
- Editing objective and desired mood/style
- Current workflow stage
- Edits already applied and their effects
- Available tools at this point in the session
- Known risk patterns for this image type

Methodology modules include category workflows (portrait, landscape, food, low-light, product, etc.), proficiency pathways, sequencing rules, failure-mode checks, style variants, evaluation rubrics, and escalation rules for introducing more advanced tools. Only the relevant modules enter the LLM context at any moment.

This buys consistency, token efficiency, debuggability, and protection against the model offering advice that conflicts with edits already made.

## 5. Slider/Tool Recommendation Strategy

Slider/tool availability is gated by skill level, image type, workflow stage, and editing objective. More sliders do not produce better results — for novices they reliably produce worse ones.

Beginners get a small set of high-impact, low-risk controls (crop, straighten, exposure, white balance, highlights, shadows, contrast, vibrance, basic noise reduction, basic sharpening). Intermediate access opens up additional tools (many currently under development) like tone curve, HSL, masks, and local adjustments. Advanced access opens luminosity masks, frequency separation, channel-based adjustments, advanced color grading, etc.

Principle: expose the right tool at the right time, not every tool at once. The system should also prefer simpler tools when they can solve the problem, and only escalate when they can't.

## 6. Development and Refinement Loop

The methodology is built and improved by testing it against real editing behavior and professional reference outcomes. The first version is a hypothesis, not a finished artifact.

**Build the initial methodology** from professional photographer interviews, analysis of common novice mistakes, review of representative photo categories, and existing knowledge of standard editing workflows. Define core controls, sequencing, category-specific workflows, tool access rules, failure-mode warnings, and evaluation rubrics.

**Assemble a test set** across portraits, landscapes, food, low-light indoor, travel, pets, product-style, backlit subjects, high-contrast scenes, mobile photos, and RAW files — varied in quality, lighting, color issues, and composition challenges.

**Generate three edit paths per test image**: generic LLM-guided novice, structured-methodology AI-assisted novice, and a professional reference edit with the pro's reasoning captured. The structured system has to beat the generic LLM path — that's the bar.

**Evaluate and gap-analyze.** Score on visual improvement, naturalness, color and skin tone, highlight/shadow preservation, subject emphasis, composition, avoidance of overediting, appropriate tool use, consistency across similar images, user understanding, and similarity to professional decisions. Then isolate causes: where did the methodology improve outcomes, where was generic guidance just as good, where did the pro make a better call, where did state tracking or context injection break down, where were tool constraints too strict or too loose.

**Refine and re-test** category workflows, tool rules, skill-level constraints, prompt templates, state-tracking logic, professional heuristics, and rubrics. Continue until structured AI-assisted edits consistently beat both unguided and generic-LLM paths. The target is measurable improvement, not perfection.

## Critical Success Factors

The system succeeds if it: improves novice outcomes over generic LLM guidance; teaches rather than just automates; reflects real professional judgment; adapts to image type and user proficiency; maintains workflow state; constrains tool recommendations appropriately; avoids prompt-stuffing through modular injection; produces consistent, debuggable behavior; and shows measurable movement toward professional reference edits while remaining beginner-appropriate.
