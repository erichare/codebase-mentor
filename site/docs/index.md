# Codebase Mentor

**A source-grounded codebase mentor for AI coding agents.** Pair a short `ONBOARDING.md` (the map) with an enforced evidence protocol (the truth), and any agent — Claude Code, Cursor, Codex, Copilot, or anything reading AGENTS.md — answers architecture questions with symbol-anchored citations from your *current* source, or says plainly that it can't.

![Scripted demo: install, ask an architecture question, get a symbol-cited answer](assets/demo.svg)

## Why

A new engineer's first real architecture question costs 30–60 minutes of senior-engineer interrupt time, three to five times per onboarding. And the AI agent that could deflect those questions will confidently improvise architecture from pre-training if you let it — or worse, confidently repeat a stale doc.

Codebase Mentor enforces one contract instead:

> **Every architecture or change-guidance claim must be backed by a symbol or file read in the current session.** Missing evidence is declared, never papered over. Source is the truth; ONBOARDING.md is the map.

## What you get

- **Mentor** — "How does X work?" answered from ONBOARDING.md anchors verified in live source, cited by `ClassName.methodName()` (never line numbers — they rot).
- **Change guide** — "Where do I add Y?" becomes an ordered checklist of real classes and methods, modeled on the nearest existing example.
- **Reconcile** — "Is it still true that Z?" returns Confirmed / Stale / Indeterminate with the deciding symbol. The confident, evidenced *no* is the feature.
- **Scan** — every structural claim in your ONBOARDING.md verified against current source, on demand or [weekly in CI](ci.md).
- **Onboard** — a skill that drafts your ONBOARDING.md from live source and interviews you only for what source can't show (Claude Code).

## Get started

```
npx skills add erichare/codebase-mentor
```

or, in Claude Code:

```
/plugin marketplace add erichare/codebase-mentor
/plugin install codebase-mentor@codebase-mentor
```

Per-agent instructions: [Install](install.md). Rolling out to a team: [Team rollout](team-setup.md).

## Does it work?

In a three-arm evaluation on the Stargate Data API (39 command resolvers, five-layer pipeline), the full setup scored **4.7/5** vs **1.3/5** for a bare agent and **3.5/5** for the protocol without the doc. Scores were author-assigned against a pre-written rubric, with all raw outputs published for blind re-scoring — details and provenance on the [evaluation page](evaluation.md).
