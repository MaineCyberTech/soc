# Phase 43: Agent 013 Sustained Proof

**Report ID:** phase43-24-agent013-sustained.md
**Phase:** 43
**Title:** Phase 43 Agent 013 Sustained Proof Protocol
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T14:30:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-24-agent013-sustained.md`

---

## 1. Purpose

Define the sustained connectivity proof required after Agent 013 recovery.

---

## 1. Sustained Proof Protocol

| Criterion | Threshold | Measurement | Verification |
|-----------|-----------|-------------|--------------|
| Keepalive frequency | ≤ 5 min | Wazuh API `/agents/013` `last_keepalive` | API poll every 5 min |
| Continuous uptime | ≥ 30 min continuous | `last_keepalive` monotonic | API poll |
| Event flow | ≥ 1 event/hr | OpenSearch query `agent.id:013` | OS query |
| No disconnection | 0 disconnect events | Wazuh alerts `agent_disconnected` | Alert check |
| Telemetry quality | Sysmon EIDs present | `data.win.system.eventID` exists | OS query |

---

## 2. Verification Commands

```bash
# Check agent status
TOKEN=$(curl -sk -u wazuh-wui:[REDACTED-PW] -X POST "https://127.0.0.1:55000/security/user/authenticate?raw=true")
curl -sk -H "Authorization: Bearer $TOKEN" "https://127.0.0.1:55000/agents/013" | python3 -c "
import json,sys
d=json.load(sys.stdin)
a=d['data']['affected_items'][0]
print(f\"Status: {a['status']}, KA: {a.get('last_keepalive')}\")"

# Check event flow (last hour)
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-alerts-*/_count?q=agent.id:013"
```

---

## 3. Success Criteria

| Criterion | Pass Threshold |
|-----------|----------------|
| Sustained keepalive | ≥ 30 min continuous (≤5 min intervals) |
| Event flow | ≥ 1 event/hour |
| No disconnects | 0 disconnect events in 2h window |
| Telemetry quality | Sysmon EIDs present |

---

## 4. Status

**BLOCKED-AWAITING-OWNER** — Depends on Phase 43-23 recovery first.