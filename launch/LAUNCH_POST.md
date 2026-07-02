# Launch Post Drafts

## X / Twitter (≤280 chars)

> Your onboarding doc lies to your AI agent the moment the code changes.
>
> codebase-mentor makes agents verify every architecture claim against live source — and scan your ONBOARDING.md for drift on a schedule.
>
> One install, works in Claude Code, Cursor, Codex, Copilot:
> npx skills add erichare/codebase-mentor

## LinkedIn

**Your AI coding agent is only as good as its map of your codebase.**

Most teams have no ONBOARDING.md at all — and the ones that do watch it go stale within months. Stale docs are worse than none: an AI agent will confidently repeat them.

I built **codebase-mentor**, an open-source skill for AI coding agents built around one rule: *every architecture claim must be backed by a symbol read from current source, in this session.* The doc is the map; source is the truth.

What it does:
- 📖 Answers "how does X work?" with symbol-anchored citations, not vibes
- 🛠️ Turns "where do I add Y?" into an ordered checklist of real classes and methods
- 🔍 Verifies "is it still true that Z?" against live source — and says *no* with evidence when the doc is wrong
- 🧹 Scans your ONBOARDING.md for drift, on demand or weekly via GitHub Actions
- ✍️ Generates a first-draft ONBOARDING.md from your source, then interviews you for the gotchas only humans know

In a three-arm evaluation on the Stargate Data API, the full setup scored 4.7/5 vs 1.3/5 for a bare agent — and the sharpest win was a confident, evidenced refusal of a design change the source alone made look safe.

Install anywhere: Claude Code plugin, Cursor rule, Copilot instructions, AGENTS.md snippet, or `npx skills add erichare/codebase-mentor` for ~70 agents at once.

Repo: https://github.com/erichare/codebase-mentor
Docs: https://erichare.github.io/codebase-mentor/

## Hacker News (Show HN)

**Title:** Show HN: Codebase-mentor – make AI agents prove architecture claims against source

**Text:**

Every AI coding agent will happily explain your architecture from pre-training vibes. When it's wrong, a new engineer ships the wrong fix.

codebase-mentor is a skill/ruleset with one enforced contract: every architecture or change-guidance claim must be backed by a class or method the agent actually read in the current session, cited by symbol name (never line numbers — they rot). If evidence is missing, the agent must say exactly that instead of hedging with "typically".

It pairs with a 400–800-word ONBOARDING.md (template + auto-generator included) that captures what source can't show: design rationale and the gotchas senior engineers keep catching in review. The agent treats the doc as a map and the source as truth — when they disagree, it says so with the contradicting symbol, and a scheduled GitHub Action files an issue when the doc drifts.

It installs into Claude Code (plugin), Codex (SKILL.md), Cursor (.mdc rule), Copilot (instructions), or anything that reads AGENTS.md — all generated from one canonical protocol doc.

Honest caveat: the published evaluation (4.7/5 vs 1.3/5 baseline) was scored by me against a pre-written rubric; the raw outputs are committed so you can re-score them blind.

https://github.com/erichare/codebase-mentor
