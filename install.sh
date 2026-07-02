#!/usr/bin/env bash
#
# Fallback installer for the codebase-mentor skills.
#
# Prefer the plugin install if your Claude Code / Bob version supports plugins:
#   /plugin marketplace add erichare/codebase-mentor
#   /plugin install codebase-mentor@codebase-mentor
#
# This script copies the skills into a skills directory instead:
#   curl -fsSL https://raw.githubusercontent.com/erichare/codebase-mentor/main/install.sh | bash
#
# Options:
#   --project   install into ./.claude/skills/ (shared with everyone who opens this repo)
#               default is user-level ~/.claude/skills/
#   --ref REF   git ref to install from (default: main)
set -euo pipefail

REPO="erichare/codebase-mentor"
REF="main"
DEST="${HOME}/.claude/skills"
SKILLS=(codebase-mentor onboard)
FILES_codebase_mentor=(SKILL.md ONBOARDING.template.md AUTHORING_GUIDE.md)
FILES_onboard=(SKILL.md)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) DEST=".claude/skills"; shift ;;
    --ref) REF="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# If run from inside a checkout of the repo, copy locally; otherwise fetch from GitHub.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
LOCAL_SRC=""
if [[ -n "${SCRIPT_DIR}" && -f "${SCRIPT_DIR}/skills/codebase-mentor/SKILL.md" ]]; then
  LOCAL_SRC="${SCRIPT_DIR}/skills"
fi

fetch() { # fetch <skill> <file> -> stdout
  curl -fsSL "https://raw.githubusercontent.com/${REPO}/${REF}/skills/$1/$2"
}

for skill in "${SKILLS[@]}"; do
  mkdir -p "${DEST}/${skill}"
  files_var="FILES_${skill//-/_}[@]"
  for file in "${!files_var}"; do
    if [[ -n "${LOCAL_SRC}" ]]; then
      cp "${LOCAL_SRC}/${skill}/${file}" "${DEST}/${skill}/${file}"
    else
      fetch "${skill}" "${file}" > "${DEST}/${skill}/${file}"
    fi
    echo "installed ${DEST}/${skill}/${file}"
  done
done

echo
echo "Done. Skills installed to ${DEST}/."
echo "Open Claude Code (or Bob) and ask an architecture question, or run the onboard skill"
echo "to generate an ONBOARDING.md for your repo."
