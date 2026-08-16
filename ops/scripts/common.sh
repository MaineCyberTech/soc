#!/usr/bin/env bash
# Common helpers for phase 2 operational scripts.
# Source with: . "$(dirname "$0")/common.sh"
set -uo pipefail

TS=$(date +%Y%m%d-%H%M%S)
MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
LOG_DIR="${MCT_ROOT}/ops/reports"

log() { echo "[$(date +%H:%M:%S)] $*"; }
warn() { echo "[$(date +%H:%M:%S)] WARN: $*" >&2; }
die()  { echo "[$(date +%H:%M:%S)] FATAL: $*" >&2; exit 1; }

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || die "required command not found: $cmd"
}

# health_http URL [expected_http_code]
health_http() {
  local url="$1" expected="${2:-200}"
  local code
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 "$url" 2>/dev/null)
  [[ "$code" == "$expected" ]]
}

# health_tcp host port
health_tcp() {
  timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null
}
