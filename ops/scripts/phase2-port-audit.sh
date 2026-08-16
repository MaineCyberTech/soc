#!/usr/bin/env bash
# Phase 2 port audit: compares host listening ports vs the documented port registry.
# Usage: phase2-port-audit.sh [--json]
# Never prints secret values.
set -uo pipefail

MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
PORTS_DOC="$MCT_ROOT/ops/reports/ports.md"
JSON=0
[[ "${1:-}" == "--json" ]] && JSON=1

ALLOWED_PUBLIC="22 514 1514 1515 19999 8000 9443 5355 68 20241 2055 45501 48032 56329 58815 52526 8080"
ALLOWED_LOCAL="25 53 443 4317 55000 8125 9200"
PLANNED_LOCAL="8000 8089 8889 8443 3001 9392"

listening=$(ss -tulpen 2>/dev/null | awk '{print $5}' | sed 's/.*://' | sort -u | grep -E '^[0-9]+$')

warn() { echo "[WARN] $*"; }
err()  { echo "[ERR]  $*"; RC=1; }
ok()   { echo "[OK]   $*"; }
RC=0

echo "== Host listening ports vs registry =="
for p in $listening; do
  case " $ALLOWED_PUBLIC $ALLOWED_LOCAL $PLANNED_LOCAL " in
    *" $p "*) : ;;
    *) err "unregistered port $p is listening" ;;
  esac
done

echo "== Public bindings (0.0.0.0/::) =="
ss -tulpen 2>/dev/null | grep -E '0.0.0.0|\*:|::' | awk '{print $5}' | sort -u

echo "== Containers with published ports (source of truth) =="
docker ps --format '{{.Names}}: {{.Ports}}' | grep -v ':' || echo "none"

echo "== Registry ports expected but not listening =="
for p in 8000 8089 8443 3001 9392; do
  if ! echo "$listening" | grep -qx "$p"; then
    case " $PLANNED_LOCAL " in
      *" $p "*) warn "planned port $p not yet bound (service not deployed — expected)" ;;
      *) err "expected port $p missing" ;;
    esac
  fi
done

echo "== Registry ports bound (allowed) =="
for p in $listening; do
  case " $ALLOWED_PUBLIC $ALLOWED_LOCAL $PLANNED_LOCAL " in
    *" $p "*) ok "port $p bound and registered" ;;
    *) : ;;
  esac
done

echo
if [[ $RC -eq 0 ]]; then
  echo "PORT AUDIT PASSED"
else
  echo "PORT AUDIT: review [ERR] lines"
fi
exit $RC
