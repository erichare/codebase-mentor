# Bob Challenge 2026 — Source-Grounded Codebase Mentor

A reusable Bob skill that turns any IBM codebase with a short `ONBOARDING.md` into an interactive codebase mentor — answering architecture questions and guiding change tasks from current source, with evidence or an explicit admission of ignorance.

> **Submitted by:** Eric Hare · IBM  
> **Showcased on:** [Stargate Data API](https://github.com/stargate/jsonapi)

---

## The Pitch

On the Stargate Data API team, a new engineer's first real architecture question typically costs 30–60 minutes of senior-engineer interrupt time. With three to five such events per onboarding and a 2–4 hour one-time authoring investment, the break-even is one to two new hires. After that it compounds: every subsequent hire, every cross-team contributor, every on-call engineer in unfamiliar code.

The skill works for any IBM team. The Stargate Data API — 90+ command resolvers, a five-layer request pipeline, a custom task-retry framework, no AGENTS.md — is an honest stress test.

---

## What's in This Repo

| Deliverable | File | Description |
|---|---|---|
| Bob Skill | [`skill/SKILL.md`](skill/SKILL.md) | Installable skill — works for any IBM codebase with an ONBOARDING.md |
| Template | [`template/ONBOARDING.md`](template/ONBOARDING.md) | Fill-in-the-blanks template for any team |
| Authoring Guide | [`template/AUTHORING_GUIDE.md`](template/AUTHORING_GUIDE.md) | How to write your ONBOARDING.md in 2–4 hours |
| Reference Implementation | [`data-api/ONBOARDING.md`](data-api/ONBOARDING.md) | Fully populated for the Stargate Data API — the demo artifact |
| Evaluation Scorecard | [`evaluation/SCORECARD.md`](evaluation/SCORECARD.md) | Three-arm evaluation: results filled in after Week 2–3 |

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

The demo runs three arms on the same question: *"I need to add a new sort type to the Data API. Where do I start?"*

| Arm | Condition | Expected score |
|---|---|---|
| 1 | Generic Bob — no skill, no source | 1–2 / 5 |
| 2 | Bob + skill + live source, no ONBOARDING.md | 2–3 / 5 |
| 3 | Bob + skill + ONBOARDING.md | 4–5 / 5 |

The arm (2) → arm (3) delta is the claim under test. If it's small, the doc's value is rationale and gotchas — and the submission says so. Either outcome is credible.

**The refusal clip:** the demo also shows Bob correcting a deliberately stale claim planted in the ONBOARDING.md — citing the source file and line that contradicts it. Almost nobody demos a confident, evidenced *"no"*.

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
