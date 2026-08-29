#!/usr/bin/env bash
# Phase 72 per-phase agents-CI: shipped validators + secret scan + redaction + metadata compliance.
set -u
PACK=/home/user/mct-p71
PACK=/home/user/mct-p72
DEP=/opt/mct-security-stack
GEN=$PACK/ops/reports/generated/phase72
GEN2=$DEP/ops/reports/generated/phase72
EV=$PACK/ops/reports/evidence/p72

fail=0
echo "== P72 agents-CI =="
python3 - <<PY || fail=1
import json, pathlib, sys, re
GEN=pathlib.Path("$GEN"); GEN2=pathlib.Path("$GEN2"); EV=pathlib.Path("$EV")
msgs=[]
def err(m): msgs.append("FAIL: "+m)

reports=sorted(GEN.glob("[0-9][0-9][0-9]-*.md"))
ids={r.name for r in reports}
if len(reports)!=620: err(f"generated count {len(reports)} != 620")
if len(ids)!=len(reports): err("duplicate report filenames")
if GEN2.exists():
    rep2=sorted(GEN2.glob("[0-9][0-9][0-9]-*.md"))
    if len(rep2)!=len(reports): err(f"mirror count {len(rep2)} != {len(reports)}")

for n in ["p72-network-evidence.json","p72-monitor-evidence.json","p72-replay-evidence.json","p72-correlation-evidence.json","p72-time-anchor.json"]:
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

inc=0
for r in reports:
    for line in r.read_text().splitlines():
        if re.search(r"\bINCIDENT\b", line): inc+=1
if inc: err(f"{inc} reports contain a literal INCIDENT line")

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
if grep -rEl "BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|IRIS_API_KEY=[A-Za-z0-9]{16,}" "$GEN" "$EV" >/dev/null 2>&1; then
  echo "FAIL: potential secret in generated artifacts"; exit 1
fi
echo "secret scan clean"

echo "== run shipped pack validators =="
python3 "$PACK/ops/scripts/p72-network-validate.py" "$EV/p72-network-evidence.json" || { echo "FAIL: network"; exit 1; }
python3 "$PACK/ops/scripts/p72-monitor-validate.py" "$EV/p72-monitor-evidence.json" || { echo "FAIL: monitor"; exit 1; }
python3 "$PACK/ops/scripts/p72-replay-validate.py" "$EV/p72-replay-evidence.json" || { echo "FAIL: replay"; exit 1; }
python3 "$PACK/ops/scripts/p72-correlation-validate.py" "$EV/p72-correlation-evidence.json" || { echo "FAIL: correlation"; exit 1; }
python3 "$PACK/ops/scripts/p72-inventory.py" "$GEN" || { echo "FAIL: inventory"; exit 1; }
python3 "$PACK/ops/scripts/p72-time-anchor.py" >/dev/null || { echo "FAIL: time-anchor"; exit 1; }

echo "ALL P72 AGENTS-CI CHECKS PASSED"
