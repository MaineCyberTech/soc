# Phase 19 Packet Routing Promotion Decision

Date: 2026-08-18
Decision: **NO-ROUTE** (routing remains disabled). Manual-only for Class A candidates.

## 1. Zeek noise recheck (input)

- 122001/122002/122003 (SSH/SMB/RDP): 0 alerts/24h - clean Class A candidates.
- 122004 (admin ports): 0 - clean Class B.
- 122000/122005/122006: **417K alerts/24h combined** (mDNS + UDP broadcast) - noise NOT proven acceptable.
- v2 tuning prepared + validated (syntax + guard logic), **pending approval to deploy** + 24h re-measure.

## 2. Suricata readiness (input)

- eve.json ingest broken -> **FIXED this phase** (symlink + updater + cron), validation window open.
- Severity map + routing plan drafted but gated until events validate (Phase 19.07/19.08).
- Not ready for routing.

## 3. Class A candidates

| Candidate | Type | Status | Gate to route |
|---|---|---|---|
| Zeek 122001 (SSH) | packet | clean 24h | post-v2 re-measure + approval |
| Zeek 122002 (SMB) | packet | clean 24h | post-v2 re-measure + approval |
| Zeek 122003 (RDP) | packet | clean 24h | post-v2 re-measure + approval |
| Suricata sev 1-2 | packet | no ingest data yet | events validated + volume measured |

## 4. Decision

- **NO-ROUTE**: keep IRIS routing disabled for all packet/flow detections.
- Manual-only: during the interim, operators may open IRIS cases manually for Class A events
  observed in the dashboard (none occurred in the window anyway).
- Promotion plan + case template prepared and versioned for the moment gates clear.

## 5. What unlocks promotion

1. Zeek v2 deployed + 24h re-measure clean (122000/122005/122006 < 2K total).
2. Class A stays clean over that window.
3. Operator approval (change control).
4. Suricata: separate gate (ingest + volume) before sev 1-2 routing.

## No secrets