#!/usr/bin/env bash
# p39-agents-ci.sh — Phase 39 AGENTS.md governance CI
# Gates the root AGENTS.md: existence, required sections, secret patterns,
# volatile-metric regexes, referenced script/doc paths, length sanity.
# Exit codes: 0 = PASS (warnings allowed), 1 = FAIL.
set -u

ROOT="/opt/mct-security-stack"
F="$ROOT/AGENTS.md"
ERR=0; WARN=0
say()  { echo "$*"; }
fail() { ERR=$((ERR+1)); say "FAIL: $*"; }
warn() { WARN=$((WARN+1)); say "WARN: $*"; }
ok()   { say "PASS: $*"; }

say "=== Phase 39 AGENTS.md Governance CI ==="
say "Target: $F"
say "Run at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
say ""

# ---- Gate 1: existence ------------------------------------------------------
if [ ! -f "$F" ]; then fail "AGENTS.md missing at repo root"; say "RESULT: FAIL"; exit 1; fi
ok "Gate1 existence: root AGENTS.md present"

# ---- Gate 2: hierarchy — root only, list any nested -------------------------
NESTED=$(find "$ROOT" -mindepth 2 -iname "AGENTS.md" -not -path "*/node_modules/*" 2>/dev/null)
if [ -n "$NESTED" ]; then warn "nested instruction files found: $NESTED"; else
  ok "Gate2 hierarchy: single root file, no nested AGENTS.md"; fi

# ---- Gate 3: required section headers ---------------------------------------
SECTIONS=("## Purpose & Scope" "## Repository Map" "## Canonical Truth & Navigation" \
"## Required Gates Before Commit" "## Operational Safety Rules" "## Approval-Gated Operations" \
"## Known Blockers" "## Credential Handling" "## Report Authoring Conventions" \
"## Out of Scope" "## Escalation & Owners")
MISS=0
for s in "${SECTIONS[@]}"; do
  grep -qF "$s" "$F" || { MISS=$((MISS+1)); fail "missing section: $s"; }
done
[ "$MISS" -eq 0 ] && ok "Gate3 sections: all ${#SECTIONS[@]} required headers present"

# ---- Gate 4: secret patterns (same set as p38-report-ci.sh Gate4) ------------
SECRET_PATTERNS=('password[[:space:]]*=[:=][[:space:]]*' 'token[[:space:]]*=[:=][[:space:]]*' 'api[_-]key[[:space:]]*=[:=][[:space:]]*' 'Bearer [A-Za-z0-9-]{20,}' 'P@ssw0rd' 'stCG-[A-Za-z0-9]{20,}')
HITS=0
for pat in "${SECRET_PATTERNS[@]}"; do
  n=$(grep -ciE "$pat" "$F" || true); HITS=$((HITS+n))
  [ "$n" -gt 0 ] && fail "secret pattern '$pat' matched $n line(s)"
done
[ "$HITS" -eq 0 ] && ok "Gate4 secrets: zero secret-pattern lines"
say ""

# ---- Gate 5: volatile-metric regexes ----------------------------------------
VOLATILE=0
while IFS= read -r m; do VOLATILE=$((VOLATILE+1)); fail "volatile metric line: $(echo "$m" | cut -c1-80)…"; done < <(grep -inE '(disk|mem|memory|swap|tmp)[^0-9]*[0-9]+ ?%' "$F")
while IFS= read -r m; do VOLATILE=$((VOLATILE+1)); fail "bearer-like string: $(echo "$m" | cut -c1-60)…"; done < <(grep -inE '(Bearer|bearer)[[:space:]]+[A-Za-z0-9_-]{16,}' "$F")
# IPv4 literals other than loopback 127.0.0.1 are drift-prone
IP_HITS=$(grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$F" | grep -v '^127\.0\.0\.1$' | sort -u | wc -l)
if [ "$IP_HITS" -gt 0 ]; then
  while IFS= read -r ip; do fail "volatile IP literal: $ip"; done < <(grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$F" | grep -v '^127\.0\.0\.1$' | sort -u)
else ok "Gate5 volatile: no metrics/bearer/non-loopback IPs embedded"; fi
[ "$VOLATILE" -eq 0 ] && [ "$IP_HITS" -eq 0 ] && true
say ""

# ---- Gate 6: referenced script paths exist ----------------------------------
BADCMD=0
for p in $(grep -oE 'ops/scripts/[A-Za-z0-9._-]+' "$F" | sort -u); do
  [ -e "$ROOT/$p" ] || { BADCMD=$((BADCMD+1)); fail "referenced script missing: $p"; }
done
[ "$BADCMD" -eq 0 ] && ok "Gate6 scripts: every referenced ops/scripts path exists"

# ---- Gate 7: referenced canonical docs exist ---------------------------------
BADDOC=0
for p in $(grep -oE 'ops/reports/generated/[A-Za-z0-9._-]+\.md' "$F" | sort -u); do
  [ -f "$ROOT/$p" ] || { BADDOC=$((BADDOC+1)); fail "referenced doc missing: $p"; }
done
[ "$BADDOC" -eq 0 ] && ok "Gate7 docs: every referenced generated report exists"

# ---- Gate 8: length sanity ----------------------------------------------------
LINES=$(wc -l < "$F")
if [ "$LINES" -le 200 ]; then ok "Gate8 length: $LINES lines (<=200)"; else
  fail "length $LINES exceeds 200-line sanity cap"; fi

# ---- Gate 9: precedence statement present -------------------------------------
grep -qi "precedence" "$F" && ok "Gate9 precedence: statement present" || fail "no precedence statement"

say ""
say "=== CI SUMMARY ==="
say "errors=$ERR warnings=$WARN"
if [ "$ERR" -gt 0 ]; then say "RESULT: FAIL"; exit 1; fi
say "RESULT: PASS ($WARN warnings)"
exit 0
