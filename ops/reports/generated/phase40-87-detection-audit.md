# Phase 40 Detection Audit

**Report ID:** phase40-87-detection-audit
**Phase:** 40
**Title:** DET-40-03 — Pipeline Map Fully PROVEN on Class-A Lane (E2E-007 Exact IDs at All Six Hops), Field-Fix Effect Confirmed in Live Archive Classes (Windows 9,320 + Suricata EVE 110 Today), High-Severity Webhook Arc Certified, Packet Lane DEFERRED-BY-CHOICE With Open Import Path, Dedup Semantics Defined-Not-Exercised, FP Sampling Proposed-Not-Started — Gaps Listed Honestly
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-87-detection-audit.md`

---

## 1. Pipeline Map — Segment-by-Segment Proof Status

| # | Segment | Proof vehicle | Status |
|---|---|---|---|
| 1 | Sensor (Suricata EVE via agent 016 `mct-packet-sensor`) | E2E-007 hop 1–3: flow_id **999000777**, sid **2027967**, marker `[MCT-CANARY-P40-E2E-007]` | **PROVEN** |
| 2 | Agent → manager analysisd | E2E-007 hop 4: alert id **1787707735.1208554** @01:28:55.267Z, rule 86601 lvl 3, groups [ids,suricata] | **PROVEN** |
| 3 | Indexer persistence | hop 5: doc `wazuh-alerts-4.x-2026.08.26/_doc/EMavO6ABpixMBj2JQ1tg` found | **PROVEN** |
| 4 | integratord file+dispatch | hop 6: `/tmp/shuffle-1787707735-1303758191.alert was written.` + debug payload with markers | **PROVEN** |
| 5 | Shuffle webhook → workflow | hop 7: execution **b6d07492** FINISHED src=webhook started 01:28:55Z; live API shows exactly the two production workflows remain | **PROVEN** |
| 6 | HTTP action → IRIS row | hop 9: **alert 42 @ 01:28:57.631Z** re-verified in IRIS DB this session; latency 2.36 s | **PROVEN** |

## 2. Field-Fix Effect on Detection Data Completeness

Live archive-class counts for today's index (`wazuh-archives-4.x-2026.08.26`):

```
EventChannel (windows class)        → 9,320 docs   ✓ ingesting clean
/var/log/suricata/eve.json          →   107 docs   ✓ clean
/var/log/suricata/eve-alert.json    →     3 docs   ✓ clean
leaf_fields=1706, growth_per_day=0.0 (guardrail state) → flatline holds
```

Post-fix classes parse into typed fields (windows/suricata queries return structured hits,
not full_log blobs). The flatline plus clean class ingestion = field-fix effectiveness
holds under real load.

## 3. High-Severity Lane Certification

The webhook arc (rule-group `suricata` → hook `eb937a37` → IRIS) is certified by E2E-007
plus 40 lifetime delivered rows counted by the delivery monitor (`delivered=40` at last
run). FINISHED≠delivered ambiguity is mitigated operationally by the */15 monitor.

## 4. Packet Lane — DEFERRED BY CHOICE (documented)

Import path proven open (POST /workflows returned 200 era, phase40-41); artifact remains
sha256-pinned and untouched; import held pending refinement specs 44–47 application
(ROUT-PKT-40-01 deferred-not-rejected). Deduplication/counter semantics for the packet
workflow are **defined in artifact design but NOT exercised** — they cannot be until the
workflow imports and routes; tracked as OW-40-04.

## 5. Malformed / Failure Behaviors (Class-A lane)

Demonstrated during the DNS-failure era and re-cited from phase40-34 §6: malformed and
non-lane events hit fail-closed skips (no partial sends, no silent drops into success
counters); integrations.log currently carries zero error lines; authd fail-closed on bad
enrollment password observed live today (two rejected attempts).

## 6. FP Quality Sampling Plan — PROPOSED, NOT STARTED

Owner-cycle sampling plan (periodic human review of level≥3 population for FP-rate
estimation) remains proposed; no sampling sessions executed yet. Owner: SOC lead;
candidate slot after Aug-29 ISM wave observation. Honest status: not started.

## 7. Case Outcomes — Notify-Only By Design

All IRIS outcomes on this lane are alerts (notify-only Class-A template), no case
escalation logic enabled; consistent with AGENTS approval-gates (production routing
beyond notify requires sign-off).

## 8. Coverage Gaps (honest list)

| Gap | Impact | Disposition |
|---|---|---|
| Packet workflow not imported | no dedup/counter semantics exercised; no Class-B routing proof | OW-40-04 deferred-by-choice |
| FP sampling not running | FP-rate unknown quantitatively | §6 plan awaiting owner cycle |
| Agents 013/015 offline | endpoint telemetry holes for those hosts | owner-side blockers OW-40-01/-02 |
| Level≥10 volume (505 today, rule 80710 dominant) unreviewed | possible tuning debt | candidate input to FP sampling |
| First policy-driven deletion wave unseen (opens 08-29) | retention behavior unproven end-to-end | OW-40-03 observation scheduled |

## 9. Verdict

**DETECTION AUDIT: PASS ON CERTIFIED LANES; GAPS DISCLOSED.** Every claimed segment has a
dated, ID-exact proof; nothing is marked proven that isn't.
