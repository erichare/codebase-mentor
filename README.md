# Codebase Mentor

[![Validate](https://github.com/erichare/codebase-mentor/actions/workflows/validate.yml/badge.svg)](https://github.com/erichare/codebase-mentor/actions/workflows/validate.yml)
[![Release](https://img.shields.io/github/v/release/erichare/codebase-mentor)](https://github.com/erichare/codebase-mentor/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-erichare.github.io-teal)](https://erichare.github.io/codebase-mentor/)

**A source-grounded codebase mentor for AI coding agents.** Pair a short `ONBOARDING.md` (the map) with an enforced evidence protocol (the truth), and any agent answers architecture questions with symbol-anchored citations from your *current* source — or says plainly that it can't.

> **Every architecture or change-guidance claim must be backed by a symbol or file read in the current session.** Missing evidence is declared, never papered over. Source is the truth; ONBOARDING.md is the map.

![Scripted demo: install, ask an architecture question, get a symbol-cited answer with a gotcha from ONBOARDING.md](site/docs/assets/demo.svg)

## Install

**Any agent** (Claude Code, Cursor, Codex, Copilot, OpenCode — ~70 supported):

```bash
npx skills add erichare/codebase-mentor
```

**Claude Code plugin** (adds `/codebase-mentor:onboard` + auto-updates):

```
/plugin marketplace add erichare/codebase-mentor
/plugin install codebase-mentor@codebase-mentor
```

**No npm / no plugin support** (IBM Bob, CI, air-gapped):

```bash
curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash
```

`install.sh` also targets specific agents — `--agent codex|cursor|copilot|agents-md|all` — including an [AGENTS.md](https://agents.md) snippet that covers every agent reading that standard. Full per-agent guide: [docs/INSTALL.md](docs/INSTALL.md) · team rollout: [docs/TEAM_SETUP.md](docs/TEAM_SETUP.md).

## What you get

- **Mentor** — *"How does X work?"* answered from ONBOARDING.md anchors verified in live source, cited as `ClassName.methodName()` (never line numbers — they rot).
- **Change guide** — *"Where do I add Y?"* becomes an ordered checklist of real classes and methods, modeled on the nearest existing example in source.
- **Reconcile** — *"Is it still true that Z?"* returns **Confirmed / Stale / Indeterminate** with the deciding symbol. The confident, evidenced *no* is the feature.
- **Scan** — every structural claim in your ONBOARDING.md verified against current source, on demand or [weekly in CI](examples/github-actions/onboarding-freshness.yml).
- **Onboard** — `/codebase-mentor:onboard` drafts your ONBOARDING.md from live source and interviews you only for what source can't show (the gotchas). 2–4 hours of authoring becomes a ~30-minute review.

## Getting started in a repo

1. **No ONBOARDING.md?** Run `/codebase-mentor:onboard`, or author from the [template](template/ONBOARDING.md) with the [authoring guide](template/AUTHORING_GUIDE.md). This repo [dogfoods its own](ONBOARDING.md).
2. **Ask:** *"Where do I add X?"*
3. **Keep it fresh:** copy the [freshness-scan workflow](examples/github-actions/onboarding-freshness.yml) into `.github/workflows/` — drift files an issue instead of misleading the next engineer.

## Does it work?

In a three-arm evaluation on the [Stargate Data API](https://github.com/stargate/jsonapi) (39 command resolvers, five-layer pipeline), the full setup scored **4.7/5** vs **1.3/5** for a bare agent and **3.5/5** for source access without the doc. The sharpest win: asked about sharing collection/table logic, the source-only arm *recommended it*; the ONBOARDING.md arm refused with the precise failure modes. Scores are author-assigned against pre-written rubrics with [all raw outputs published](evaluation/SCORECARD.md) for blind re-scoring — full story on the [evaluation page](https://erichare.github.io/codebase-mentor/evaluation/).

*Codebase Mentor began as an IBM Bob Challenge 2026 submission ([origin story](https://erichare.github.io/codebase-mentor/evaluation/)).*

## What's in this repo

| Area | Contents |
|---|---|
| [`core/`](core/) | The canonical mentor protocol (full + compact) — everything else is generated from it |
| [`skills/`](skills/) | SKILL.md artifacts (Claude Code, Codex, `skills` CLI): the mentor + the onboard generator |
| [`adapters/`](adapters/) | Generated AGENTS.md snippet, Cursor rule, Copilot instructions block |
| [`scripts/`](scripts/) | `sync-adapters.sh` — regenerates all distribution artifacts; `--check` gates CI |
| [`template/`](template/) | The seven-section ONBOARDING.md template + authoring guide |
| [`docs/`](docs/) | Per-agent install + team rollout guides |
| [`site/`](site/) | The [documentation site](https://erichare.github.io/codebase-mentor/) (MkDocs Material) |
| [`examples/`](examples/) | Copy-paste GitHub Actions freshness-scan workflow |
| [`onboarding/`](onboarding/), [`data-api/`](data-api/) | Real example ONBOARDING.md files (Stargate Data API, AstraPy, Langflow) |
| [`evaluation/`](evaluation/), [`demo/`](demo/), [`plan.md`](plan.md) | The original evaluation scorecard, demo script, and build plan |

## Contributing

Edit canonical sources, run `scripts/sync-adapters.sh`, and see [CONTRIBUTING.md](CONTRIBUTING.md) — adapter contributions for new agents are especially welcome.
