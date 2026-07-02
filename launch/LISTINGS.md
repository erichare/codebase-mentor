# Listing Submissions — Ready-to-Paste

Everything needed to list codebase-mentor in the major directories. Items marked
**(you)** need to be done from your own GitHub account / browser; this session's
GitHub access is scoped to this repo only.

## 0. skills.sh — nothing to do ✅

Listing is automatic: skills.sh indexes public repos with valid SKILL.md files and
ranks by `npx skills add` install telemetry. The listing appears/climbs as installs accrue.

Verified: the skills CLI discovers both skills from this repo's layout and installs
them (`Found 2 skills → ✓ codebase-mentor, ✓ onboard → .claude/skills/`). The test ran
against a local checkout because this CI container's git proxy blocks direct
`https://github.com/...` clones — on a normal machine `npx skills add
erichare/codebase-mentor` performs the same discovery after cloning. Requires the
repo to be public.

## 1. Anthropic official plugin directory (you)

- **Where:** submission form at https://clau.de/plugin-directory-submission
- **Requirements:** valid `.claude-plugin/plugin.json` (✅ — CI-validated), passes their quality/security review.
- **Paste-ready fields:**
  - Plugin name: `codebase-mentor`
  - Marketplace repo: `https://github.com/erichare/codebase-mentor`
  - Description: *Source-grounded codebase mentor for any repo with an ONBOARDING.md — answers architecture questions, guides change tasks, and freshness-scans your onboarding doc, with every claim backed by a symbol read from current source.*
  - Categories: developer tools / documentation / onboarding
  - Docs: `https://erichare.github.io/codebase-mentor/`

## 2. hesreallyhim/awesome-claude-code (you)

- **Where:** https://github.com/hesreallyhim/awesome-claude-code → Issues → "Recommend a new resource" issue form (no direct PRs — an automated pipeline adds accepted entries).
- **Paste-ready fields:**
  - Resource name: `Codebase Mentor`
  - Category: Plugins (or Skills)
  - Link: `https://github.com/erichare/codebase-mentor`
  - One-liner: *Turns any repo with a short ONBOARDING.md into a source-grounded mentor — evidence-cited architecture answers, change checklists, and doc-drift scans; installs as a plugin, SKILL.md, or AGENTS.md snippet.*

## 3. ccplugins/awesome-claude-code-plugins (you, or a future session with cross-repo access)

- **Where:** https://github.com/ccplugins/awesome-claude-code-plugins → fork → add entry → PR.
- **Paste-ready entry (match the list's surrounding format):**

  ```markdown
  - [codebase-mentor](https://github.com/erichare/codebase-mentor) — Source-grounded
    codebase mentor: evidence-cited architecture answers, guided change checklists,
    and ONBOARDING.md freshness scans. `/plugin marketplace add erichare/codebase-mentor`
  ```

## 4. GitHub repo metadata (you, if the API attempt failed)

- **Description:** `Source-grounded codebase mentor for AI coding agents — evidence-cited architecture answers, change guidance, and ONBOARDING.md freshness scans. Claude Code plugin + Cursor/Copilot/Codex/AGENTS.md adapters.`
- **Homepage:** `https://erichare.github.io/codebase-mentor/`
- **Topics:** `claude-code` `claude-plugin` `agent-skills` `agents-md` `cursor` `github-copilot` `codex` `onboarding` `developer-tools` `documentation` `ai-agents`
