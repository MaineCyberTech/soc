# Phase 41 Agent 015 — Final State (Split Certification)

**Report ID:** phase41-26-agent015-final-state
**Phase:** 41
**Title:** FINAL-STATE-015-41 — Permission Closure INTACT Re-Verified Today By Grep (Zero merged.mg Errors After 00:50:05Z Fix, Durable Across Restarts); Connectivity Flap OPEN-OWNER (Fresh Cycle 04:38:34Z Today); Certification PARTIAL-Split With Adjacent .bak Log-Noise Disclosed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:52:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (split certification)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-26-agent015-final-state.md`

---

## 1. Split certification matrix

| Dimension | Verdict | Evidence |
|-----------|---------|----------|
| Config-delivery integrity (merged.mg defect) | **RESOLVED — VERIFIED, INTACT** [VERIFIED today] | §2 grep below |
| Connectivity | **OPEN — OWNER-GATED** | Fresh sleep-cycle drop today KA 04:20:01Z → disc 04:38:34Z (phase41-23 §2) |
| Telemetry quality | N/A-offline-at-check | Device asleep at pull instant; graded only during future active windows |
| Historical identity | PRESERVED [VERIFIED] | Registered 2026-08-16T07:44:31Z; id 015 unchanged; authd shows zero re-key events since day one |

## 2. Permission closure re-verification (run live today)

Grep executed against manager `ossec.log`, lines dated 2026/08/26:

```
$ grep "^2026/08/26" ossec.log | grep -iE "merged.mg"
2026/08/26 00:49:35 wazuh-remoted: ERROR: Unable to open file:
    'etc/shared/mac-clients/merged.mg' due to [(13)-(Permission denied)].
2026/08/26 00:49:45 wazuh-remoted: ERROR: ... (same)
2026/08/26 00:49:55 wazuh-remoted: ERROR: ... (same)
```

Last mac-clients `merged.mg` EACCES = **00:49:55Z**; the fix regenerated the
bundle at 00:50:05 (`wazuh:wazuh 644 1043`) and **zero merged.mg permission
errors have occurred since** — through the 01:14 remoted restart and both of
today's agent wake cycles. The PERM-40-01 closure is durable, not a lucky hour.

## 3. Honest adjacent finding (disclosed, non-blocking, distinct)

Today's log also shows repeated ERROR lines for a *different* file:

```
wazuh-remoted: ERROR: Unable to open file
  'etc/shared/windows-clients/agent.conf.bak-20260816' due to [(13)-(Permission denied)].
(last occurrence 2026-08-26 01:28:21Z)
```

This is a stale backup file in the windows-clients group dir with wrong
ownership — log-noise class, not a config-delivery breaker (windows group
bundle builds; 013's absence is power, not permissions). It does **not**
reopen the merged.mg closure. Queued as a hygiene item: chown
`wazuh:wazuh` or remove the `.bak-20260816` leftover under normal change
control; not urgent, never urgent enough to improvise outside gates.

## 4. What full certification still requires

Exactly one thing: the connectivity dimension. Path is fully staged —
phase41-24 package → apply → phase41-25 24h clean window PASS → successor to
this report flips connectivity RESOLVED and issues the unified certification.
Billing suspension (sleep-gap hours non-billable) continues until then,
per phase40-24 §2 rules.

## 5. Arc cross-references

Defect baseline phase40-18 · fix phase40-19 · delivery check phase40-20 ·
flap baseline phase40-21 + refresh phase41-23 · remediation options phase40-22,
package phase41-24 · proof protocol phase41-25 · companion arc (013):
phase41-20/-21/-22.
