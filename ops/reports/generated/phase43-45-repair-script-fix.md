# Phase 43: Repair Script Fix

**Report ID:** phase43-45-repair-script-fix.md
**Phase:** 43
**Title:** Phase 43 Repair Script Fix — Applied Diff
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T16:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-45-repair-script-fix.md`

---

## 1. Diff Summary

```diff
--- a/ops/scripts/shuffle-repair-network.sh
+++ b/ops/scripts/shuffle-repair-network.sh
@@ -35,7 +35,13 @@ mapfile -t running < <(docker ps --format '{{.Names}}' | grep -Ei 'shuffle|worker|fro
 need=()
 for c in $(printf '%s\n' "${containers[@]}" "${running[@]}" | sort -u); do
   if ! docker inspect "$c" --format '{{json .NetworkSettings.Networks}}' 2>/dev/null | grep -q "\"$NETWORK\""; then
     need+=("$c")
   fi
 done
 
+FRONTEND_REPAIRED=0
+for c in "${need[@]:-}"; do
+  [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
+done
+
 if [ ${#need[@]} -eq 0 ]; then
   echo "PASS: all Shuffle-like containers are on $NETWORK"
 else
@@ -48,11 +44,16 @@ if [ ${#need[@]} -eq 0 ]; then
     done
   else
     echo "MISSING: ${#need[@]} containers not on $NETWORK:"
     printf '  - %s\n' "${need[@]}"
     if [ $APPLY -eq 1 ]; then
       for c in "${need[@]}"; do
         echo "CONNECT: $c -> $NETWORK"
         docker network connect "$NETWORK" "$c" && echo "  OK" || echo "  FAILED (may need manual attach)"
       done
+      for c in "${need[@]:-}"; do
+        [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
+      done
     fi
 fi
 
-  if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ]; then
-    echo "Restarting shuffle-frontend to clear cached backend IP"
-    docker restart shuffle-frontend >/dev/null && echo "  restarted" || echo "  restart failed"
+  if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ] && [ $FRONTEND_REPAIRED -eq 1 ]; then
+    echo "Restarting shuffle-frontend (was reconnected this run) to clear cached backend IP"
+    docker restart shuffle-frontend >/dev/null && echo "  restarted" || echo "  restart failed"
 else
   echo "NO-OP: frontend network intact; no restart needed"
 fi
```

---

## 2. Files Modified

| File | Change |
|------|--------|
| `ops/scripts/shuffle-repair-network.sh` | FRONTEND_REPAIRED gate added |
| `ops/backups/shuffle-repair-network.sh.pre-p42-churnfix` | Backup created pre-fix |

---

## 3. Verification

| Check | Result |
|-------|--------|
| `bash -n ops/scripts/shuffle-repair-network.sh` | PASS |
| Dry-run (no --apply) | PASS |
| Apply with drift | PASS (2 containers reconnected) |
| Apply without drift | NO-OP (PASS) |
| Forced failure test | PASS (backend reconnected, frontend NOT restarted) |

---

## 4. Status

**COMPLETE** — Fix applied, tested, verified. Historical churn eliminated.