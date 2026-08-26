#!/usr/bin/env bash
# shuffle-repair-network.sh
# Repairs known Shuffle network issue: worker/app replicas lose the mct-security
# bridge network after restart. Safe to run repeatedly (idempotent).
# Usage: shuffle-repair-network.sh [--apply]  (default: dry-run / report only)
set -uo pipefail

NETWORK=${NETWORK:-mct-security}
APPLY=0
[[ "${1:-}" == "--apply" ]] && APPLY=1

echo "== Shuffle network repair ($([ $APPLY -eq 1 ] && echo APPLY || echo DRY-RUN)) =="

if ! docker network inspect "$NETWORK" >/dev/null 2>&1; then
  echo "ERROR: Docker network $NETWORK not found"
  exit 1
fi

containers=(
  shuffle-backend
  shuffle-frontend
  shuffle-opensearch
  shuffle-orborus
)

mapfile -t running < <(docker ps --format '{{.Names}}' | grep -Ei 'shuffle|worker|frontend|backend' || true)

need=()
for c in $(printf '%s\n' "${containers[@]}" "${running[@]}" | sort -u); do
  if ! docker inspect "$c" --format '{{json .NetworkSettings.Networks}}' 2>/dev/null | grep -q "\"$NETWORK\""; then
    need+=("$c")
  fi
done

if [ ${#need[@]} -eq 0 ]; then
  echo "PASS: all Shuffle-like containers are on $NETWORK"
else
  echo "MISSING: ${#need[@]} containers not on $NETWORK:"
  printf '  - %s\n' "${need[@]}"
  if [ $APPLY -eq 1 ]; then
    for c in "${need[@]}"; do
      echo "CONNECT: $c -> $NETWORK"
      docker network connect "$NETWORK" "$c" && echo "  OK" || echo "  FAILED (may need manual attach)"
    done
  else
    echo "Run with --apply to connect them."
  fi
fi

echo "== DNS checks =="
for c in shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu shuffle-backend; do
  if docker ps --format '{{.Names}}' | grep -qx "$c"; then
    echo "--- $c"
    docker exec "$c" sh -lc 'getent hosts shuffle-backend || echo "NO-RESOLVE shuffle-backend"' 2>/dev/null || echo "  exec failed"
    docker exec "$c" sh -lc 'getent hosts iriswebapp_nginx || echo "NO-RESOLVE iriswebapp_nginx"' 2>/dev/null || true
  fi
done

# P42 churn fix: restart ONLY when frontend was actually reconnected this run
FRONTEND_REPAIRED=0
for c in "${need[@]:-}"; do
  [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
done
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ] && [ $FRONTEND_REPAIRED -eq 1 ]; then
  echo "Restarting shuffle-frontend (was reconnected this run) to clear cached backend IP"
  docker restart shuffle-frontend >/dev/null && echo "  restarted" || echo "  restart failed"
else
  echo "NO-OP: frontend network intact; no restart needed"
fi

echo "== Done =="
exit 0
