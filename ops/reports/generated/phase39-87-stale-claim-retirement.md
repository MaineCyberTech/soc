# Stale Claim Retirement RETIRE-39-01

**Report ID:** phase39-87-stale-claim-retirement
**Phase:** 39
**Title:** Retirement RETIRE-39-01 — Disposition Walk of CON-38-01..10 and STL-38-01..12 with Updated Canonical Stale Map
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:07:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-87-stale-claim-retirement.md`

---

## 1. Method

Every contradiction record (phase38-44, CON-38-01…10) and stale-chain record (phase38-45,
STL-38-01…12) is walked against live 2026-08-25/26 state. Dispositions used:

- **RESOLVED-TODAY** — new Phase 39 evidence closes or corrects the chain (reference given).
- **CLOSED** — claim adjudicated moot/irrelevant; no further tracking.
- **REMAINS-OPEN** — system change still pending; owner restated.
- **OBSERVATION-PENDING** — date-driven closure (calendar item).

Compliance statement up front: **no historical text was edited anywhere.** All dispositions live in
this registry and in supersession pointers applied by APPLY-39-01 frontmatter; originals and their
canonical copies are byte-frozen (hash-verified phase39-48).

## 2. Contradictions Register Walk (CON-38-01 … CON-38-10)

| ID | Topic | Disposition today | Evidence / remaining work |
|---|---|---|---|
| CON-38-01 | Field-error mechanism misattributed (decoder vs indexer mapping limit) | **RESOLVED-TODAY** | Mechanism corrected AND fixed via template chain phase39-21→28 (`wazuh-archives-fieldlimit`, total_fields.limit=2000); certification in phase39-28. System-side proof index = first post-template daily archive (`wazuh-archives-4.x-2026.08.26`) — see §4 |
| CON-38-02 | "ELIMINATED" false-negative verification artifact | **RESOLVED-TODAY** | Live-signature verification discipline codified (CI gates p38-report-ci/p39-canonical-ci run tree-wide today: PASS, 0 secret/stale hits); rejection counters tracked per-index in phase39-24/-25 |
| CON-38-03 | Shuffle frontend loopback-vs-exposed | **REMAINS-OPEN (improved)** | Interface-bind hardening APPLIED this phase: listener now `192.168.222.149:3001` (was `0.0.0.0`), backend still `127.0.0.1:5001`; TLS absent by design until P40 proxy. Owner: SOAR ops owner. Chain: phase39-13…19 |
| CON-38-04 | "no workflows" vs 2 workflows | CLOSED (P38) | Canonical phrasing locked phase38-49 §6; no relapse observed in P39 reports |
| CON-38-05 | "all healthchecks / zero real routing" vs real executions | **RESOLVED-TODAY** | Healthcheck-only characterization retracted by delivery proof: ≥3 consecutive real deliveries verified (phase39-34), failure analysis phase39-29/35, routing recertification phase39-36 (CONDITIONAL-PASS manual lane) |
| CON-38-06 | Retention relief ~7.9GB forecast vs computable ~3.76GB | **OBSERVATION-PENDING** | Still OPEN until first ISM wave observed **Aug-29**; disk-relief proof methodology staged phase39-74. Owner: Infrastructure owner |
| CON-38-07 | Corpus count variance 1831/1833/1877 | **RESOLVED-TODAY** | Count statements now class+scoped; canonical counter = catalog (183 rows) + manifest (1,992 rows), both hash-pinned; drift handled by refresh passes (D1, phase39-96) |
| CON-38-08 | Agent fleet snapshots drifting | REMAINS-OPEN (bounded) | Fleet stable at 7 active / 10 registered in today's endpoint-count-report run; residual churn is snapshot-aging only. Owner: Endpoint ops owner (013 recovery phase39-75, 015 flap phase39-76) |
| CON-38-09 | Release provenance "fully verified" vs asset availability | **RESOLVED-TODAY (partial)** | On-box gap closed honestly: v1.3.0 archive REBUILT from tag into `ops/releases/v1.3.0/` with MANIFEST.md disclosing that rebuilt sha256 `65f794a7…` ≠ published `da72bde4…` (phase39-68…70). Published-original retrieval remains an owner-item (OPENWORK register) |
| CON-38-10 | "Retention deletes observed" vs ZERO deletions under current ISM | **OBSERVATION-PENDING** | Merged into CON-38-06 disposition; canonical phrasing unchanged ("armed, zero deletions, first expiry ≈08-29"). Owner: Infrastructure owner |

## 3. Stale Chain Walk (STL-38-01 … STL-38-12)

| ID | Chain | Disposition today |
|---|---|---|
| STL-38-01 | decoder_order_size default→512→IRRELEVANT | **CLOSED** — irrelevance adjudicated and fixed-correctly via template chain phase39-21..28; knob documented as unrelated in certification |
| STL-38-02 | Shuffle binding loopback→exposed | REMAINS-OPEN (TLS axis) — bind hardened to LAN IP this phase (live `ss` evidence, §2 CON-03); full closure at P40 TLS proxy |
| STL-38-03 | Field-error signature string evolution | **RESOLVED-TODAY** — exact signature counts now measured per-index with windows (phase39-24/-25/-26); inherited-string practice retired |
| STL-38-04 | Agent fleet lists evolving | REMAINS-OPEN (snapshot discipline) — current snapshot: 7 active (000,006,007,011,012,014,016-class fleet minus 013 offline, 015 flapping, 008 retired); every fleet statement carries capture timestamp |
| STL-38-05 | Disk usage aging | Refreshed-today: `/` = 119G/148G (84%), 24G avail — matches P38 canonical posture; wave relief pending Aug-29 |
| STL-38-06 | Memory/swap aging | Refreshed-today: Mem 11,763/15,553 MB used (~76%), Swap 5,397/8,192 MB (~64%); PSI cpu some avg10≈3.6 — consistent with P38 baseline |
| STL-38-07 | Execution characterization | **RESOLVED-TODAY** — same proof chain as CON-38-05 (phase39-34 delivery check rerun fresh: delivered=37 failed=31 aborted=3 other=4) |
| STL-38-08 | Corpus count chain | **RESOLVED-TODAY** — see CON-38-07 |
| STL-38-09 | Retention status chain | OBSERVATION-PENDING — Aug-29 wave; zero forced intervention per AGENTS.md MUST-NOT |
| STL-38-10 | Deployability RTO/RPO silence | REMAINS-OPEN — RTO/RPO inventory + draft exist (phase39-81/-82), restore-target criteria (83) and rehearsal plan (84) authored; sign-off + execution pending. Owners: Platform + SOC lead |
| STL-38-11 | Release provenance phrasing | **RESOLVED-TODAY (honesty model)** — rebuilt-label disclosure replaces overclaim; published-asset retrieval tracked separately |
| STL-38-12 | OpenSearch credential stability | MONITOR — credentials functional all day (dozens of authenticated queries across phases 39 arcs incl. today's audits); risk R-18 single-anomaly not reproduced |

## 4. Updated Canonical Stale Map (summary table)

| Claim family | Old canonical (P38) | New canonical (this report) | State |
|---|---|---|---|
| Field-limit errors | Indexer mapping limit; fix designed | Template applied+certified (phase39-28); proof index 2026.08.26 pending flatline confirmation tomorrow | RESOLVED-narrative / PROOF-PENDING |
| SOAR value | 65 finished real executions, intermittent delivery | Consecutive-delivery proven; lifetime delivered=37 / failed=31 / aborted=3; production auto-routing still gated on webhook wiring | RESOLVED / routing CONDITIONAL-PASS manual lane |
| Shuffle exposure | 0.0.0.0:3001 no TLS no firewall | LAN-IP-bound :3001, firewall applied, authz tested (phase39-17/18); TLS deferred P40 | IMPROVED / OPEN(TLS) |
| Retention | armed, zero deletions | unchanged; wave Aug-29 observation scheduled | OBSERVATION-PENDING |
| Release | verified-in-session, not on-box | rebuilt-from-tag archive on-box, labeled non-matching; retrieval of original open | RESOLVED-honest / retrieval OPEN |
| Corpus counts | 1,888–1,900 era figures | catalog 183 rows; canonical tree 1,983 md / 1,996 files; originals preserved | RESOLVED |

## 5. Compliance

Zero body edits to any historical file this phase (finals-immutable respected; only sanctioned
catalog/frontmatter marker mechanics from APPLY-39-01, already certified). This registry is the
sole narrative-resolution surface; chronology authority remains phase38-45 §1 rule.

## 6. Review Triggers (carried forward)

ISM first wave (2026-08-29), field-proof flatline on 08.26 index, Shuffle TLS landing (P40),
any agent-fleet change event.
