# Phase 42 Repair Script Fix — Apply Record FIX-CHURN-42-01

**Report ID:** phase42-45-repair-script-fix
**Phase:** 42
**Title:** FIX-CHURN-42-01 — Apply Record: FRONTEND_REPAIRED Gate Installed Into ops/scripts/shuffle-repair-network.sh At 2026-08-26T07:50:27Z; Pre-Change Backup Hashed And Filed; bash -n Syntax-Clean; Diff Confined To The Restart Block — Zero Behavioral Change Elsewhere
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:07:00Z
**Classification:** INTERNAL
**Status:** APPLIED (fix live; proofs in phase42-46/-47)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-45-repair-script-fix.md`

---

## 1. Apply record

| Field | Value |
|---|---|
| Change ID | **FIX-CHURN-42-01** |
| Applied at | **2026-08-26T07:50:27Z** (file mtime, matches backup instant) |
| Target | `/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh` |
| Backup | `/opt/mct-security-stack/ops/backups/shuffle-repair-network.sh.pre-p42-churnfix` (created same instant, pre-modification) |
| Syntax check | `bash -n` → clean (re-verified live today) |
| New-script sha256 (prefix) | `a061bf51473729ad…` |
| Cron | unchanged — `*/15 * * * *` apply continues; gating lives in the script, not the schedule |

## 2. Diff summary (complete; nothing else touched)

Old block (backup lines 59–60):

```bash
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ]; then
  echo "Restarting shuffle-frontend to clear cached backend IP"
  docker restart shuffle-frontend
fi
```

New block:

```bash
# P42 churn fix: restart ONLY when frontend was actually reconnected this run
FRONTEND_REPAIRED=0
for c in "${need[@]:-}"; do
  [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
done
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ] && [ $FRONTEND_REPAIRED -eq 1 ]; then
  echo "Restarting shuffle-frontend (was reconnected this run) to clear cached backend IP"
  docker restart shuffle-frontend
else
  echo "NO-OP: frontend network intact; no restart needed"
fi
```

Net changes: (1) flag computed from this run's actual reconnect list;
(2) restart condition ANDs the flag; (3) message text distinguishes gated
restarts; (4) NO-OP line emitted every clean run — which doubles as the
monitoring signal (phase42-48 §5). All other script logic byte-identical.

## 3. Verification chain

1. `bash -n` clean → syntax gate.
2. First post-fix run exercised BOTH branches naturally: run-1 found 2 drifted
   healthcheck containers, reconnected them (repair path proven), and emitted
   NO-OP for frontend (gate path proven) — phase42-46.
3. Forced-failure cycle proved the need-list restart branch under drift of a
   non-frontend container leaves frontend untouched — phase42-47.
4. Historical churn quantified against pre-fix log era — phase42-43.

## 4. Rollback procedure (single step)

```bash
cp /opt/mct-security-stack/ops/backups/shuffle-repair-network.sh.pre-p42-churnfix \
   /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh
```

Restores exact old behavior (unconditional restart); next cron cycle adopts it.
No service or state dependencies exist on the new file.
