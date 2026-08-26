# Phase 40-20: Agent 015 Group Config Delivery Verification (post PERM-40-01)

**Report ID:** phase40-20-agent015-config-delivery
**Phase:** 40
**Title:** Phase 40-20: Config Delivery Verification — Manager-Side Intact, Agent-Side Pending Wake
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:48:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-20-agent015-config-delivery.md`

---

## 1. Verdict Summary

| Layer | State |
|-------|-------|
| Manager: defect reporting ceased | **VERIFIED** — zero merged.mg EACCES after 00:49:55Z across all restarts |
| Manager: merged.mg readable/writable by remoted | **VERIFIED** — regenerated 00:50:05, `wazuh:wazuh 644 1043` |
| Other groups unaffected | **VERIFIED** — default/linux-servers merged.mg mtimes+ownership unchanged |
| Other agents regressed? | **NO** — fleet statuses stable through the restart window |
| Agent 015 side confirmation | **PENDING** — device asleep/disconnected; its next merged.mg download happens on connect |

## 2. Manager Defect Ceased (grep windows)

```
$ docker exec multi-node-wazuh.master-1 grep "mac-clients/merged.mg" /var/ossec/logs/ossec.log | awk '$2 > "00:50:00"' | wc -l
0
$ docker logs multi-node-wazuh.master-1 --since 45m 2>&1 | grep -c "mac-clients/merged.mg"
0
```

Restart durability: remoted restarted 5× post-fix during webhook wiring
(Started lines at 01:00:13, 01:01:14, 01:01:52, 01:03:43, 01:14:24); zero recurrences.

## 3. merged.mg Readable/Writable Post-Fix (live ls/stat)

```
-rw-r--r-- 1 wazuh wazuh 1043 Aug 26 00:50 /var/ossec/etc/shared/mac-clients/merged.mg
stat: /var/ossec/etc/shared/mac-clients/merged.mg  wazuh:wazuh 644 1043  mtime 2026-08-26 00:50:05 +0000
```

Owner `wazuh` = remoted runtime user → read/write both satisfied; content head shows
valid bundle (`#mac-clients`, ar.conf block).

## 4. Sibling Groups Unaffected (spot check)

```
-rw-r--r-- 1 wazuh wazuh 899441 Aug  7 20:55 /var/ossec/etc/shared/default/merged.mg
-rw-r--r-- 1 wazuh wazuh   1360 Aug  8 21:45 /var/ossec/etc/shared/linux-servers/merged.mg
```

Ownership `wazuh:wazuh`, mtimes pre-date the incident window entirely — default and
linux-servers delivery paths untouched by both the defect and the fix.

## 5. No Other Agents Regressed

Fleet pull at 2026-08-26T01:33:40Z (after all restart cycles): 000, 006, 007, 011,
012, 014, 016 all `active` with keepalives within the minute (e.g., 006/007/011/012
KA 2026-08-26T01:33:36Z). Only expected disconnects remain: 013 (owner-gated), 015
(macOS sleep), 008 (retired). Cluster integrity sync healthy:

```
2026/08/26 01:36:50 INFO: [Worker worker01] [Integrity check] Finished in 0.003s. Received metadata of 65 files. Sync not required.
```

The worker/master daemon restarts at ~01:14–01:28 (webhook wiring) caused brief,
self-healing reconnects fleet-wide; this is operational churn documented separately
from the 015 flap issue and produced no lasting regression.

## 6. Known Non-Blocking Sibling Finding (new, cosmetic)

windows-clients carries a root-owned `.bak` that remoted skips with a non-fatal pair
of lines (14 occurrences today, e.g.):

```
2026/08/26 01:26:23 wazuh-remoted: ERROR: Invalid shared file 'etc/shared/windows-clients/agent.conf.bak-20260816'. Ignoring it.
2026/08/26 01:28:21 wazuh-remoted: ERROR: Unable to open file 'etc/shared/windows-clients/agent.conf.bak-20260816' due to [(13)-(Permission denied)].
```

Delivery is unaffected ("Ignoring it"), but the same hygiene pattern as PERM-40-01 —
recommend backlog item: move `agent.conf.bak-20260816` out of the shared dir or align
ownership.

## 7. Agent-Side Confirmation — PENDING

Agent 015 downloads its group's `merged.mg` **on connect**. Until the device wakes,
agent-side receipt cannot be proven. Current API state (01:33Z):

```
015 Julians-Air | status: disconnected | KA: 2026-08-26T01:16:18+00:00 | disc: 2026-08-26T01:26:23+00:00
```

On next wake: verify via `GET /agents?agents_list=015` → `group_config_status: synced`
and fresh mergedSum matching manager's mac-clients bundle hash; then close this report's
pending item via addendum.
