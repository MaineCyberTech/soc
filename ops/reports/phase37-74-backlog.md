# Phase 37 — Backlog

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-74
**Classification:** Internal

---

## P0 — Critical (None)

No P0 items.

## P1 — High Priority

| # | Item | Description | Impact |
|---|------|-------------|--------|
| 1 | Field cardinality resolution | `decoder_order_size=512` insufficient. ~100 errors/min accumulating. 18,849 total "Too many fields" errors. Decoder instability risk. | Decoder may drop events. Log noise. |
| 2 | Shuffle exposure hardening | Shuffle frontend bound to 0.0.0.0:3001 — plaintext HTTP on all interfaces. No firewall. No TLS. | Unauthorized access risk. Data exposure. |

## P2 — Medium Priority

| # | Item | Description | Impact |
|---|------|-------------|--------|
| 3 | Wazuh→Shuffle webhook integration | No integration between Wazuh alerts and Shuffle workflows. Design exists but not implemented. | No automated alert routing or response. |
| 4 | Suricata stats minimization | Agent 016 generating 1,095 alerts/day. Volume contributes to field cardinality pressure. | Log volume, disk pressure, noise. |
| 5 | ISM wave observation | First ISM deletion wave scheduled 2026-08-29. Need to observe and validate. | Retention policy effectiveness. |

## P3 — Low Priority

| # | Item | Description | Impact |
|---|------|-------------|--------|
| 6 | Agent 013/015 recovery | Two agents disconnected. Agent 008 retired. | Reduced endpoint coverage. |
| 7 | /tmp first cron validation | Cron active at 03:00 UTC. First execution needs validation. | Cleanup effectiveness unconfirmed. |
| 8 | Memory pressure | Swap usage at 64% (5,205/8,191 MB). Sustained memory pressure. | Performance degradation risk. |

## Backlog Summary

| Priority | Count |
|----------|-------|
| P0 | 0 |
| P1 | 2 |
| P2 | 3 |
| P3 | 3 |
| **Total** | **8** |

## No secrets
