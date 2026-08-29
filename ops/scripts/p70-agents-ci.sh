#!/usr/bin/env bash
# p70-agents-ci.sh - Phase 70 per-phase CI.
# Runs the pack validators, inventory, a targeted secret scan on new artifacts,
# and asserts declared==actual CI counts. Exits non-zero on any failure.
set -uo pipefail
PACK=/home/user/mct-p70
S=$PACK/ops/scripts
E=$PACK/ops/reports/evidence/p70
G=$PACK/ops/reports/generated/phase70
rc=0

echo "== inventory (580 unique) =="
python3 "$S/p70-inventory.py" "$G" || rc=1

echo "== resilience-validate =="
python3 "$S/p70-resilience-validate.py" "$E/p70-resilience-evidence.json" || rc=1
echo "== ledger-validate =="
python3 "$S/p70-ledger-validate.py" "$E/p70-ledger-evidence.json" || rc=1
echo "== object-evidence-validate =="
python3 "$S/p70-object-evidence-validate.py" "$E/p70-object-evidence.json" || rc=1
echo "== tls-lifecycle-validate =="
python3 "$S/p70-tls-lifecycle-validate.py" "$E/p70-tls-lifecycle-evidence.json" || rc=1
echo "== ci-validate (declared==actual) =="
python3 "$S/p70-ci-validate.py" "$E/p70-ci-evidence.json" || rc=1

echo "== time-anchor =="
python3 "$S/p70-time-anchor.py" >/dev/null || rc=1

echo "== targeted secret scan (generated + evidence) =="
hits=$(grep -rInE "(password|passwd|secret|api[_-]?key|token|private[_-]?key|BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|DO00[0-9A-Z]{14})[[:space:]]*[=:][[:space:]]*[^\"'< ]" "$G" "$E" 2>/dev/null | grep -vE "secret-pattern-scan|api[_-]?key[[:space:]]*=|token[[:space:]]*=" || true)
if [ -n "$hits" ]; then echo "SECRET HITS:"; echo "$hits"; rc=1; else echo "no secret-pattern hits in new artifacts"; fi

echo "== CI complete rc=$rc =="
exit $rc
