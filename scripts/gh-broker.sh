#!/usr/bin/env bash
# Run gh with a short-lived GitHub App token from the Kestrel broker.
#
# The alias comes from KESTREL_GITHUB_APP and the dedicated broker token from
# KESTREL_BROKER_TOKEN_FILE (default
# /etc/soc/kestrel-broker-token-github). No GitHub PAT is read or written.
#
# Usage:
#   KESTREL_GITHUB_APP=soc-release scripts/gh-broker.sh release create ...
set -euo pipefail
set +x  # never trace the token assignment
export PYTHONDONTWRITEBYTECODE=1

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
HELPER=${KESTREL_GITHUB_TOKEN_HELPER:-"$SCRIPT_DIR/kestrel-github-token.py"}

if ! command -v gh >/dev/null 2>&1; then
  echo "gh-broker: gh CLI is not installed" >&2
  exit 127
fi

if ! token=$(python3 "$HELPER" --print-token --format text); then
  echo "gh-broker: could not obtain a Kestrel GitHub token" >&2
  exit 1
fi
if [ -z "$token" ]; then
  echo "gh-broker: Kestrel helper returned an empty token" >&2
  exit 1
fi

export GH_TOKEN="$token"
unset token
exec gh "$@"
