#!/usr/bin/env bash
# p39-canonical-ci.sh — Phase 39 post-migration canonical-tree CI gates
# Checks: INDEX.md present, manifest self-hash intact, metadata headers (era-aware sample),
# secret patterns, duplicate report_ids across phases/.
# Exit codes: 0 = PASS, 1 = FAIL.
set -u

ROOT="/opt/mct-security-stack"
CAN="$ROOT/ops/reports/canonical"
ERR=0; WARN=0
say()  { echo "$*"; }
fail() { ERR=$((ERR+1)); say "FAIL: $*"; }
warn() { WARN=$((WARN+1)); say "WARN: $*"; }
ok()   { say "PASS: $*"; }

say "=== Phase 39 Canonical CI ==="
say "Run at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
say ""

# ---- Gate 1: INDEX.md exists -------------------------------------------------
if [ -f "$CAN/INDEX.md" ]; then ok "Gate1 index: canonical/INDEX.md present"; else fail "Gate1 index: canonical/INDEX.md MISSING"; fi
say ""

# ---- Gate 2: manifest hash matches sidecar -----------------------------------
WANT=$(cut -d' ' -f1 "$CAN/MIGRATION-MANIFEST.sha256" 2>/dev/null)
GOT=$(sha256sum "$CAN/migration-manifest.json" 2>/dev/null | cut -d' ' -f1)
if [ -n "$WANT" ] && [ "$WANT" = "$GOT" ]; then ok "Gate2 manifest hash: $GOT matches MIGRATION-MANIFEST.sha256"
else fail "Gate2 manifest hash: want=$WANT got=$GOT"; fi
ROWS=$(python3 -c "import json;print(json.load(open('$CAN/migration-manifest.json'))['meta']['row_count'])" 2>/dev/null)
COPIES=$(find "$CAN" -type f | wc -l)
say "      manifest rows=$ROWS files-on-disk-in-canonical=$COPIES"
say ""

# ---- Gate 3: metadata headers on sampled .md files (era-aware) ---------------
# Modern era (final-*, phase38-*, phase39-*, ledger/catalog/index infra): header REQUIRED.
# Legacy corpus (pre-P38 flat files copied verbatim): counted, informational only — immutable history.
mapfile -t ALLMD < <(find "$CAN" -type f -name "*.md" ! -name "INDEX.md" ! -name "evidence-index.md" | sort)
N=${#ALLMD[@]}
SAMPLE=30
mapfile -t SEL < <(for ((i=0; i<N; i+= (N/SAMPLE+1) )); do echo "${ALLMD[$i]}"; done)
MOD_OK=0; MOD_BAD=0; LEGACY=0
for f in "${SEL[@]}"; do
  b=$(basename "$f")
  if grep -q "^\*\*Report ID:" "$f"; then :; fi
  if [[ "$b" == final-phase* || "$b" == phase38-* || "$b" == phase39-* || "$b" == *ledger* || "$b" == catalog-reports* ]]; then
    if grep -q "^\*\*Report ID:" "$f"; then MOD_OK=$((MOD_OK+1)); else MOD_BAD=$((MOD_BAD+1)); fail "Gate3 headers: modern file missing Report ID: $b"; fi
  else
    LEGACY=$((LEGACY+1))
  fi
done
ok "Gate3 headers: modern-sampled OK=$MOD_OK bad=$MOD_BAD; legacy-era sampled (headers not required)=$LEGACY of ${#SEL[@]} sampled from $N md files"
say ""

# ---- Gate 4: secret patterns across canonical tree ---------------------------
HIGH_HITS=0; LOW_FILES=0; LOW_LINES=0
while IFS= read -r -d '' f; do
  h=$(grep -cE 'stCG-[A-Za-z0-9]{20,}|Bearer [A-Za-z0-9_-]{20,}|0c953f60-5cca' "$f" || true)
  l=$(grep -ciE '(password|token|api[_-]key)[[:space:]]*[:=][[:space:]]*[A-Za-z0-9/+]{8,}' "$f" || true)
  HIGH_HITS=$((HIGH_HITS+h))
  if [ "$l" -gt 0 ]; then LOW_FILES=$((LOW_FILES+1)); LOW_LINES=$((LOW_LINES+l)); fi
done < <(find "$CAN" -type f -print0)
if [ "$HIGH_HITS" -eq 0 ]; then ok "Gate4 secrets high-confidence: 0 hits tree-wide"
else fail "Gate4 secrets high-confidence: $HIGH_HITS hits — INVESTIGATE BEFORE COMMIT"; fi
say "SUMMARY Gate4 low-confidence assignment-pattern lines: files_with_hits=$LOW_FILES total_lines=$LOW_LINES (informational: historical docs)"
say ""

# ---- Gate 5: duplicate report_ids across phases/ -----------------------------
DUPES=$(grep -rh "^\*\*Report ID:\*\*" "$CAN/phases" 2>/dev/null | sed 's/\*\*Report ID:\*\*[[:space:]]*//' | sort | uniq -d)
if [ -z "$DUPES" ]; then ok "Gate5 report_ids in phases/: unique"
else
  ND=$(echo "$DUPES" | wc -l); warn "Gate5 report_ids in phases/: $ND duplicated id(s): $(echo "$DUPES" | tr '\n' ' ')"
fi
say ""

say "=== CANONICAL CI SUMMARY ==="
say "errors=$ERR warnings=$WARN"
if [ "$ERR" -gt 0 ]; then say "RESULT: FAIL"; exit 1; fi
say "RESULT: PASS ($WARN warnings)"
exit 0
