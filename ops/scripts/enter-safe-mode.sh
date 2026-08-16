#!/usr/bin/env bash
# enter-safe-mode.sh
# Stops phase 2 services while PROTECTING Wazuh. Dry-run by default.
# Usage: enter-safe-mode.sh [--apply]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
APPLY=0
[[ "${1:-}" == "--apply" ]] && APPLY=1

echo "== Safe mode ($([ $APPLY -eq 1 ] && echo APPLY || echo DRY-RUN)) =="
echo "Wazuh stack is NEVER touched by this script."

stacks=(
  "docker-compose.dfir-iris.yml|iris"
  "docker-compose.velociraptor.yml|velociraptor"
  "docker-compose.shuffle.yml|shuffle"
  "docker-compose.misp.yml|misp"
  "docker-compose.greenbone.yml|greenbone"
  "docker-compose.opencanary.yml|opencanary"
)

for entry in "${stacks[@]}"; do
  file="${entry%%|*}"; profile="${entry##*|}"
  if [[ -f "$ROOT/compose/$file" ]]; then
    echo "--- $file (profile $profile)"
    if [ $APPLY -eq 1 ]; then
      (cd "$ROOT" && docker compose -f "compose/$file" --profile "$profile" stop 2>&1 | tail -2)
    else
      echo "  would stop: docker compose -f compose/$file --profile $profile stop"
    fi
  fi
done

if [ $APPLY -eq 1 ]; then
  echo
  echo "Verifying Wazuh still healthy..."
  if docker ps --format '{{.Names}}' | grep -q 'multi-node-wazuh.master-1'; then
    echo "[OK] Wazuh master still running"
  else
    echo "[CRITICAL] Wazuh master down - investigate immediately"
  fi
  echo "Run exit-safe-mode-checklist.sh --apply to restore."
else
  echo
  echo "Dry-run: no changes made. Re-run with --apply to stop services."
  echo "Wazuh containers remain untouched in both modes."
fi
