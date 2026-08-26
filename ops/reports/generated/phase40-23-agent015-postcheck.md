# Phase 40-23: Agent 015 Postcheck — PENDING-PARTIAL

**Report ID:** phase40-23-agent015-postcheck
**Phase:** 40
**Title:** Phase 40-23: Agent 015 Postcheck — Permission Defect CLOSED; Sustained-Keepalive Pending Wake
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:51:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-23-agent015-postcheck.md`

---

## 1. Split Verdict

| Track | State |
|-------|-------|
| Permission-defect postcheck | **COMPLETE — VERIFIED durable** |
| Sustained-keepalive postcheck | **PENDING device wake** |

## 2. Permission-Defect Postcheck — COMPLETE [VERIFIED]

Zero recurrences of the merged.mg EACCES error across **all subsequent manager daemon
restarts**, including the 01:14 and 01:28 webhook-wiring restart cycles — a strong
durability signal because remoted re-reads shared-config state at every start:

```
$ docker exec multi-node-wazuh.master-1 grep "mac-clients/merged.mg" /var/ossec/logs/ossec.log | awk '$2 > "00:50:00"' | wc -l
0
$ docker logs multi-node-wazuh.master-1 --since 45m 2>&1 | grep -c "mac-clients/merged.mg"
0
```

Restart cycles survived (remoted Started lines): 01:00:13, 01:01:14, 01:01:52,
01:03:43, 01:14:24 (+ continued clean through the 01:26–01:28 window). Last error ever:
00:49:55Z. File state stable: `merged.mg wazuh:wazuh 644 1043 mtime 00:50:05`.

## 3. Sustained-Keepalive Checklist (PENDING — execute on next wake)

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Reconnect receipt | 015 → `active`, fresh KA within 10 min of wake |
| 2 | Config sync | `group_config_status: synced`; mergedSum matches manager mac-clients bundle |
| 3 | No permission recurrence | merged.mg EACCES count stays 0 through and after the connect |
| 4 | Sustained stability | ≥6h gap-free keepalive stretch under chosen Option-1 mitigation (phase40-22), then 24h stability window |
| 5 | No duplicate enrollment | roster still exactly one Julians-Air, id 015 |

## 4. Current Blocker Snapshot (API 2026-08-26T01:33:40Z)

```
015 Julians-Air | status: disconnected | KA: 2026-08-26T01:16:18+00:00 | disc: 2026-08-26T01:26:23+00:00
```

Device is in its normal sleep cycle; checks resume automatically on wake. Items 1–3
will be executed same-day on the next connect event; item 4 requires the owner-side
mitigation decision from phase40-22 to be meaningful.
