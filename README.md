# Bob Challenge 2026 — Source-Grounded Codebase Mentor

A reusable Bob skill that turns any IBM codebase with a short `ONBOARDING.md` into an interactive codebase mentor — answering architecture questions and guiding change tasks from current source, with evidence or an explicit admission of ignorance.

> **Submitted by:** Eric Hare · IBM  
> **Showcased on:** [Stargate Data API](https://github.com/stargate/jsonapi)

---

## The Pitch

On the Stargate Data API team, a new engineer's first real architecture question typically costs 30–60 minutes of senior-engineer interrupt time. With three to five such events per onboarding and a 2–4 hour one-time authoring investment, the break-even is one to two new hires. After that it compounds: every subsequent hire, every cross-team contributor, every on-call engineer in unfamiliar code.

The skill works for any IBM team. The Stargate Data API — 39 concrete command resolvers, a five-layer request pipeline, a custom task-retry framework, no AGENTS.md — is an honest stress test.

---

## What's in This Repo

| Deliverable | File | Description |
|---|---|---|
| Bob Skill | [`skill/SKILL.md`](skill/SKILL.md) | Installable skill — works for any IBM codebase with an ONBOARDING.md |
| Template | [`template/ONBOARDING.md`](template/ONBOARDING.md) | Fill-in-the-blanks template for any team |
| Authoring Guide | [`template/AUTHORING_GUIDE.md`](template/AUTHORING_GUIDE.md) | How to write your ONBOARDING.md in 2–4 hours |
| Reference Implementation | [`data-api/ONBOARDING.md`](data-api/ONBOARDING.md) | Fully populated for the Stargate Data API — the demo artifact |
| Evaluation Scorecard | [`evaluation/SCORECARD.md`](evaluation/SCORECARD.md) | Three-arm evaluation: **complete** — Arm 3 avg 4.7/5, delta +1.2 (author-scored; raw outputs published for independent review) |
| Demo Script | [`demo/SCRIPT.md`](demo/SCRIPT.md) | Shot-by-shot recording guide with voiceover script |

---

## Build Status

| Sub-Task | Deliverable | Status |
|---|---|---|
| 1 — Skill authoring | `skill/SKILL.md` | 🟩 Done |
| 2 — Template + authoring guide | `template/` | 🟩 Done |
| 3 — Data API reference ONBOARDING.md | `data-api/ONBOARDING.md` | 🟩 Done |
| 4 — Evaluation scorecard setup | `evaluation/SCORECARD.md` | 🟩 Done |
| 5 — This README | `README.md` | 🟩 Done |

---

## The Demo

The demo runs three arms across five tasks. Evaluation is complete.

| Arm | Condition | Actual avg score |
|---|---|---|
| 1 | Generic Bob — no skill, no source | **1.3 / 5** |
| 2 | Bob + skill + live source, no ONBOARDING.md | **3.5 / 5** |
| 3 | Bob + skill + ONBOARDING.md | **4.7 / 5** |

**Delta (Arm 2 → Arm 3): +1.2** · **Arm 3 avg: 4.7 / 5.0** — both stated success criteria met.

> ⚠️ **Provenance note:** scores were assigned by the submission author against pre-written rubric criteria, not by independent judges. The raw outputs for all five tasks across all three arms are committed at [`evaluation/SCORECARD.md`](evaluation/SCORECARD.md) and can be re-scored blind by any reader.

The sharpest result was **T4** (design-intent gotcha): Arm 2 actively recommended sharing collection/table logic; Arm 3 cleanly refused with the precise failure modes from ONBOARDING.md Section 7. This is the case the ONBOARDING.md uniquely enables: source alone is insufficient; you need the authored rationale.

**The refusal clip:** the demo also shows Bob correcting a deliberately stale claim planted in the ONBOARDING.md — citing the source file that contradicts it. Almost nobody demos a confident, evidenced *"no"*.

---

## How to Install the Skill (for IBM teams)

1. Copy [`skill/SKILL.md`](skill/SKILL.md) into your Bob skills directory (user-level: `~/.claude/skills/codebase-mentor/` or project-level: `.claude/skills/codebase-mentor/`)
2. Author an `ONBOARDING.md` for your repo using the [template](template/ONBOARDING.md) and [authoring guide](template/AUTHORING_GUIDE.md)
3. Place it at the root of your repo
4. Open Bob in your project and ask: *"Where do I add X?"*

No external services, no indexing, no new permissions — the skill uses Bob's existing file-reading capability.

---

## Accuracy Contract

Every architecture or change-guidance claim Bob makes is backed by a symbol or file read in that session. Answers are regenerated from current source, not from a persistent stale index. If Bob can't find source evidence, it says so explicitly.

**Source is the truth. ONBOARDING.md is the map.**

---

## Implementation Plan

Full sub-task breakdown with intent, expected outcomes, and todo lists: [`plan.md`](plan.md)
