# Phase 39 Consolidated Backlog (P0–P3)

**Report ID:** phase39-97-backlog
**Phase:** 39
**Title:** BCK-39-001…016 — Consolidated Phase 40 Backlog Merging All Still-Open Items Plus Remaining phase38-90 Carryovers
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-97-backlog.md`

---

## 1. Purpose and Method

This register merges every still-open item from the Phase 39 arcs with the carryovers from
`phase38-90-backlog.md` that remain unclosed after today's work. Canonical IDs here are
`BCK-39-0xx`; every item crosswalks to its BCK-38 lineage and to same-day phase39 evidence so no
history is lost. Items closed this phase (token rotation BCK-38-001/002, exposure binding BCK-38-004,
IRIS DNS+delivery BCK-38-005 core, migration APPLY BCK-38-008, on-box rebuilt asset BCK-38-009-half,
enum bulk fix BCK-38-013) are dispositioned in §4, not silently dropped.

Sorted by priority, then effort (XS < S < M < L). Quick-wins flagged ⚡.

### Priority distribution

| Priority | Count | Canonical IDs |
|----------|-------|---------------|
| P0 | 4 | BCK-39-001 … 004 |
| P1 | 5 | BCK-39-005 … 009 |
| P2 | 5 | BCK-39-010 … 014 |
| P3 | 2 | BCK-39-015, 016 |

---

## 2. Crosswalk — Canonical → Lineage

| Canonical | BCK-38 lineage | Origin plane |
|-----------|----------------|--------------|
| BCK-39-001 | BCK-38-003 (verification half; fix applied P38→P39) | Detection pipeline |
| BCK-39-002 | BCK-38-012 (extended by real defect found P39) | Endpoints |
| BCK-39-003 | BCK-38-011 | Endpoints |
| BCK-39-004 | BCK-38-010 | Capacity / retention |
| BCK-39-005 | BCK-38-006 + residual of BCK-38-005 (automated lane) | SOAR |
| BCK-39-006 | BCK-38-007 | SOAR / detection |
| BCK-39-007 | Residual of BCK-38-004 (TLS half, deferred P39→P40) | Security |
| BCK-39-008 | Residual of BCK-38-009 (original-asset retrieval) | Release |
| BCK-39-009 | Sign-off half of BCK-38-015 | Resilience / business |
| BCK-39-010 | Import half of BCK-38-014 (artifact done P39) | Visibility |
| BCK-39-011 | Follow-up of P39 persistence proof (phase39-19) | Security / infra |
| BCK-39-012 | New this phase (monitor built, unscheduled) | SOAR ops |
| BCK-39-013 | Execution half of BCK-38-016 (mapping prepared P39) | Corpus hygiene |
| BCK-39-014 | New this phase (owner decision) | Infrastructure |
| BCK-39-015 | Residue of BCK-38-013/016 (one ambiguous enum, stub tombstones, missing finals waiver) | Governance |
| BCK-39-016 | Standing capacity program (84% plateau) | Capacity |

---

## 3. Backlog Detail

### BCK-39-001 (P0, effort S ⚡calendar-bound) — Verify field-limit fix effectiveness on first post-template archives index

| Field | Value |
|---|---|
| Description | Archives mappings saturated at 999–1000 fields under the old `limit:1000` ceiling — the data.stats burst alone consumed 547 slots, crowding out data.win fields and driving the ~150/min rejection baseline (frozen this phase). Template `wazuh-archives-fieldlimit` (total_fields.limit 2000, ISM carried, priority 320) verified in cluster state; `simulate_index` resolves 2000+ISM correctly. Effectiveness proof lands only with the first new daily index. |
| Owner | Platform / detection engineering |
| Dependencies | Calendar: run ready-script any time after 2026-08-26T00:00Z when `wazuh-archives-4.x-2026.08.26` exists. |
| Acceptance criteria | (1) `_settings` of the 08.26 index shows `total_fields.limit=2000` AND ISM policy attached; (2) rejection rate flatlines (<1/day vs frozen baseline ~150/min); (3) mapped-field count on the new index rises above the old 999–1000 freeze without rejections; (4) result appended to phase39-28 certification as PASS or escalated per its saturation-contingency clause. |
| Rollback | `DELETE _index_template/wazuh-archives-fieldlimit` — existing indices unaffected; rejection noise returns, no data loss. |
| Evidence links | phase39-21/22/23/24/25/26/27/28 |
| Phase-40 effect | Converts "applied+simulated" into closed-with-live-evidence; recovers previously rejected telemetry. |

### BCK-39-002 (P0, effort XS once owner reachable ⚡quick-win) — Fix mac-clients merged.mg permission defect on agent 015

| Field | Value |
|---|---|
| Description | REAL DEFECT discovered during flap correlation: manager logs show `mac-clients/merged.mg Permission denied` every 10 s. Distinct from the sleep-cycle flap itself. Fix is a chmod/chown-level change pending device-owner reachability. |
| Owner | Endpoint ops + device owner (Julians-Air) |
| Dependencies | Owner availability; one terminal session on the device. |
| Acceptance criteria | (1) Zero `merged.mg Permission denied` lines in manager logs over a 24 h window post-fix; (2) agent receives merged configuration (verify via agent config sync log line); (3) flap metric re-baselined separately from this defect. |
| Rollback | Revert file mode to prior state recorded at fix time; defect returns, no data risk. |
| Evidence links | phase39-76 |
| Phase-40 effect | Removes a real (if low-blast-radius) config-distribution failure; cleans 015's billable-active judgment. |

### BCK-39-003 (P0, effort M — human-latency) — Recover agent 013 (SAMSUNG)

| Field | Value |
|---|---|
| Description | Offline since the 06:30Z cutoff (~17 h+). Physical/owner ask is documented and dispatched; recovery blocked on human response, not tooling (manager API is the sanctioned interface). |
| Owner | Endpoint ops + device owner |
| Dependencies | Physical access / power-on by owner. |
| Acceptance criteria | Agent ACTIVE in fleet API; keepalive stable >24 h; cause note filed (sleep/lid/uninstall/network). |
| Rollback | N/A. |
| Evidence links | phase39-75 |
| Phase-40 effect | Restores capture denominator toward 9/9; billing matrix upgrade. |

### BCK-39-004 (P0, effort S, dated 2026-08-29T21:00Z) — Observe first policy-driven ISM deletion wave

| Field | Value |
|---|---|
| Description | First expiry ETA stands at 2026-08-29T21:00Z (~1.8 GB relief against ~15 GB archive footprint). No forced deletion permitted; restore-safe spot-check already proven this quarter (phase39-73), so deletions can be trusted if the wave fires cleanly. |
| Owner | Platform / infrastructure |
| Dependencies | Calendar checkpoint 2026-08-30. |
| Acceptance criteria | Post-wave: deleted-index count matches ISM policy math; disk% drop observed in trend log; one expired index restorable from snapshot if sampled; observation appended to retention verification chain. If the wave does NOT fire, escalate to ISM diagnostics — never force-delete. |
| Rollback | N/A (observation task). |
| Evidence links | phase39-71/72/73/74 |
| Phase-40 effect | Converts retention forecast into realized-relief evidence; input to capacity decision (BCK-39-016). |

### BCK-39-005 (P1, effort S ⚡quick-win: one UI session) — Wire Wazuh→Shuffle webhook (automated production routing)

| Field | Value |
|---|---|
| Description | Manual/API lane is certified CONDITIONAL-PASS on direct evidence (3 consecutive real deliveries → IRIS HTTP 200 ×3 → DB alerts 37/38/39). The automated Wazuh-integrator→Shuffle trigger remains unwired (`is_valid:false` lineage); until wired, production alerts do not autonomously enter the SOAR lane. |
| Owner | SOAR-ops |
| Dependencies | Delivery path proven (done); ideally after TLS decision (BCK-39-007) but not blocked by it on trusted LAN. |
| Acceptance criteria | (1) Workflow trigger shows valid=true in Shuffle UI; (2) one real high-severity alert traverses Wazuh→Shuffle→IRIS end-to-end with execution ID + IRIS alert ID captured; (3) config-of-record block version-controlled (phase39-37 report finalized from DRAFT); (4) rollback path documented before enabling. |
| Rollback | Disable webhook/integrator stanza; revert restores manual/API-only certified lane. |
| Evidence links | phase39-34/36/37 |
| Phase-40 effect | Upgrades routing certification CONDITIONAL-PASS→PASS; converts billing notification lane to fully automated. |

### BCK-39-006 (P1, effort M) — Packet-workflow UI import plus replay/failure proofs

| Field | Value |
|---|---|
| Description | Packet workflow exists per design (phase39-38/39 artifacts) but UI import, replay proof, and forced-failure proof remain open; packet lane rides deferred status. |
| Owner | SOAR-ops + detection engineering |
| Dependencies | BCK-39-005 (known-good transport first). |
| Acceptance criteria | Workflow imported via UI and promoted; synthetic Suricata-style event produces execution landing in IRIS; one forced-failure case exercised with expected failure-mode handling; export hashed into `ops/evidence/p39-workflow-export/`. |
| Rollback | Delete workflow object; production lanes untouched. |
| Evidence links | phase39-38/39/40/41/42 |
| Phase-40 effect | Closes last detection-plane workflow gap; removes "packet-lane deferred" disclosure from billing. |

### BCK-39-007 (P1, effort M, decision-forced early Sept) — Shuffle TLS reverse proxy

| Field | Value |
|---|---|
| Description | Exposure restricted this phase (publish binding moved 0.0.0.0→192.168.222.149 mgmt-only; loopback/docker-bridges blocked; authorized tests PASS). Plaintext-on-trusted-LAN accepted as a dated risk; TLS slipped P38→P39 and must be decided, not re-deferred. |
| Owner | SOAR-ops + infrastructure |
| Dependencies | Operator decision gate (per AGENTS.md approval list); reverse-proxy choice (caddy/nginx) provisioned. |
| Acceptance criteria | EITHER: HTTPS termination live, HTTP redirect or blocked, cert expiry monitored, unauthorized-test rerun PASS — OR: written risk-acceptance with expiry date signed by operator and registered. No third outcome. |
| Rollback | Proxy container removal restores current hardened-plaintext posture. |
| Evidence links | phase39-13/14/15/16/17/18/20 |
| Phase-40 effect | Clears security RAG AMBER; removes standing limitation from billing/scorecard. |

### BCK-39-008 (P1, effort M — external-blocked) — Retrieve published v1.3.0 release asset

| Field | Value |
|---|---|
| Description | On-box gap closed this phase with a REBUILT-LABELED archive derived from tag tree `33d8443…` (sha256 `65f794a7…`, DIFFERENCE-FROM-PUBLISHED manifest). Byte-exact published original (`da72bde4…`) remains unretrieved: `gh` unavailable, network path blocked. Owner item if byte-equality ever required (audit/legal). |
| Owner | Release engineering + owner (credentials/network path) |
| Dependencies | Working `gh` or authenticated network path. |
| Acceptance criteria | Published asset downloaded; sha256 matches `da72bde4…` record; stored beside rebuilt archive with sidecar hash and catalog entry; MANIFEST.md updated to reference both artifacts. |
| Rollback | Deletion safe; rebuilt-labeled archive already covers content identity. |
| Evidence links | phase39-68/69/70 |
| Phase-40 effect | Converts release assurance from ASSURED-WITH-LABELED-DELTAS toward full byte-exact chain. |

### BCK-39-009 (P1, effort S — business decision meeting) — RTO/RPO sign-off

| Field | Value |
|---|---|
| Description | Measured cadences inventoried (fs ~5–6 snaps/day, s3 daily); draft objectives staged as PROPOSED-BUSINESS-DECISION: Alerts RPO≤1h/RTO≤4h; Archives RPO≤24h/RTO≤8h; Config/Workflows RPO≤24h/RTO≤2h; Full-cluster RTO undefined until rehearsal. Nothing binds until signed. |
| Owner | SOC lead / business owner |
| Dependencies | None technical; pairs with rehearsal target provisioning (feeds DEPLOY blockers B1/B2). |
| Acceptance criteria | Signed values recorded in change register; draft report status moves PROPOSED-BUSINESS-DECISION→ADOPTED with signature reference; unsigned items excluded from deployability claims. |
| Rollback | N/A (document decision). |
| Evidence links | phase39-81/82/83/84 |
| Phase-40 effect | Unblocks rehearsal go/no-go chain; deployability blocker B2 cleared. |

### BCK-39-010 (P2, effort S ⚡operator UI session) — Dashboard runtime import (W1/W2)

| Field | Value |
|---|---|
| Description | Importable ndjson artifact written and structurally validated (8 objects parse OK); interim text-table runbooks usable today. Runtime import into OpenSearch Dashboards awaits an operator session. |
| Owner | Detection engineering / operator |
| Dependencies | None blocking; field-fix proof (BCK-39-001) makes W1 panels meaningful sooner. |
| Acceptance criteria | Saved objects import with zero ID conflicts (overwrite off confirmed); dashboards render with live data; screenshot evidence archived; artifact hash registered. |
| Rollback | Delete saved objects; text-table runbooks remain fallback. |
| Evidence links | phase39-79 |
| Phase-40 effect | Closes declared v1.3.x feature gap; release-assurance "dashboards pending" item resolved. |

### BCK-39-011 (P2, effort S) — Reboot persistence test for exposure controls

| Field | Value |
|---|---|
| Description | Persistence via compose proven declaratively (binding lives in compose file); an actual reboot-cycle test is the follow-up. `@reboot` repair hook already present in crontab as belt-and-braces. |
| Owner | Infrastructure |
| Dependencies | Maintenance window. |
| Acceptance criteria | Post-reboot: publish binding still 192.168.222.149-only; loopback/bridge blocks active; authorized test PASS; unauthorized test FAIL; evidence captured. |
| Rollback | Compose revert; known-good current state documented. |
| Evidence links | phase39-15/19 |
| Phase-40 effect | Hardens exposure claim against host restarts; supports deployability evidence pack. |

### BCK-39-012 (P2, effort XS ⚡quick-win) — Schedule delivery-monitor cron

| Field | Value |
|---|---|
| Description | `p39-iris-delivery-check.sh` works (live run today: delivered=37 failed=31 aborted=3 other=4) but runs on demand only; silent-degradation detection requires scheduling. |
| Owner | SOAR-ops |
| Dependencies | Threshold decision (alert on failed-delta). |
| Acceptance criteria | Cron entry installed; two consecutive scheduled runs produce logs; one injected-failure test triggers the alert path; crontab change recorded. |
| Rollback | Remove cron line. |
| Evidence links | phase39-35 (failure-alert design); live output in phase39-100 §3 |
| Phase-40 effect | Prevents recurrence of the silent-degradation era that ran ~Aug-15→Aug-25. |

### BCK-39-013 (P2, effort M, approval-gated) — Execute duplicate-collapse per prepared mapping

| Field | Value |
|---|---|
| Description | Dup-alias mapping prepared this phase; execution withheld behind approval gate (non-destructive review-required marks used meanwhile). |
| Owner | Governance |
| Dependencies | Operator sign-off recorded in change register. |
| Acceptance criteria | Collapses applied exactly per mapping; redirect notes present; catalogs regenerated; link-check CI green; count of collapsed groups reported. |
| Rollback | Git-tracked tree post-commit gives mechanical reversal. |
| Evidence links | phase39-77/78; canonical open-work register |
| Phase-40 effect | Shrinks corpus surface; finishes BCK-38-016 hygiene arc. |

### BCK-39-014 (P2, effort XS decision) — SecurityOnion container stop decision

| Field | Value |
|---|---|
| Description | Owner decision recorded as open: stop idle container(s) or retain with justification. Non-destructive default (retain) applies until decided. |
| Owner | Infrastructure owner |
| Dependencies | Capacity context (84% plateau) may motivate stop. |
| Acceptance criteria | Written decision (STOP with pre-stop snapshot evidence, or RETAIN with reason code) in change register; if STOP: service disabled cleanly, compose profile updated, rollback documented. |
| Rollback | Compose up restores service. |
| Evidence links | canonical/current/open-work.md entry |
| Phase-40 effect | Removes an open decision from the register; small capacity contribution. |

### BCK-39-015 (P3, effort S) — Corpus governance residue batch

| Field | Value |
|---|---|
| Description | Three leftovers: (a) one ambiguous legacy status enum listed-not-guessed needs ruling; (b) stub tombstone plan executed beyond review-required marks; (c) missing finals P1/P36 formally authored or waived. |
| Owner | Governance |
| Dependencies | Ruling on (a) unblocks validator-zero target. |
| Acceptance criteria | Ambiguous case dispositioned with reason code; stubs tombstoned-or-populated; P1/P36 finals exist or waiver recorded; enum CI stays green. |
| Rollback | Mapping table permits mechanical reversal. |
| Evidence links | phase39-77/78 |
| Phase-40 effect | Drives legacy-status exceptions to true zero. |

### BCK-39-016 (P3, ongoing) — Capacity program at 84% plateau

| Field | Value |
|---|---|
| Description | Host self-disqualified as rehearsal target (148G disk, 84% used, 24G avail); plateau forecast holds without intervention. ISM wave (BCK-39-004) gives partial relief; structural headroom decision remains open. External rehearsal/provisioning target REQUIRED regardless. |
| Owner | Infrastructure owner |
| Dependencies | BCK-39-004 outcome; business budget cycle. |
| Acceptance criteria | Trend log updated weekly; either headroom added OR written forecast-acceptance with trigger threshold; rehearsal target provisioned per phase39-83 criteria. |
| Rollback | N/A (planning item). |
| Evidence links | phase39-74/83/84 |
| Phase-40 effect | Feeds DEPLOY blocker B1; prevents ingest-degradation tail-risk. |

---

## 4. Dispositioned / Closed This Phase (no longer backlog)

| Lineage | Disposition |
|---|---|
| BCK-38-001 rotate + BCK-38-002 redact | **CLOSED.** Old bearer invalidated server-side (401 post-restart); new key stored mode-600 gitignored; recursion sweep redacted additional leaks incl. classb export; tracked set clean (CI triple-GREEN). phase39-06/07/09/10/11/12 |
| BCK-38-004 exposure (firewall half) | **CLOSED (mechanism changed).** Host lacks iptables entirely; control implemented at publish-binding layer instead (0.0.0.0→192.168.222.149) + loopback/bridge blocks; authorized tests PASS. TLS half retained as BCK-39-007. phase39-13…20 |
| BCK-38-005 IRIS delivery (core) | **CLOSED.** Root causes fixed (overlay-DNS isolation; corrupted Authorization header inside live workflow); 3-consecutive-delivery proof MET. Automated-lane residual → BCK-39-005. phase39-29…36 |
| BCK-38-008 migration APPLY | **CLOSED.** 1,992/1,992 copied copy-first, hashes verified N=1992 M=0, rollback drill clean, originals untouched. phase39-43…52 |
| BCK-38-009 on-box asset | **HALF-CLOSED.** Rebuilt-labeled archive on-box with manifest; original retrieval → BCK-39-008. phase39-68/69/70 |
| BCK-38-010 restore-safe spot-check precondition | **SATISFIED** ahead of wave via RESTORE-CHK-39-01 (phase39-73); observation itself → BCK-39-004. |
| BCK-38-013 legacy enums (bulk) | **SUBSTANTIALLY CLOSED.** 14 legacy values mapped/applied; CI re-PASS; single ambiguous case → BCK-39-015a. phase39-77/78 |

---

## 5. Sequencing View for Phase 40

```
Morning after 00:00Z:
  BCK-39-001 run ready-script + observe (minutes)

Week 1 (while owners reachable):
  BCK-39-002 merged.mg chmod (XS) ──► BCK-39-003 013 recovery chase
  BCK-39-009 RTO/RPO sign-off meeting ──► BCK-39-007 TLS DECISION FORCED
  BCK-39-005 webhook UI session ──► BCK-39-006 packet import session

Dated:
  BCK-39-004 observe wave Aug-29T21:00Z ──► BCK-39-016 capacity decision

Anytime (XS quick-wins):
  BCK-39-012 monitor cron · BCK-39-010 dashboard import · BCK-39-011 reboot test
```

## 6. Standing Rule

Unchanged from phase38-90 §6: new findings enter with fresh canonical IDs and a crosswalk row;
reports cite IDs but never mint private variants.
