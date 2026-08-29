#!/usr/bin/env bash
# Phase 71 per-phase agents-CI: verify shipped validators + secret scan + redaction + metadata compliance.
set -u
PACK=/home/user/mct-p71
DEP=/opt/mct-security-stack
GEN=$PACK/ops/reports/generated/phase71
GEN2=$DEP/ops/reports/generated/phase71
EV=$PACK/ops/reports/evidence/p71

fail=0
echo "== P71 agents-CI =="
python3 - <<PY || fail=1
import json, pathlib, sys, re
GEN=pathlib.Path("$GEN"); GEN2=pathlib.Path("$GEN2"); EV=pathlib.Path("$EV")
msgs=[]
def err(m): msgs.append("FAIL: "+m)

# 1) inventory: 600 unique prompt-derived reports (digit-prefix naming)
reports=sorted(GEN.glob("[0-9][0-9][0-9]-*.md"))
ids={r.name for r in reports}
if len(reports)!=600: err(f"generated count {len(reports)} != 600")
if len(ids)!=len(reports): err("duplicate report filenames")
if GEN2.exists():
    rep2=sorted(GEN2.glob("[0-9][0-9][0-9]-*.md"))
    if len(rep2)!=len(reports): err(f"mirror count {len(rep2)} != {len(reports)}")

# 2) evidence JSONs present + truthy
for n in ["p71-recreate-evidence.json","p71-monitor-evidence.json","p71-replay-evidence.json","p71-restore-parity-evidence.json","p71-192-193-reconciliation.json","p71-time-anchor.json"]:
    p=EV/n
    if not p.exists(): err(f"missing evidence {n}"); continue
    d=json.loads(p.read_text())
    def walk(o,path=""):
        if isinstance(o,dict):
            for k,v in o.items(): walk(v,path+"/"+k)
        elif isinstance(o,bool):
            if o is False: err(f"{n}{path} is False (fabricated/missing)")
        elif isinstance(o,str):
            if o.strip()=="" : err(f"{n}{path} empty")
    walk(d)

# 3) classified safety: no 'INCIDENT' lines in generated reports
inc=0
for r in reports:
    for line in r.read_text().splitlines():
        if re.search(r"\bINCIDENT\b", line): inc+=1
if inc: err(f"{inc} reports contain a literal INCIDENT line")

# 4) every report has Status + Verdict + both timestamps
for r in reports:
    t=r.read_text()
    if "Status:" not in t: err(f"{r.name} missing Status")
    if "Verdict" not in t: err(f"{r.name} missing Verdict")
    if "UTC" not in t or "America/New_York" not in t: err(f"{r.name} missing dual timestamp")

for m in msgs: print(m)
sys.exit(1 if msgs else 0)
PY
[ $fail -eq 0 ] || { echo "CI FAILED"; exit 1; }

echo "== secret scan (generated + evidence) =="
# no private key blocks or obvious secrets in generated content
if grep -rEl "BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|iris_api_key|IRIS_API_KEY=[A-Za-z0-9]{16,}" "$GEN" "$EV" >/dev/null 2>&1; then
  echo "FAIL: potential secret in generated artifacts"; exit 1
fi
echo "secret scan clean"

echo "== run shipped pack validators =="
declare -A VM=(
  [p71-recreate-validate]="$EV/p71-recreate-evidence.json"
  [p71-monitor-validate]="$EV/p71-monitor-evidence.json"
  [p71-replay-validate]="$EV/p71-replay-evidence.json"
  [p71-restore-parity]="$EV/p71-restore-parity-evidence.json"
  [p71-inventory]="$GEN"
)
for v in p71-recreate-validate p71-monitor-validate p71-replay-validate p71-restore-parity p71-inventory p71-time-anchor; do
  echo "-- $v"
  if [ -n "${VM[$v]:-}" ]; then
    python3 "$PACK/ops/scripts/$v.py" "${VM[$v]}" || { echo "FAIL: $v"; exit 1; }
  else
    python3 "$PACK/ops/scripts/$v.py" >/dev/null || { echo "FAIL: $v"; exit 1; }
  fi
done

echo "ALL P71 AGENTS-CI CHECKS PASSED"
