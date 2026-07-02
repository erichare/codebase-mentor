# Contributing to Codebase Mentor

Thanks for helping make onboarding docs that AI agents can actually trust. Contributions of every size are welcome — typo fixes, new agent adapters, example ONBOARDING.md files, protocol improvements.

## Ground rules

- **Edit canonical sources, never generated files.** The protocol lives in `core/mentor-protocol.md` (full) and `core/mentor-protocol-compact.md` (condensed); the authoring kit lives in `template/`. Everything in `adapters/`, the protocol body of `skills/codebase-mentor/SKILL.md`, and the bundled template copies are generated. After editing a source, run:

  ```bash
  scripts/sync-adapters.sh
  ```

  CI fails the PR if generated files are out of date (`scripts/sync-adapters.sh --check`).

- **The accuracy contract is the product.** Changes to the protocol must preserve its core property: every architecture claim is backed by a source read in the current session, and missing evidence is declared, never papered over. PRs that weaken this will be declined.

- **Keep the compact protocol compact.** `core/mentor-protocol-compact.md` feeds AGENTS.md snippets; Codex caps combined AGENTS.md content at 32 KiB per repo, so aim to keep the compact variant around 2 KB.

## Adding an adapter for a new agent

1. Add a generation block to `scripts/sync-adapters.sh` that wraps one of the two core docs in the agent's expected format (frontmatter, markers, file naming).
2. Add the output path to the `GENERATED` array.
3. Add an install case to `install.sh` (`--agent <name>`), idempotent on re-run.
4. Add an install section to `docs/INSTALL.md`, citing the agent's official docs for the format.
5. Run `scripts/sync-adapters.sh` and commit sources + generated output together.

## Contributing an example ONBOARDING.md

Real-world examples live in `onboarding/<repo-name>/ONBOARDING.md`. Follow the seven-section structure from `template/ONBOARDING.md`, use symbol anchors (class/method names, never line numbers), and verify every claim against the target repo's current source before submitting. Add a row to the table in `onboarding/README.md`.

## Development checks

Run what CI runs before pushing:

```bash
scripts/sync-adapters.sh --check   # generated files up to date
shellcheck install.sh scripts/*.sh # shell hygiene
jq . .claude-plugin/*.json         # manifests parse
```

## Pull requests

- Small, focused PRs review faster.
- Describe what changed and why; link related issues.
- CI must be green (validation workflow runs on every PR).

## Questions

Open a GitHub issue — there's a template for bugs, adapter requests, and example submissions.
