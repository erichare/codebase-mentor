# Team Setup — Zero-Click Adoption

Three ways to roll the codebase-mentor out to a whole team, from most to least automatic.

## Option 1 — Auto-enable via repo settings (recommended)

Commit this to your repo's `.claude/settings.json`. Everyone who opens the repo and trusts the workspace is prompted once to install the plugin, and it stays up to date automatically:

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

If your repo already has a `.claude/settings.json`, merge the two keys into it rather than replacing the file.

## Option 2 — Commit the skills into your repo

No plugin machinery at all: vendor the skill files into your repo's project-level skills directory, and they are auto-discovered by anyone who opens the repo.

```bash
curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --project
git add .claude/skills && git commit -m "Add codebase-mentor skills"
```

This pins a copy in your repo — you own updates (re-run the script to refresh). This is also the path for IBM Bob or older Claude Code versions without plugin support.

## Option 3 — Each engineer installs once, user-level

```
/plugin marketplace add erichare/codebase-mentor
/plugin install codebase-mentor@codebase-mentor
```

or from a shell:

```bash
claude plugin marketplace add erichare/codebase-mentor
claude plugin install codebase-mentor@codebase-mentor --scope user
```

## CI / containers

In headless or read-only environments, pre-populate the plugin instead of cloning at startup by pointing `CLAUDE_CODE_PLUGIN_SEED_DIR` at a directory containing a checkout of this repo. Alternatively, vendor the skills with Option 2 — project-level skills need no network access at all.

## After installing

1. If your repo has no `ONBOARDING.md` yet, run `/codebase-mentor:onboard` — it drafts one from live source and interviews you for the gotchas.
2. Ask a question: *"Where do I add a new command?"* — the mentor answers with symbol-anchored citations from current source.
3. Optionally add the [scheduled freshness scan workflow](../examples/github-actions/onboarding-freshness.yml) so drift gets caught automatically.
