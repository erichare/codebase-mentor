# Source-Grounded Codebase Mentor

A Claude Code plugin that turns any codebase with a short `ONBOARDING.md` into an interactive codebase mentor — answering architecture questions and guiding change tasks from current source, with evidence or an explicit admission of ignorance. Works with Claude Code and IBM-branded distributions of it (Bob).

> **Submitted by:** Eric Hare · IBM (Bob Challenge 2026)  
> **Showcased on:** [Stargate Data API](https://github.com/stargate/jsonapi)

---

## Quickstart

Install the plugin (two slash commands inside Claude Code):

```
/plugin marketplace add erichare/codebase-mentor
/plugin install codebase-mentor@codebase-mentor
```

or from a shell:

```bash
claude plugin marketplace add erichare/codebase-mentor
claude plugin install codebase-mentor@codebase-mentor --scope user
```

Then, in any repo:

1. **No ONBOARDING.md yet?** Run `/codebase-mentor:onboard` — it drafts one from live source and interviews you only for the parts source can't provide (gotchas, ownership). What used to be a 2–4 hour authoring task becomes a ~30 minute review.
2. **Ask a question:** *"Where do I add X?"* — answers come with symbol-anchored citations from current source.
3. **Keep it fresh:** ask for a freshness scan any time, or wire up the [scheduled GitHub Action](examples/github-actions/onboarding-freshness.yml).

No external services, no indexing, no new permissions — the skill uses Claude Code's existing file-reading capability.

**Other install paths:**

- **Whole team, zero-click** — commit a marketplace reference to your repo's `.claude/settings.json` so teammates are prompted automatically: see [`docs/TEAM_SETUP.md`](docs/TEAM_SETUP.md).
- **No plugin support (IBM Bob, older Claude Code)** — `curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash` installs the skills to `~/.claude/skills/` (add `--project` to vendor them into your repo instead).

---

## The Pitch

On the Stargate Data API team, a new engineer's first real architecture question typically costs 30–60 minutes of senior-engineer interrupt time. With three to five such events per onboarding and a 2–4 hour one-time authoring investment, the break-even is one to two new hires. After that it compounds: every subsequent hire, every cross-team contributor, every on-call engineer in unfamiliar code.

The skill works for any team with a codebase and a short ONBOARDING.md — request/response services, batch pipelines, stream processors, libraries. The Stargate Data API — 39 concrete command resolvers, a five-layer request pipeline, a custom task-retry framework, no AGENTS.md — is an honest stress test.

---

## What's in This Repo

| Deliverable | File | Description |
|---|---|---|
| Plugin Manifest | [`.claude-plugin/`](.claude-plugin/) | Plugin + marketplace metadata enabling the one-command install |
| Mentor Skill | [`skills/codebase-mentor/SKILL.md`](skills/codebase-mentor/SKILL.md) | The core skill — works for any codebase with an ONBOARDING.md |
| Onboard Skill | [`skills/onboard/SKILL.md`](skills/onboard/SKILL.md) | `/codebase-mentor:onboard` — generates an ONBOARDING.md draft from live source |
| Template | [`template/ONBOARDING.md`](template/ONBOARDING.md) | Fill-in-the-blanks template for any team (bundled into the plugin) |
| Authoring Guide | [`template/AUTHORING_GUIDE.md`](template/AUTHORING_GUIDE.md) | How to write your ONBOARDING.md by hand in 2–4 hours |
| Team Setup Guide | [`docs/TEAM_SETUP.md`](docs/TEAM_SETUP.md) | Zero-click rollout for a whole team via `.claude/settings.json` |
| CI Freshness Scan | [`examples/github-actions/onboarding-freshness.yml`](examples/github-actions/onboarding-freshness.yml) | Scheduled GitHub Action that files an issue when ONBOARDING.md drifts |
| Installer Script | [`install.sh`](install.sh) | Fallback install for environments without plugin support (e.g., IBM Bob) |
| Reference Implementation | [`data-api/ONBOARDING.md`](data-api/ONBOARDING.md) | Fully populated for the Stargate Data API — the demo artifact |
| Evaluation Scorecard | [`evaluation/SCORECARD.md`](evaluation/SCORECARD.md) | Three-arm evaluation: **complete** — Arm 3 avg 4.7/5, delta +1.2 (author-scored; raw outputs published for independent review) |
| Demo Script | [`demo/SCRIPT.md`](demo/SCRIPT.md) | Shot-by-shot recording guide with voiceover script |
| Additional ONBOARDING.md files | [`onboarding/`](onboarding/) | Synced copies for astrapy, langflow, and stargate-jsonapi — edit here, copy to repo root |

---

## Build Status

| Sub-Task | Deliverable | Status |
|---|---|---|
| 1 — Skill authoring | `skills/codebase-mentor/SKILL.md` | 🟩 Done |
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

## Rolling It Out to a Team

Three options, detailed in [`docs/TEAM_SETUP.md`](docs/TEAM_SETUP.md):

1. **Auto-enable (recommended):** commit a marketplace reference to your repo's `.claude/settings.json` — teammates are prompted to install on workspace trust and stay auto-updated.
2. **Vendor the skills:** `install.sh --project` copies them into `.claude/skills/`, auto-discovered by anyone who opens the repo. This is also the IBM Bob path.
3. **Individual install:** each engineer runs the two Quickstart commands once.

## Keeping ONBOARDING.md Fresh

Drift is the failure mode of every onboarding doc. Two defenses:

- **On demand:** ask *"has anything drifted?"* — the skill's Mode 4 scan verifies every structural claim against current source.
- **Automated:** copy [`examples/github-actions/onboarding-freshness.yml`](examples/github-actions/onboarding-freshness.yml) into `.github/workflows/` — a weekly scan that opens (and maintains) a GitHub issue whenever a claim goes stale. Requires an `ANTHROPIC_API_KEY` repo secret.

---

## Accuracy Contract

Every architecture or change-guidance claim the mentor makes is backed by a symbol or file read in that session. Answers are regenerated from current source, not from a persistent stale index. If it can't find source evidence, it says so explicitly.

**Source is the truth. ONBOARDING.md is the map.**

---

## Implementation Plan

Full sub-task breakdown with intent, expected outcomes, and todo lists: [`plan.md`](plan.md)
