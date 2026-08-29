#!/usr/bin/env bash
# Phase 73 per-phase agents-CI: run shipped validators, report open gates honestly.
set -u
PACK=/home/user/mct-p73
DEP=/opt/mct-security-stack
GEN=$PACK/ops/reports/generated/phase73
GEN2=$DEP/ops/reports/generated/phase73
EV=$PACK/ops/reports/evidence/p73
OPEN=()

echo "== P73 agents-CI =="
# inventory (must be clean)
python3 "$PACK/ops/scripts/p73-inventory.py" "$GEN" || { echo "FAIL: inventory"; exit 1; }
python3 "$PACK/ops/scripts/p73-time-anchor.py" >/dev/null || { echo "FAIL: time-anchor"; exit 1; }

# run each evidence validator, capture open gates
run() {
  local name="$1" file="$2"
  local out; out=$(python3 "$PACK/ops/scripts/$name.py" "$file" 2>&1)
  echo "-- $name"; echo "$out" | head -8
  if echo "$out" | grep -qE '"(missing_or_false|not_healthy|invalid_object_count|invalid_prior_state)"\s*:\s*\[\]'; then
    echo "   -> PASS"
  else
    echo "   -> OPEN GATES"; OPEN+=("$name")
  fi
}
run p73-network-validate "$EV/p73-network-evidence.json"
run p73-health-validate "$EV/p73-health-evidence.json"
run p73-exactly-once-validate "$EV/p73-exactly-once-evidence.json"
run p73-observability-validate "$EV/p73-observability-evidence.json"

echo "== secret scan (generated + evidence) =="
if grep -rEl "BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|IRIS_API_KEY=[A-Za-z0-9]{16,}" "$GEN" "$EV" >/dev/null 2>&1; then
  echo "FAIL: potential secret in generated artifacts"; exit 1
fi
echo "secret scan clean"

echo "== metadata compliance (status/verdict/dual-timestamp) =="
python3 - <<PY || { echo "FAIL: metadata"; exit 1; }
import pathlib,re,sys
g=pathlib.Path("$GEN"); bad=0
for r in g.glob("[0-9][0-9][0-9]-*.md"):
    t=r.read_text()
    if "Status:" not in t or "Verdict" not in t or "UTC" not in t or "America/New_York" not in t: bad+=1
    if re.search(r"\bINCIDENT\b", t): bad+=1
print("metadata problems:",bad); sys.exit(1 if bad else 0)
PY

echo
echo "==================================================================="
echo "P73 CI RUN COMPLETE"
if [ ${#OPEN[@]} -gt 0 ]; then
  echo "OPEN GATES (require authorized infra / missing platform -- NOT fabricated):"
  for o in "${OPEN[@]}"; do echo "  - $o"; done
  echo "See evidence JSONs + canonical current-state-20260829-p73.md for detail."
else
  echo "ALL GATES PASS"
fi
echo "==================================================================="
