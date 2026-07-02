# Install

The mentor protocol ships in three generated forms — SKILL.md skills, an AGENTS.md snippet, and per-agent adapters — all from one canonical source. Pick your agent.

## Universal one-liner

The [`skills` CLI](https://github.com/vercel-labs/skills) detects your installed agents and installs into each (~70 agents supported):

```bash
npx skills add erichare/codebase-mentor
```

Flags: `-g` user-level, `-a claude-code|codex|cursor` to target one agent, `-y` to skip prompts.

## Per agent

=== "Claude Code"

    Plugin install — gets you `/codebase-mentor:onboard` and auto-updates:

    ```
    /plugin marketplace add erichare/codebase-mentor
    /plugin install codebase-mentor@codebase-mentor
    ```

    No plugin support (IBM Bob, older versions):

    ```bash
    curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash
    ```

    Add `-s -- --project` to vendor into the repo's `.claude/skills/`.

=== "Codex CLI"

    Codex reads the same open SKILL.md format:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent codex
    ```

    Skills land in `~/.codex/skills/` (`.codex/skills/` with `--project`). Invoke with `$codebase-mentor` or implicitly. Codex also reads AGENTS.md — see that tab.

=== "Cursor"

    Simplest: use the AGENTS.md snippet (Cursor reads it natively). Or install the project rule:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent cursor
    ```

    Drops `codebase-mentor.mdc` into `.cursor/rules/` — commit it to share with the team.

=== "GitHub Copilot"

    The coding agent reads AGENTS.md (see that tab). For Copilot Chat / repo-wide instructions:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent copilot
    ```

    Upserts a marked block into `.github/copilot-instructions.md` — re-runs replace it, never duplicate.

=== "AGENTS.md (everything else)"

    Codex, Cursor, Copilot coding agent, OpenCode, Amp, Zed, Windsurf, Gemini CLI, Jules and more read the [AGENTS.md standard](https://agents.md):

    ```bash
    curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash -s -- --agent agents-md
    ```

    Upserts the compact protocol (~2 KB) into `AGENTS.md` between markers. Commit it once, every AGENTS.md-aware agent follows it.

Everything at once: `--agent all`.

## After installing

1. No `ONBOARDING.md`? Generate one with `/codebase-mentor:onboard` (Claude Code) or author from the [template](authoring.md).
2. Ask: *"Where do I add X?"* — expect symbol-anchored citations.
3. Keep it fresh: [CI freshness scanning](ci.md).
