#!/usr/bin/env bash
#
# Installer for the codebase-mentor skills and adapters.
#
# Cross-agent one-liner (recommended if you have Node.js — installs into
# ~70 supported agents automatically):
#   npx skills add erichare/codebase-mentor
#
# Claude Code plugin install (if your version supports plugins):
#   /plugin marketplace add erichare/codebase-mentor
#   /plugin install codebase-mentor@codebase-mentor
#
# This script is the no-dependency fallback (curl + bash only):
#   curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash
#
# Options:
#   --agent X   which agent to install for (default: claude)
#                 claude     SKILL.md skills -> ~/.claude/skills/ (or .claude/skills/ with --project)
#                 codex      SKILL.md skills -> ~/.codex/skills/ (or .codex/skills/ with --project)
#                 cursor     rule -> ./.cursor/rules/codebase-mentor.mdc   (always project-level)
#                 copilot    block upserted into ./.github/copilot-instructions.md (project-level)
#                 agents-md  block upserted into ./AGENTS.md               (project-level)
#                 all        all of the above
#   --project   install skills into the current repo instead of the home directory
#   --ref REF   git ref to install from (default: main)
#
# Re-running is safe: skill files are overwritten in place, and the
# copilot/agents-md blocks are replaced between their marker comments.
set -euo pipefail

REPO="erichare/codebase-mentor"
REF="main"
PROJECT=0
AGENT="claude"
SKILLS=(codebase-mentor onboard)
FILES_codebase_mentor=(SKILL.md ONBOARDING.template.md AUTHORING_GUIDE.md)
FILES_onboard=(SKILL.md)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT=1; shift ;;
    --ref) REF="$2"; shift 2 ;;
    --agent) AGENT="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# If run from inside a checkout of the repo, copy locally; otherwise fetch from GitHub.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
LOCAL_SRC=""
if [[ -n "${SCRIPT_DIR}" && -f "${SCRIPT_DIR}/skills/codebase-mentor/SKILL.md" ]]; then
  LOCAL_SRC="${SCRIPT_DIR}"
fi

get() { # get <repo-relative-path> -> stdout
  if [[ -n "${LOCAL_SRC}" ]]; then
    cat "${LOCAL_SRC}/$1"
  else
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/${REF}/$1"
  fi
}

install_skills() { # $1 = destination skills directory
  local dest="$1" skill file files_var
  for skill in "${SKILLS[@]}"; do
    mkdir -p "${dest}/${skill}"
    files_var="FILES_${skill//-/_}[@]"
    for file in "${!files_var}"; do
      get "skills/${skill}/${file}" > "${dest}/${skill}/${file}"
      echo "installed ${dest}/${skill}/${file}"
    done
  done
}

upsert_block() { # $1 = target file; snippet (with begin/end markers) on stdin
  local target="$1" snippet tmp
  snippet="$(cat)"
  tmp="$(mktemp)"
  if [[ -f "${target}" ]]; then
    awk '/codebase-mentor:begin/{skip=1} /codebase-mentor:end/{skip=0; next} !skip{print}' \
      "${target}" > "${tmp}"
  fi
  { if [[ -s "${tmp}" ]]; then cat "${tmp}"; echo; fi; printf '%s\n' "${snippet}"; } > "${target}"
  rm -f "${tmp}"
  echo "updated ${target} (codebase-mentor block)"
}

install_agent() {
  case "$1" in
    claude)
      if [[ ${PROJECT} -eq 1 ]]; then install_skills ".claude/skills"; else install_skills "${HOME}/.claude/skills"; fi ;;
    codex)
      if [[ ${PROJECT} -eq 1 ]]; then install_skills ".codex/skills"; else install_skills "${HOME}/.codex/skills"; fi ;;
    cursor)
      mkdir -p .cursor/rules
      get "adapters/cursor/codebase-mentor.mdc" > .cursor/rules/codebase-mentor.mdc
      echo "installed .cursor/rules/codebase-mentor.mdc" ;;
    copilot)
      mkdir -p .github
      get "adapters/copilot/copilot-instructions-snippet.md" | upsert_block ".github/copilot-instructions.md" ;;
    agents-md)
      get "adapters/agents-md/AGENTS-snippet.md" | upsert_block "AGENTS.md" ;;
    *)
      echo "Unknown agent: $1 (expected claude|codex|cursor|copilot|agents-md|all)" >&2; exit 1 ;;
  esac
}

if [[ "${AGENT}" == "all" ]]; then
  for a in claude codex cursor copilot agents-md; do install_agent "${a}"; done
else
  install_agent "${AGENT}"
fi

echo
echo "Done. Open your agent in a repo and ask an architecture question, or generate"
echo "an ONBOARDING.md from the template: https://github.com/${REPO}/blob/${REF}/template/ONBOARDING.md"
