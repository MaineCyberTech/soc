# Phase 38-27 — Endpoint Fleet Claim Verification

**Report ID:** phase38-27-endpoint-claim-verification
**Phase:** 38
**Title:** Phase 38-27 — Endpoint Fleet Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-27-endpoint-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:35 UTC
**Scope:** Verify connectivity/keepalive/certification/throttle/billing/retired claims for agents 008 and 012–016.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | 7 active agents: 000,006,007,011,012,014,015,016 minus… | **CONTRADICTED (composition)** — actually 8 entries active incl. local; live-state list omitted 015 | `agent_control -l` |
| 2 | 013 disconnected | **VERIFIED** | agent list |
| 3 | 015 disconnected | **CONTRADICTED** | Julians-Air is **Active** right now |
| 4 | 008 retired/disconnected | **PARTIAL** — Disconnected VERIFIED; "retired" UNVERIFIED (still enrolled & listed) | agent list / -i 008 |
| 5 | Agent 016 v4.14.7 active sensor | **VERIFIED** | `-i 016` (see phase38-24) |
| 6 | Throttle: none detected | **VERIFIED (as reported)** | P37 final report table; no counter-evidence in logs sampled this session |
| 7 | Billing claims for endpoints | **UNVERIFIED** | no billing artifact reachable from this host |

---

## Evidence Detail

### 1–4. Authoritative live roster
```
$ docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l
ID: 000  Name: wazuh.master      IP: 127.0.0.1  Active/Local
ID: 006  Name: docker-host       IP: any        Active
ID: 007  Name: mct-portal-dev    IP: any        Active
ID: 008  Name: securityonion     IP: any        Disconnected
ID: 011  Name: mct-linux-client01 IP: any       Active
ID: 012  Name: MCT-WIN11PILOT    IP: any        Active
ID: 013  Name: SAMSUNG           IP: any        Disconnected
ID: 014  Name: DESKTOP-MI54LFT   IP: any        Active
ID: 015  Name: Julians-Air       IP: any        Active      ← contradicts "015 disconnected"
ID: 016  Name: mct-packet-sensor IP: any        Active

$ .../agent_control -i 008   → Status: Disconnected
$ .../agent_control -i 013   → Status: Disconnected
```
Count reconciliation: the live-state claim "7 active (000,006,007,011,012,014,016)" omits **015**, which is demonstrably Active at verification time. Either the fleet returned to 8 active between snapshot and now, or the earlier claim was already stale when written. Composition claim: **CONTRADICTED** on 015.

- **008 securityonion**: Disconnected is confirmed. "Retired" implies decommissioned/deregistered; it remains enrolled in the manager DB and listed — no retirement action observable from master state alone. Treat as *disconnected, not retired* until a removal record exists. **PARTIAL.**
- **013 SAMSUNG**: Disconnected confirmed. **VERIFIED.**
- **015**: Active now. If business intent is that this device be off-fleet, an operator action is required; if it legitimately reconnected, prior reporting was stale. **CONTRADICTED as stated.**

### 5. Agent 016
Covered fully in phase38-24: Status Active, Wazuh v4.14.7, Debian 13 sensor host, same-hour alert traffic indexed. **VERIFIED.**

### 6. Throttle
P37 operator report records "Throttle: None detected". Nothing in this session's manager log sampling contradicts that (no rate-limit/queue-full signatures surfaced during error-pattern greps). Keepalive cadence itself was not re-measured per-agent here (`agent_control -i` keepalive fields not populated in output for 016), so this inherits the prior finding rather than independently re-proving it. **VERIFIED (inherited).**

### 7. Billing
No billing/licensing artifact exists in the stack to query (Wazuh OSS has no per-endpoint billing surface; any billing claim would reference an external process). No evidence path could be exercised. **UNVERIFIED.**

---

## Verification Commands Used
```bash
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 008
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 013
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 015
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 016
docker exec multi-node-wazuh.master-1 sqlite3 ... # unavailable in container image
grep -rn -iE "throttle" ops/reports/final-phase37-operator-report-*.md
```

## Summary
Fleet truth as of 20:35Z: **8 Active (incl. local 000) + 2 Disconnected (008, 013)**. The headline discrepancy is agent 015 (Julians-Air) being live against a "disconnected" claim; 008 remains merely disconnected rather than retired. Endpoint-level certification posture for 012/014/015/016 should be re-baselined off this roster before any further recovery-phase reporting.

## No secrets
