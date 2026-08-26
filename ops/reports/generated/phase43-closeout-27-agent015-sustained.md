# Phase 43 Closeout: Agent 015 Sustained Proof

**Report ID:** phase43-closeout-27-agent015-sustained
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Agent 015 Sustained Proof
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:30:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-27-agent015-sustained.md`

---

## 1. Sustained Proof Protocol (Post-Remediation)

| Criterion | Threshold | Measurement | Verification |
|-----------|-----------|-------------|--------------|
| Sustained keepalive | ≤ 5 min intervals for 24h | Wazuh API `/agents/015` | API poll every 5 min |
| Zero disconnects | 0 disconnect events in 24h | Wazuh alerts `agent_disconnected` | Alert check |
| Telemetry quality | Sysmon EIDs present | `data.win.system.eventID` count | OS query |
| No permission errors | 0 merged.mg errors | `grep merged.mg /var/ossec/logs/ossec.log` | Log grep |

---

## 2. Verification Commands

```bash
# Check agent status
TOKEN=$(curl -sk -u wazuh-wui:MyS3cr37P450r.*- -X POST "https://127.0.0.1:55000/security/user/authenticate?raw=true")
curl -sk -H "Authorization: Bearer $TOKEN" "https://127.0.0.1:55000/agents/015" | python3 -c "
import json,sys
a=json.load(sys.stdin)['data']['affected_items'][0]
print('Status:', a['status'], '| KA:', a.get('last_keepalive'))
"

# Check merged.mg errors (last 24h)
docker exec multi-node-wazuh.master-1 sh -c 'grep -c "merged.mg.*Permission denied" /var/ossec/logs/ossec.log'
```

---

## 3. Success Criteria

| Criterion | Pass Threshold |
|-----------|----------------|
| Sustained keepalive | ≤ 5 min intervals for 24h continuous |
| Zero disconnects | 0 disconnect events in 24h |
| Telemetry quality | Sysmon EIDs present in events |
| Zero permission errors | 0 merged.mg errors in 24h |

---

## 3. Status

**BLOCKED-AWAITING-OWNER** — Depends on Phase 43-26 remediation completion.