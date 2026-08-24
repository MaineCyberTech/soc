#!/usr/bin/env bash
# mct-env.sh - shared variable resolution helpers for MCT endpoint scripts.
# Supports: CLI flags (handled by caller) -> env vars -> rendered placeholders.
# Unresolved Level.io placeholders ({{VAR}}) are treated as missing.
# NEVER prints secret values.
set -uo pipefail

# mct_is_unset_or_unresolved VAR_VALUE
# Returns 0 (true) if value is empty or an unresolved {{placeholder}}.
mct_is_unset() {
  local value="${1:-}"
  if [ -z "$value" ]; then return 0; fi
  if [[ "$value" == *"{{"*"}}"* ]]; then return 0; fi
  return 1
}

# mct_get_var VAR_NAME [DEFAULT]
# Prints resolved value or DEFAULT. Never exits.
mct_get_var() {
  local name="$1"
  local default="${2:-}"
  local value="${!name:-}"
  if mct_is_unset "$value"; then
    printf '%s' "$default"
  else
    printf '%s' "$value"
  fi
}

# mct_require_var VAR_NAME [HUMAN_LABEL]
# Exits 2 if missing/unresolved with a clear message. Prints value otherwise.
mct_require_var() {
  local name="$1"
  local label="${2:-$1}"
  local value="${!name:-}"
  if mct_is_unset "$value"; then
    echo "ERROR: required variable $name ($label) is missing or unresolved" >&2
    echo "  Set it in Level.io (automation var/custom field) and render it into" >&2
    echo "  this script as an argument or environment variable." >&2
    exit 2
  fi
  printf '%s' "$value"
}

# mct_redact VALUE - safe display of a value (never reveals secrets).
mct_redact() {
  local value="${1:-}"
  if mct_is_unset "$value"; then
    printf '<unset>'
  else
    printf '<set:redacted>'
  fi
}

# mct_print_config [--secret VAR ...] VAR... - diagnostics.
# Non-secret vars print their value; --secret vars print <set:redacted>.
mct_print_config() {
  local secret=0
  local name value
  for name in "$@"; do
    if [ "$name" = "--secret" ]; then secret=1; continue; fi
    value="${!name:-}"
    if [ "$secret" -eq 1 ]; then
      printf '  %s=%s\n' "$name" "$(mct_redact "$value")"
    elif mct_is_unset "$value"; then
      printf '  %s=<unset>\n' "$name"
    else
      printf '  %s=%s\n' "$name" "$value"
    fi
  done
}

# mct_is_yes VALUE - normalizes yes/true/1.
mct_is_yes() {
  case "${1:-}" in
    yes|YES|true|TRUE|1) return 0 ;;
    *) return 1 ;;
  esac
}
