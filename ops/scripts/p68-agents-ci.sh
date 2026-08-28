#!/usr/bin/env bash
# p68-agents-ci.sh - Phase 68 CI gate (pack ships no validators; this enforces the
# 540-count contract + metadata compliance + secret scan). Exits non-zero on hard failure.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
GEN="$ROOT/ops/reports/generated/phase68"
EVID="$ROOT/ops/evidence"
SCRIPTS="$ROOT/ops/scripts"

PASS=0; FAIL=0
run() { echo "=== $1 ==="; if "$@"; then echo "OK: $1"; PASS=$((PASS+1)); else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi; }

run python3 - "$GEN" <<'PY'
import sys, re
gen = sys.argv[1]
files = list(__import__('pathlib').Path(gen).glob("*.md"))
digit = [f for f in files if re.match(r"^\d{3}-[a-z0-9-]+\.md$", f.name)]
ids = {f.name.split("-",1)[0] for f in digit}
print("total md:", len(files), "| digit-prefixed:", len(digit), "| unique indices:", len(ids))
REQ = ["Report ID:","Phase:","Title:","Date:","Timestamp:","Classification:","Status:","Source Path:"]
bad = 0
for f in digit:
    t = f.read_text()
    miss = [r for r in REQ if f"**{r}" not in t]
    if miss:
        bad += 1
        if bad <= 10: print("MISSING", f.name, miss)
# status enum sanity
import collections
bad_status = 0
for f in digit:
    m = re.search(r"\*\*Status:\*\*\s*(\S+)", f.read_text())
    if m and m.group(1) not in ("COMPLETE","PARTIAL","VERIFIED","BLOCKED","DEFERRED","PENDING","PLAN-ONLY"):
        bad_status += 1
        print("BAD STATUS", f.name, m.group(1))
assert len(digit) == 540, f"expected 540 got {len(digit)}"
assert len(ids) == 540, f"expected 540 unique indices got {len(ids)}"
assert bad == 0, f"{bad} files missing metadata"
assert bad_status == 0, f"{bad_status} bad statuses"
print("inventory + metadata OK")
PY

run bash -c 'for j in p68-correlation p68-markers p68-credential p68-tls p68-retry; do test -f "$1/$j.json" || exit 1; done; echo evidence present' bash "$EVID"

echo "=== secret-pattern scan ==="
if bash "$SCRIPTS/secret-pattern-scan.sh" >/tmp/p68-secret-scan.txt 2>&1; then
  echo "scan ran"; grep -iE "phase68|p68-" /tmp/p68-secret-scan.txt | head -10 || echo "(no phase68 secret hits)"
else
  echo "FAIL secret scan"; FAIL=$((FAIL+1))
fi

echo; echo "=== P68 CI summary: PASS=$PASS FAIL=$FAIL ==="
exit $FAIL
