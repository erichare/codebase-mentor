# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow
[Semantic Versioning](https://semver.org/). The plugin version in
`.claude-plugin/plugin.json` matches the latest release tag.

## [Unreleased]

## [1.1.0] - 2026-07-02

### Added
- Agent-neutral protocol core (`core/mentor-protocol.md` + compact variant) with generated adapters for AGENTS.md, Cursor, and GitHub Copilot; `scripts/sync-adapters.sh` keeps everything in sync (CI-enforced).
- `install.sh --agent claude|codex|cursor|copilot|agents-md|all` cross-agent installs; `npx skills add erichare/codebase-mentor` documented as the universal path.
- Per-agent install guide (`docs/INSTALL.md`) and documentation site (MkDocs Material, deployed to GitHub Pages) with a scripted terminal demo.
- MIT license, contributing guide, code of conduct, security policy, issue/PR templates.
- Repo CI (plugin validation, sync drift gate, shellcheck, link check) and tag-driven release workflow.
- Dogfooding: this repo's own `ONBOARDING.md` plus a weekly freshness-scan workflow (skips until an `ANTHROPIC_API_KEY` secret is set).
- Launch kit: ready-to-paste directory listings (`launch/LISTINGS.md`) and announcement drafts (`launch/LAUNCH_POST.md`).

## [1.0.0] - 2026-07-02

### Added
- Claude Code plugin packaging (`.claude-plugin/plugin.json` + `marketplace.json`) with two-command install.
- `codebase-mentor` skill: Mentor / Change Guide / Reconcile / Scan modes under a source-evidence accuracy contract.
- `/codebase-mentor:onboard` skill: generates an ONBOARDING.md draft from live source, interviews for gotchas, self-verifies with a freshness scan.
- Bundled ONBOARDING.md template + authoring guide.
- Example scheduled GitHub Action for ONBOARDING.md freshness scanning.
- Team rollout guide (`docs/TEAM_SETUP.md`) and `install.sh` fallback installer.

[Unreleased]: https://github.com/erichare/codebase-mentor/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/erichare/codebase-mentor/releases/tag/v1.0.0
