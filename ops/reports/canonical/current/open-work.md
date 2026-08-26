# Open Work Register OPENWORK-41-01

**Report ID:** phase41-81-open-work-refresh
**Phase:** 41
**Title:** Open-Work Refresh OPENWORK-41-01 — Post-Phase-41 Consolidated Register (Ten Closures Moved to Resolved Log; Live Items With Owners)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase41-81-canonical-current-refresh.md`
**Canonical Copy:** `canonical/current/open-work.md` (rewritten this phase; supersedes OPENWORK-40-01 content for tracking)

---

## 1. Register Rules

This file is THE open-work register going forward. It supersedes, for tracking purposes,
OPENWORK-40-01 (phase40-75) and through it OPENWORK-39-02 and the phase38 registers.
Prior IDs remain sticky for backlinks. Closed items move to §3 Resolved Log with closure
evidence; they are not deleted. One row per unique work item.

## 2. Open Work Master Table

| ID | Pri | Title | Status-today | Owner | Deps | Evidence ref | Rollback note |
|---|---|---|---|---|---|---|---|
| OW-40-01 (=BCK-38-011) | P2 | Recover agent 013 SAMSUNG | STILL-OPEN — owner device-side action required | Endpoint ops | user-held hardware | phase40-14…17; phase41-22 final cert | N/A client-side; fallback formal retirement w/ approval |
| OW-40-02 (=BCK-38-012) | P2 | Agent 015 flap remediation | STILL-OPEN — manager merged.mg defect fixed long ago; owner device-side remains | Endpoint ops + Wazuh config owner | owner cooperation on device | phase40-18…24; phase41-26 final state | chmod/chown one-liner documented phase39-76 |
| OW-40-03 (=BCK-38-010) | P2 | Observe ISM first deletion wave | STILL-OPEN — window opens 2026-08-29T21:00Z; policy verified attached, hot, evaluating transitions (live this phase) | Infrastructure owner | calendar | phase40-54…58; live _ism/explain [phase41-81] | N/A observation-only |
| OW-40-04 (=BCK-38-007) | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE — plus platform execute_python param-injection defect precisely documented (data_in/input/execution_input/execution_data/data all UNDEF); remediation = UI rebuild on native reference-consuming nodes (filter_list/if_else_routing/set_datastore_value) or Shuffle upgrade | SOAR ops + Detection | R-PKT-PLATFORM remediation choice | phase40-41/-53; phase41-52 probe; workflows API live: exactly 3 | Lane test-only/disabled; artifact sha-pinned |
| OW-40-05 (=BCK-38-015) | P1 | RTO/RPO sign-off | AWAITING-OWNER — worksheet ready (phase40-72), signature pending | Platform + SOC lead | owner decision | phase40-70…72 | Documents only |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO — no adequate target approved yet (spot-check #3 PASS 170521=170521 parity does not substitute) | Infra + SOC lead | OW-40-05 outcome; target env | phase40-70 §156; phase41-57 | Rehearsal env disposable |
| OW-40-11 | P2 | Commit/push Phase-41 changeset | STILL-OPEN — operator sign-off gate (G41-13); tree dirty incl. AGENTS.md CHG-41-AGENTS-01 + canonical refresh | ops-reports-owner | operator review | git status live; phase41-02 register | Git-native revert paths per changeset |
| OW-40-12 | P3 | Physical duplicate-path retirement in catalogs | STILL-OPEN — alias rows APPLIED non-destructively; path retirement approval-gated | Governance | operator sign-off | phase40-79/-80; source-map-aliases.json (parse OK live) | Delete JSON rows; files never moved |
| OW-41-01 | P4 | Duplicate X-Content-Type-Options header cleanup at :3443 | NEW — nosniff emitted 2× live (XFO half of old OW-40-08 closed single-header) | SOAR ops | proxy config edit window | curl -D count=2 live [phase41-87] | nginx conf backup before edit |
| OW-41-02 | P3 | Dashboard EID-mapping question (event.code vs rule.groups sysmon_eid1) + agent-count widget 6-vs-7 discrepancy | OWNER QUERY RAISED — both counts zero in today's live indices; question persists inside FP-baseline dataset (576-alert sample) | Detection + dashboard owner | owner ruling on mapping | phase41-62/-71/-74; live counts [phase41-81] | Query/doc change only |
| OW-41-03 | P3 | Dashboard visual-render verification | LOGIN-GATED — data layer validated; pixels unverified until operator-driven browser session | ops-reports-owner + operator | browser credentials | phase41-63/-64 | N/A verification-only |
| OW-41-04 | P2 | v1.3.1 cut | SCHEDULED Phase-42-open — candidate deltas tabled (REL-40-05); custody chain proven reusable | Release owner | Phase-42 open | phase41-77…79 | Additive tag path |
| OW-41-05 | P2 | Frontend restart churn gating | NEW — shuffle-repair-network.sh --apply restarts frontend every */15 tick (~96/day); gate on DNS-failure detection | SOAR ops | none (script edit + cron unchanged) | script lines 59–61; docker events 06:30Z restart observed [phase41-92] | Revert one hunk |

## 3. Resolved Log (closed through Phase 41; retained for backlink integrity)

| Prior ID | Item | Closure | Evidence |
|---|---|---|---|
| BCK-38-003 / R-FG lineage | Field-growth guardrail WARN | CLOSED-AT-SOURCE → **CONTAINED-PENDING-FULL-CYCLE**: eve.json stats removed at source on sensor; compact emitter+timer+localfile live; stats_compact indexed/searchable (129 docs today, live growth observed); certification flips on 08.27 index guardrail (G41-14 ARMED) | phase41-15/-18; live _count ×2 [phase41-81] |
| NEW-41 (defect) | Dual-suricata-process defect on sensor | FOUND+FIXED — suricata.service MASKED; production runs via exact-args setsid invocation; stale unit "failed" state documented as pre-mask record, not live fault | phase41-15 G41-02/03; systemctl/pgrep live [phase41-86] |
| OW-39-03 successor | Delivery-monitor soak certification | CLOSED PASS — overnight 14 cycles incl. one REAL fail-closed ERROR caught at 04:15Z slot proving failure detection works | phase41-35/-40 |
| NEW-41 | Delivery-monitor watchdog | IMPLEMENTED — self-masking bug found+fixed pre-install; dedicated alert log p41-monitor-watchdog.log; cron 3,18,33,48 live | phase41-39/-43; crontab+file live [phase41-81] |
| OW-40-07 (=OW-39-02) | Published-original v1.3.0 retrieval/custody | **CLOSED byte-exact** — GitHub REST download onto ops/releases/v1.3.0/; sha256 da72bde45db379c5… re-verified against MANIFEST PRIMARY this session (CUSTODY-41-01 CLOSED) | phase41-75/-76; sha256sum live [phase41-81] |
| OW-40-08 (XFO half) | Duplicate X-Frame-Options at TLS proxy | CLOSED for XFO — exactly ONE `X-Frame-Options: DENY` at :3443 live; sibling XCTO dup split out as OW-41-01 | phase41-65/-66; curl -D count=1 live |
| OW-40-09 | windows-clients .bak hygiene | CLOSED CLEAN — windows/mac .bak sweep verified clean; no root-owned strays in shared dirs | phase41-67/-68 |
| NEW-41 | False-positive baseline | ESTABLISHED — zero natural FP; minimal honest population 12 alerts; tuning proposals documented awaiting owner | phase41-69…74 |
| NEW-41 | Restore spot-check #3 | PASS — 170521=170521 parity | phase41-57 |
| BCK-38-014 successor | Dashboards data validation | CLOSED data-layer — W1/W2 validated vs live queries; visual-render split out login-gated as OW-41-03; EID-mapping question split out as OW-41-02 | phase41-61/-62 |
| R-SO | security-onion resurrection risk | CLOSED — restart=no + exited(0) verified live; volumes intact untouched | phase41-80 |

## 4. Standing Rule

Future reports reference ONLY these OW IDs for tracked work. Canonical copies:
this file + `canonical/current/current-state-20260826-postp41.md`. AGENTS.md Known
Blockers mirrors the open set pointer-wise (refreshed under CHG-41-AGENTS-01).
