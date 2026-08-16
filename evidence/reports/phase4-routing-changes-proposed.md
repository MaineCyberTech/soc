# Phase 4 Routing Changes - Proposed

Proposed routing/suppression changes. Separated from applied changes
(see phase4-routing-changes-applied.md). Nothing here is live unless listed there.

## 1. osquery inventory (rule 24010) -> Class D / archive

**Proposal:** override rule 24010 to level 0 (archive only).
Children 24011-24014 (memory/disk pressure) and 24020+ (monitoring packs) keep
their levels - they chain off 24010 with their own conditions.

- Expected reduction: ~263k/24h (50.6%).
- Risk: minimal - inventory results are expected telemetry; archives still store them.
- **STATUS: APPLIED 2026-08-11** (see applied doc).

## 2. UniFi client churn / roaming / benign drops -> Class C digest

**Proposal (not applied):** route to daily digest via OpenSearch alerting monitor
or Shuffle workflow branch, keeping alert generation (level unchanged).

| rule | description | proposed route |
|---|---|---|
| 120520 | 802.11r roaming handoff | C digest |
| 120531/120532 | client kicked | C digest |
| 120509/120510 | client connected/disconnected | C digest |
| 120506/120512/120517 | station events/tracker | C digest |
| 120518 | LAN dropped | C digest |
| 120501 | WAN blocked/drop | C digest (flood rule stays B) |

Class B/C remain alerting; only route changes at monitor/workflow level.
**Status: PROPOSED - requires monitor/workflow changes (not yet applied).**

## 3. mct-portal benign app noise -> Class C/D

**Proposal (not applied):**

| rule | description | proposed route |
|---|---|---|
| 120535 | Sentry SDK initialized | D archive (benign init) |
| 120559 | Caddy ACME challenge | D archive (expected) |
| 120537 | warn/error (level 5) | C digest - keep alerting, dedupe by msg |

Security-relevant app errors (privilege-drop 120556, upstream failure 120558)
stayed at current levels - NOT suppressed.
**Status: PROPOSED - requires rule override or monitor changes.**

## 4. Unchanged (Class A protection)

- OpenCanary 121000-121099 - untouched.
- MISP IOC 121100+ - untouched.
- Flow unknown exporter / lateral movement monitors - untouched.
- auditd 80710 - kept (level 10, Class B) - no change.
