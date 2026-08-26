# Phase 43: Repair Gate Design

**Report ID:** phase43-44-repair-gate-design.md
**Phase:** 43
**Title:** Phase 43 Repair Gate Design — FRONTEND_REPAIRED Gate
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T16:15:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-44-repair-gate-design.md`

---

## 1. Purpose

Document the FRONTEND_REPAIRED gate design that eliminated unconditional frontend restarts.

---

## 1. Problem (Pre-Fix)

```bash
# Original code (unconditional)
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ]; then
  docker restart shuffle-frontend
fi
```

**Problem**: `docker restart shuffle-frontend` executed on **every** `--apply` run (every 15 min), regardless of whether frontend needed restart.

---

## 2. Solution (FRONTEND_REPAIRED Gate)

```bash
# Fixed code (gated)
FRONTEND_REPAIRED=0
for c in "${need[@]:-}"; do
  [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
done
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ] && [ $FRONTEND_REPAIRED -eq 1 ]; then
  echo "Restarting shuffle-frontend (was reconnected this run) to clear cached backend IP"
  docker restart shuffle-frontend >/dev/null && echo "  restarted" || echo "  restart failed"
else
  echo "NO-OP: frontend network intact; no restart needed"
fi
```

---

## 2. Gate Logic

| Condition | Action |
|-----------|--------|
| Frontend in `need` list (was reconnected) | `FRONTEND_REPAIRED=1` → restart |
| Frontend NOT in `need` list | `FRONTEND_REPAIRED=0` → NO-OP |
| `--apply` not set | Dry-run only |

---

## 3. Why This Works

| Scenario | Before Fix | After Fix |
|----------|------------|-----------|
| Healthy (no drift) | Restart every 15 min | NO-OP |
| Backend drift only | Restart every 15 min | Backend reconnect; NO-OP frontend |
| Frontend drift | Restart every 15 min | Restart (once) then NO-OP |
| Backend + Frontend drift | Restart every 15 min | Both reconnect; 1 frontend restart |

---

## 4. Rollback

```bash
# Revert to unconditional restart (if gate causes issues)
sed -i 's/FRONTEND_REPAIRED=0/OLD_LOGIC/' ops/scripts/shuffle-repair-network.sh
# OR restore backup
cp ops/backups/shuffle-repair-network.sh.pre-p42-churnfix ops/scripts/shuffle-repair-network.sh
```

---

## 5. Status

**COMPLETE** — Design documented; implemented; tested; certified (CHURN-CERT-42-01 PASS).