# Phase 38-89: Full Drift Reconciliation Report

**Report ID:** phase38-89-full-drift
**Phase:** 38
**Title:** Phase 38-89: Full Drift Reconciliation Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-89-full-drift.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-89 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-89-full-drift.md`
**Retention Class:** LONG

---

## 1. Executive Summary

This report reconciles five planes of the stack against each other: (a) canonical docs — current-state phase38-49 and the designed governance set 55–64; (b) runtime truth from live commands executed this session; (c) the report corpus (1,922 md files; 88 in generated/); (d) evidence stores (ledgers 50–53, catalogs 61–63, backups); (e) release artifacts (git tag v1.3.0 @ commit c726182, bundle manifest sha256 da72bde…, RELEASE-NOTES at v1.2.0 published + v1.3.0 notes present).

Eight mandated drift items (D-01…D-08) are dispositioned below, plus three new drift items discovered during reconciliation (D-09…D-11). Net verdict: **runtime is healthier than docs claim in two places (snapshots live; execution count lower), and docs are wrong in one security-relevant place (credentials in reports vs no-secret attestation).**

## 2. Reconciliation Matrix

| Plane | Source checked this session | State |
|-------|------------------------------|-------|
| Canonical docs | phase38-49 current-state; 55–64 designs | Present; 49 internally consistent but contains now-superseded figures |
| Runtime | OpenSearch GREEN/3 nodes/274 shards; disk 83%; mem 75%/swap 64%; PSI cpu ~4%; fleet via Wazuh API; Shuffle API; docker/ss/cron | Captured live 21:00–21:17 UTC |
| Report corpus | `find ops/reports -name '*.md'` = 1,922 (generated = 88) | Growing concurrently (writers added files mid-validation per phase38-66) |
| Evidence | Ledgers 50–53 intact; fs snapshots 42 (latest today); s3 snapshots 85 (latest today); IRIS dumps 14-day chain | Intact, zero deletions |
| Catalogs | catalog-reports.csv/json; source map 62; machine catalog 61; backlinks 63 | Exist; pre-date this session's corrections → stale pointers |
| CI | report-ci design (71); schema validator runs recorded in 66 | Validation active as report-time check; not a repo CI gate |
| Release v1.3.0 | tag exists; manifest: archive mct-security-stack-release-20260824-203124.tar.gz, 9.9M, 2,040 files, sensitive_files: 0, sha256 da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c | Bundle coherent EXCEPT sensitive-file claim contradicted by generated-corpus creds |

## 3. Mandated Drift Items

### D-01 — Field-error mechanism misattribution — Severity HIGH
- **Docs said:** decoder-side `decoder_order_size` issue (multiple reports incl. 49/92).
- **Runtime says:** indexer bulk rejection `java.lang.IllegalArgumentException: Limit of total fields [1000] has been exceeded`; 14,105 occurrences/24h (node1 8,107 + node2 5,998 + node3 0) ≈147/min. `wazuh-alerts-*` template sets limit 10000; `wazuh-archives-*` sets none → inherits OpenSearch default 1000.
- **Disposition:** CORRECT THE DOCS. Mechanism is index-mapping field budget on archives. Fix: raise archives template to 10000 or flatten ingest. Docs edit + fix tracked as P1.

### D-02 — Shuffle routing claims vs reality — Severity MEDIUM
- **Prior claims:** "796 executions, zero real routing" (phase38-00/01 era).
- **Live API:** high-severity workflow = **68 executions (65 FINISHED / 3 ABORTED)**; classb workflow = 1. Actions labeled notify-only ("Log received alert", "Create DFIR-IRIS alert"); trigger shows `is_valid:false`.
- **Disposition:** UPDATE headline numbers wherever cited; open P1 investigation to reconcile 68 executions against IRIS alert inventory (test vs real artifact creation unknown). See phase38-86 §4.

### D-03 — Relief forecast vs zero deletions — Severity LOW (expected behavior)
- **Forecast:** first expiry ≈2026-08-29 (~1.8 GB).
- **Runtime:** all 11 archives hot, `condition_not_met`, realized relief 0 GB; plateau ~2026-09-12.
- **Disposition:** CONFIRMED consistent. No forced deletion performed. Next checkpoint 08-30.

### D-03b — NEW: Snapshot repository state reversed — Severity HIGH (docs wrong)
- **Prior claim:** "NO snapshot repository registered (`repository_missing_exception`)". This appears in working state assumptions for phases up to now.
- **Runtime:** `_cat/repositories` lists `wazuh-backup` (fs, /snapshots) and `do-spaces` (s3, nyc3 bucket wazuh/wazuh-snapshots). fs holds **42 snapshots** (latest snap-20260825-2017, 56 indices); s3 holds **85** (latest s3-snap-20260825-2047, 95 indices). Both fired TODAY.
- **Disposition:** STALE CLAIM RETIRED. Retention deletes are restore-safe. Update current-state doc and any runbook asserting missing repo.

### D-04 — Fleet counts across eras — Severity MEDIUM (narrative confusion)
- Eras on record: "3/3 client fleet" (v1.2.0 era) → "8 ACTIVE incl 015 reconnect" (today's corrected state) → live snapshot: 000+6 sensors active, 013 offline 15h, **015 reconnected 20:11Z then disconnected again by query time**, 008 retired & absent.
- **Disposition:** Standardize on REGISTERED(9)/ACTIVE-at-last-keepalive/ONLINE-NOW triple in current-state doc; bill per phase38-80 §4. 015 flapping must be stated, not smoothed.

### D-05 — Corpus counts — Severity LOW
- Claims ranged "~1900 md". Measured: **1,922 md total; 88 in generated/**. Concurrent writes continue (phase38-66 observed file-count movement between validation passes).
- **Disposition:** Freeze a count only inside a catalog run (61/62 refresh) with timestamp; never cite point-in-time corpus size in gates without the freeze note.

### D-06 — Frozen catalog vs concurrent writers — Severity MEDIUM
- phase38-66 explicitly recorded an earlier partial pass over 80 files (12 PASS/68 FAIL) superseded by 85-file final (13 PASS/72 FAIL) while writers were active; catalogs (csv/json) were snapshotted against a moving corpus.
- **Disposition:** Adopt write-freeze window or catalog re-run immediately before gate decisions; mark current catalog as BEST-EFFORT snapshot.

### D-07 — Credentials in generated reports vs no-secret attestations — Severity **CRITICAL**
- **Attestations say:** release-manifest `sensitive_files: 0`; scripts assert "never prints secrets".
- **Reality:** 5 generated files match credential patterns; confirmed literals at phase38-00-master.md:63 ([REDACTED password literal]), phase38-01-preflight.md:131 (bearer token literal), phase38-73 §Step 1 (credential-bearing migration args). Additionally every archived workflow export JSON carries 1 bearer reference.
- **Disposition:** REDACT the 5 files + scrub exports; ROTATE exposed dashboard password and Shuffle bearer token (rotation already deferred in 73 — approval outstanding); make secret scan fail-closed in the release gate. Until rotation completes, treat v1.3.0-bundle-adjacent reports as credential-exposed if shared.

### D-08 — Security Onion retired-but-running — Severity MEDIUM (hygiene)
- **Docs:** SO packet scanning retired at P31; Suricata-minimal is the packet engine.
- **Runtime:** container `security-onion` Up 22h (healthy), image balabit/syslog-ng digest-pinned, ~0% CPU / 15 MB RSS, ports 601/514udp/6514 internal-only.
- **Disposition:** No exposure (no host ports), negligible cost — but retirement should be REAL: stop container, keep compose disabled block for rollback. Also corrects usability false-health signal (a running "SO" implies capability that docs say was retired).

## 4. Newly Discovered Drift Items

### D-09 — Agent 015 stability narrative — Severity MEDIUM
Reconnect-today record is true (KA 20:11:20Z) but the same-day relapse to disconnected was not captured anywhere until now. Disposition: add flap tracking; owner outreach if absent >24h.

### D-10 — "433 Suricata alerts" measurement semantics — Severity LOW
The figure verifies ONLY under full-text `_count?q=suricata` (returns exactly 433 across all alerts indices). Term-level breakdowns are far smaller (rule.groups:suricata=5; decoder.name:suricata=0; archives EVE lines=104, of which alert-grade=1). Disposition: annotate phase38-49/24 citations with the query form so future audits don't misread magnitude.

### D-11 — Wazuh API `agents_list=all` failure — Severity LOW
Explicit ID-list queries succeed; `all` returns error payload. Disposition: P3 backlog (likely param handling quirk on 4.14.7 API path); wrap in `agent_control` script.

## 5. Cross-Plane Consistency Snapshot (live values to seed next current-state)

```
Cluster: green · 3 nodes · 274 shards · 145 primary · 0 unassigned
Disk:    117G/148G used (83%) · 25G avail
Memory:  11736/15553 MB (75%) · swap 5319/8191 (64%) · PSI cpu some avg10≈3.9%
Archives: 11 indices · 17,378,244 docs · ≈15.0 GB · policy hot→delete@14d · 0 deleted · first ETA 08-29T21:00Z
Snapshots: fs 42 snaps (latest today 20:17) · s3 85 snaps (latest today 20:47)
Fleet:   9 registered · 6 sensors + manager online · 013 offline 15h · 015 flapping · 008 retired
Shuffle: frontend 3001 (0.0.0.0, HTTP) · backend 5001 localhost · workflows 2 · execs 68+1
Alerts:  today 47,834 docs/54.2 MB alerts tier · archives tier ≈35k docs/h · suricata full-text 433
Field errors: 14,105/24h (~147/min) — mapping-limit mechanism confirmed
/tmp:    1.6 GB/21% · 10,215 entries · cleanup cron pending first run 08-26 03:00Z
```

## 6. Disposition Ledger

| Item | Sev | Class | Action | Owner gate |
|------|-----|-------|--------|-----------|
| D-01 | HIGH | doc-wrong + perf | Correct mechanism docs; raise archives field limit | platform |
| D-02 | MED | stale metric | Update counts; IRIS reconciliation task | SOC lead |
| D-03 | LOW | expected | None; verify 08-30 | — |
| D-03b | HIGH | stale claim | Rewrite repo status in current-state + runbooks | docs owner |
| D-04 | MED | narrative | Adopt triple-count fleet reporting | docs owner |
| D-05 | LOW | bookkeeping | Timestamped catalog freezes | docs owner |
| D-06 | MED | process | Write-freeze before gates | SOC lead |
| D-07 | CRITICAL | security | Redact 5 files; rotate creds; fail-closed scan | operator approval |
| D-08 | MED | hygiene | Stop retired SO container | platform |
| D-09 | MED | monitoring | Flap tracking for 015 | endpoint owner |
| D-10 | LOW | precision | Annotate 433 citation query form | docs owner |
| D-11 | LOW | tooling | agent_control wrapper + API quirk note | platform |

---
*Every runtime value above was captured from live commands 2026-08-25 21:00–21:17 UTC. No secrets printed.*
