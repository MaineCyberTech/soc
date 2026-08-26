# Phase 40-15: Agent 013 SAMSUNG — Recovery Runbook (BLOCKED-OWNER-ACTION)

**Report ID:** phase40-15-agent013-recovery
**Phase:** 40
**Title:** Phase 40-15: Agent 013 Recovery — Status BLOCKED-OWNER-ACTION, Runbook Prepared
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:43:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-15-agent013-recovery.md`

---

## 1. Status

**BLOCKED-OWNER-ACTION.** The operation is approval-gated *and* physically gated:
agent 013 has been unreachable since 2026-08-25T06:30:48Z and no operator, RMM, or
physical access path exists from this environment (see phase40-14 §5). Server-side
recovery is impossible; the runbook below is PREPARED and will be executed same-day
once the owner restores device availability. [VERIFIED]

Live blocker evidence (API pull 2026-08-26T01:33:40Z):

```
013 SAMSUNG | status: disconnected | KA: 2026-08-25T06:20:29+00:00 | disc: 2026-08-25T06:30:48+00:00
```

## 2. Enrollment Identity Preservation [VERIFIED]

- Agent ID **013 unchanged** — confirmed live via API (`"id": "013"`, name SAMSUNG).
- Agent was **never removed**: no `DELETE /agents` call in any phase-40 operation;
  authd enrollment log for Aug-25 shows zero 013 events (no re-keying occurred):

```
$ docker exec multi-node-wazuh.master-1 zcat /var/ossec/logs/wazuh/2026/Aug/ossec-25.log.gz | grep -E "\b013\b|SAMSUNG"
(no results)
```

- Consequence: on reconnection the existing key authenticates automatically; the
  agent inherits its windows-clients group config (was `synced` at loss,
  mergedSum `0744ee…`, configSum `e8d301f…`). No re-enrollment, no duplicate ID risk.

## 3. Preconditions (server side — already true)

1. Manager reachable at 1514/TCP (remoted listening confirmed during 01:14 restart window:

```
2026/08/26 01:14:24 wazuh-remoted: INFO: Started (pid: 10338). Listening on port 1514/TCP (secure).
```

2. Enrollment port 1515 open (authd accepting connections — Aug-25 log:

```
2026/08/25 22:15:14 wazuh-authd: INFO: Accepting connections on port 1515. Using password specified on file: etc/authd.pass
```

3. windows-clients shared config readable by remoted (merged.mg `wazuh:wazuh` in group dir).

## 4. Minimum Safe Recovery Runbook (execute on owner signal)

| Step | Action | Verify |
|------|--------|--------|
| 1 | Owner powers device on / wakes it | — |
| 2 | Device joins known network (home Wi-Fi/Ethernet; same subnet preferred) | DHCP lease for prior MAC/IP appears |
| 3 | Confirm `WazuhSvc` start (auto-start expected; if stopped: `sc.exe start WazuhSvc` or Services.msc → Start) | service Running |
| 4 | Wait ≤10 min for keepalive | API: GET /agents → 013 `active`, `lastKeepAlive` fresh (<600s) |
| 5 | Proceed immediately to phase40-16 postcheck checklist | all items pass same-day |

Safety notes: no credentials requested from owner beyond physical access; if the
service fails to start, escalate rather than reinstalling over the preserved identity.

## 5. Rollback Plan

**N/A.** No server-side change is required or planned for recovery; there is nothing
to roll back. Enrollment identity is untouched, so a failed recovery leaves fleet
state exactly as-is (013 disconnected).

## 6. Approval & Ownership

| Item | Value |
|------|-------|
| Requested from | Endpoint ops owner / device owner (MCT SOC principal) |
| Requested date | Same-day on receipt of this report (device already >19h dark) |
| Approver records | Change register entry to be added when owner action lands |
| Execution window | Any time; runbook steps take <10 min after power-on |
