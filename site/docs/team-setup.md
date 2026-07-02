# Team Rollout

Three ways to get the mentor in front of a whole team, most-automatic first.

## Option 1 — Auto-enable via repo settings (Claude Code)

Commit to your repo's `.claude/settings.json`; everyone who trusts the workspace gets prompted once and stays auto-updated:

```json
{
  "extraKnownMarketplaces": {
    "codebase-mentor": {
      "source": {
        "source": "github",
        "repo": "erichare/codebase-mentor"
      },
      "autoUpdate": true
    }
  },
  "enabledPlugins": {
    "codebase-mentor@codebase-mentor": true
  }
}
```

Merge the keys if the file already exists.

## Option 2 — Commit the artifacts into your repo (any agent)

Vendored files are auto-discovered by everyone who opens the repo, no install step:

```bash
# Claude Code project skills
curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --project
# AGENTS.md snippet — covers Codex, Cursor, Copilot coding agent, OpenCode, …
curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent agents-md
# Cursor rule
curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent cursor

git add .claude .cursor AGENTS.md && git commit -m "Add codebase-mentor"
```

You own updates — re-run the script to refresh. This is also the path for IBM Bob and CI containers without network access.

## Option 3 — Everyone installs once, user-level

```bash
npx skills add erichare/codebase-mentor -g
```

## CI / containers

Point `CLAUDE_CODE_PLUGIN_SEED_DIR` at a checkout of this repo to pre-populate the plugin without cloning at startup, or vendor with Option 2 (zero network).

## After rollout

1. Ensure the repo has an `ONBOARDING.md` — [generate or author one](authoring.md).
2. Add the [scheduled freshness scan](ci.md) so the doc can't silently rot.
3. Watch senior-engineer interrupts drop: the doc + protocol answers the orientation questions; humans keep the questions that genuinely need them.
