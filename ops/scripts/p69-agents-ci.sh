#!/usr/bin/env bash
# p69-agents-ci.sh - Phase 69 CI gate. Runs the pack-shipped validators, the
# 560-count inventory contract, report metadata compliance, and a secret scan.
# Exits non-zero on hard failure.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
GEN="$ROOT/ops/reports/generated/phase69"
EVID="$ROOT/ops/reports/evidence/p69"
SCRIPTS="$ROOT/ops/scripts"
PACK_VALIDATORS="/home/user/mct-p69/ops/scripts"

PASS=0; FAIL=0
run() { echo "=== $1 ==="; if "$@"; then echo "OK: $1"; PASS=$((PASS+1)); else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi; }

# 1) pack inventory contract (560 unique 000..559)
run python3 "$PACK_VALIDATORS/p69-inventory.py" "$GEN"

# 2) pack evidence validators
run python3 "$PACK_VALIDATORS/p69-resilience-validate.py" "$EVID/p69-resilience.json"
run python3 "$PACK_VALIDATORS/p69-permissions-validate.py" "$EVID/p69-permissions.json"
run python3 "$PACK_VALIDATORS/p69-ci-matrix-validate.py"     "$EVID/p69-ci-matrix.json"
run python3 "$PACK_VALIDATORS/p69-e2e-validate.py"            "$EVID/p69-e2e.json"

# 3) report metadata compliance
run python3 - "$GEN" <<'PY'
import sys, re, pathlib
gen = sys.argv[1]
files = list(pathlib.Path(gen).glob("*.md"))
digit = [f for f in files if re.match(r"^\d{3}-[a-z0-9-]+\.md$", f.name)]
ids = {f.name.split("-",1)[0] for f in digit}
REQ = ["Report ID:","Phase:","Title:","Date:","Timestamp:","Classification:","Status:","Source Path:"]
bad = 0
for f in digit:
    t = f.read_text()
    miss = [r for r in REQ if f"**{r}" not in t]
    if miss:
        bad += 1
        if bad <= 10: print("MISSING", f.name, miss)
bad_status = 0
for f in digit:
    m = re.search(r"\*\*Status:\*\*\s*(\S+)", f.read_text())
    if m and m.group(1) not in ("COMPLETE","PARTIAL","VERIFIED","BLOCKED","DEFERRED","PENDING","PLAN-ONLY"):
        bad_status += 1
        print("BAD STATUS", f.name, m.group(1))
assert len(digit) == 560, f"expected 560 got {len(digit)}"
assert len(ids) == 560, f"expected 560 unique indices got {len(ids)}"
assert bad == 0, f"{bad} files missing metadata"
assert bad_status == 0, f"{bad_status} bad statuses"
print("inventory + metadata OK (560)")
PY

# 4) secret-pattern scan
echo "=== secret-pattern scan ==="
if bash "$SCRIPTS/secret-pattern-scan.sh" >/tmp/p69-secret-scan.txt 2>&1; then
  echo "scan ran"; grep -iE "phase69|p69-" /tmp/p69-secret-scan.txt | head -20 || echo "(no phase69 secret hits)"
else
  echo "FAIL secret scan"; FAIL=$((FAIL+1))
fi

echo; echo "=== P69 CI summary: PASS=$PASS FAIL=$FAIL ==="
exit $FAIL
