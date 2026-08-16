#!/usr/bin/env bash
# exit-safe-mode-checklist.sh
# Restores phase 2 services after safe mode. Dry-run by default.
# Usage: exit-safe-mode-checklist.sh [--apply]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
APPLY=0
[[ "${1:-}" == "--apply" ]] && APPLY=1

echo "== Exit safe mode ($([ $APPLY -eq 1 ] && echo APPLY || echo DRY-RUN)) =="

stacks=(
  "docker-compose.opencanary.yml|opencanary"
  "docker-compose.shuffle.yml|shuffle"
  "docker-compose.velociraptor.yml|velociraptor"
  "docker-compose.dfir-iris.yml|iris"
  "docker-compose.misp.yml|misp"
  "docker-compose.greenbone.yml|greenbone"
)

for entry in "${stacks[@]}"; do
  file="${entry%%|*}"; profile="${entry##*|}"
  if [[ -f "$ROOT/compose/$file" ]]; then
    echo "--- $file (profile $profile)"
    if [ $APPLY -eq 1 ]; then
      (cd "$ROOT" && docker compose -f "compose/$file" --profile "$profile" up -d 2>&1 | tail -2)
      sleep 5
    else
      echo "  would start: docker compose -f compose/$file --profile $profile up -d"
    fi
  fi
done

echo
echo "== Post-restore checklist =="
checks=(
  "docker ps | grep -q multi-node-wazuh.master-1|Wazuh master running"
  "docker ps | grep -q multi-node-wazuh.worker-1|Wazuh worker running"
  "docker ps | grep -q shuffle-backend|Shuffle backend running"
  "docker ps | grep -q iriswebapp_nginx|IRIS running"
  "docker ps | grep -q mct-security-stack-opencanary-1|OpenCanary running"
  "ss -tulpen | grep -q ':8443'|IRIS port 8443 listening"
)
for c in "${checks[@]}"; do
  cmd="${c%%|*}"; label="${c##*|}"
  if eval "$cmd" 2>/dev/null; then echo "  [PASS] $label"; else echo "  [FAIL] $label"; fi
done

echo
echo "Recommended verification:"
echo "  /opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh"
echo "  /opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh"
echo "  /opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --dry-run"
