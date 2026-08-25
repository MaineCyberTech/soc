#!/usr/bin/env bash
# p38-report-ci.sh — Phase 38-71 report corpus CI gates
# Checks generated/*.md reports for: required metadata fields, duplicate report_ids,
# invalid status enums, secret patterns, broken internal links, stale/superseded refs.
# Exit codes: 0 = PASS (warnings allowed), 1 = FAIL.
set -u

GEN="/opt/mct-security-stack/ops/reports/generated"
ERR=0; WARN=0
declare -a SECRETS_TOTAL

say()  { echo "$*"; }
fail() { ERR=$((ERR+1)); say "FAIL: $*"; }
warn() { WARN=$((WARN+1)); say "WARN: $*"; }
ok()   { say "PASS: $*"; }

say "=== Phase 38 Report CI ==="
say "Scope: $GEN"
say "Run at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
say ""

FILES=$(find "$GEN" -maxdepth 1 -name "phase38-*.md" -type f | sort)
COUNT=$(echo "$FILES" | wc -l)
say "Files in scope: $COUNT"
say ""

# ---- Gate 1: required metadata fields --------------------------------------
REQUIRED=("Report ID:" "Phase:" "Title:" "Date:" "Timestamp:" "Classification:" "Status:" "Source Path:")
G1_BAD=0
for f in $FILES; do
  base=$(basename "$f")
  miss=""
  for field in "${REQUIRED[@]}"; do
    grep -q "^\*\*${field}" "$f" || miss="$miss ${field%:}"
  done
  if [ -n "$miss" ]; then
    G1_BAD=$((G1_BAD+1))
    if [ "$G1_BAD" -le 10 ]; then fail "$base missing metadata:$miss"; fi
  fi
done
[ "$G1_BAD" -gt 0 ] && [ "$G1_BAD" -gt 10 ] && say "FAIL: ...and $((G1_BAD-10)) more files missing metadata"
[ "$G1_BAD" -eq 0 ] && ok "Gate1 metadata: all $COUNT files carry required fields"
say ""

# ---- Gate 2: duplicate report_ids ------------------------------------------
DUPES=$(grep -h "^\*\*Report ID:\*\*" $FILES | sed 's/\*\*Report ID:\*\*[[:space:]]*//' | sort | uniq -d)
if [ -z "$DUPES" ]; then ok "Gate2 report_ids: unique across corpus"; else
  fail "duplicate report_ids: $(echo $DUPES | tr '\n' ' ')"; fi
say ""

# ---- Gate 3: status enum validity -------------------------------------------
VALID="^(COMPLETE|IN PROGRESS|IN-PROGRESS|PARTIAL|PENDING|BLOCKED|DEFERRED|UNKNOWN|UNVERIFIED|CONTRADICTED|STALE|PASS|FAIL|RETIRED|NOT APPLICABLE|PLAN-ONLY|DRAFT)"
G3_BAD=0
for f in $FILES; do
  base=$(basename "$f")
  st=$(grep -m1 "^\*\*Status:\*\*" "$f" | sed 's/\*\*Status:\*\*[[:space:]]*//' | xargs)
  if [ -n "$st" ] && ! echo "$st" | grep -qiE "$VALID"; then
    G3_BAD=$((G3_BAD+1)); fail "$base invalid status: '$st'"
  fi
done
[ "$G3_BAD" -eq 0 ] && ok "Gate3 status enum: all values valid"
say ""

# ---- Gate 4: secret patterns -------------------------------------------------
SECRET_PATTERNS=('password[[:space:]]*=[:=][[:space:]]*' 'token[[:space:]]*=[:=][[:space:]]*' 'api[_-]key[[:space:]]*=[:=][[:space:]]*' 'Bearer [A-Za-z0-9-]{20,}' 'P@ssw0rd' 'stCG-[A-Za-z0-9]{20,}')
TOTAL_SECRET_HITS=0
FILES_WITH_SECRETS=0
for f in $FILES; do
  base=$(basename "$f")
  hits=0
  for pat in "${SECRET_PATTERNS[@]}"; do
    n=$(grep -ciE "$pat" "$f" || true)
    hits=$((hits+n))
  done
  if [ "$hits" -gt 0 ]; then
    FILES_WITH_SECRETS=$((FILES_WITH_SECRETS+1))
    TOTAL_SECRET_HITS=$((TOTAL_SECRET_HITS+hits))
    warn "$base contains secret-pattern lines: $hits"
  fi
done
say "SUMMARY Gate4 secrets: files_with_hits=$FILES_WITH_SECRETS total_matching_lines=$TOTAL_SECRET_HITS"
say ""

# ---- Gate 5: broken internal links among generated files --------------------
BROKEN=0
for f in $FILES; do
  base=$(basename "$f")
  for link in $(grep -oE '\]\([^)/]+\.md\)' "$f" | sed 's/](//;s/)//'); do
    if [ ! -f "$GEN/$link" ]; then BROKEN=$((BROKEN+1)); fail "$base broken link -> $link"; fi
  done
done
[ "$BROKEN" -eq 0 ] && ok "Gate5 links: no broken relative .md links among generated files"
say ""

# ---- Gate 6: stale refs to nonexistent phase38 reports ---------------------
STALE=0
for f in $FILES; do
  base=$(basename "$f")
  for rid in $(grep -ohE 'phase38-[0-9]{2}-[a-z0-9-]+' "$f" | sort -u); do
    if ! ls "$GEN/$rid.md" >/dev/null 2>&1; then STALE=$((STALE+1)); warn "$base references missing report: $rid"; fi
  done
done
[ "$STALE" -eq 0 ] && ok "Gate6 stale refs: every referenced phase38 report exists on disk"
say ""

say "=== CI SUMMARY ==="
say "files=$COUNT errors=$ERR warnings=$WARN (secret_lines=$TOTAL_SECRET_HITS in $FILES_WITH_SECRETS files)"
if [ "$ERR" -gt 0 ]; then say "RESULT: FAIL"; exit 1; fi
say "RESULT: PASS ($WARN warnings)"
exit 0
