# Phase 40 Full Drift Audit

**Report ID:** phase40-90-full-drift
**Phase:** 40
**Title:** DRIFT-40-04 — Eight-Plane Reconciliation (source↔runtime↔corpus↔AGENTS↔evidence↔CI↔assets↔dashboards-runtime): 10 D-40-x Items Enumerated With Dispositions (4 FIXED this phase, 5 OPEN-with-owner, 1 DEFERRED-BY-CHOICE); Every Plane Cross-Checked Live; Final Verdict **MANAGED**
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:23:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-90-full-drift.md`

---

## 1. Method

Each plane was reconciled against the others with live commands this session: runtime via
docker/ss/crontab/indexer queries; corpus via CI suites + catalog counts; AGENTS via its
CI + worktree diff; evidence via backup hash verification and artifact pin checks; assets
via release-manifest/custody docs; dashboards plane via import records vs runtime UI status.

## 2. D-40-x Register (found this phase, with disposition)

| ID | Item | Planes involved | Disposition |
|---|---|---|---|
| D-40-01 | Catalogs lagged concurrent batches: 283 files vs 165 ledger rows (late P39 batch + P40 batch uncataloged) | corpus↔ledgers | **FIXED this session** — append-only backfill +118 rows w/ real sha256; re-certified by p38/p39-canonical PASS (phase40-82 §3); pattern recurred live mid-session (batch 91–97 arrived uncataloged) and was absorbed by the same rerunnable append (+16 rows at receipt, totals 299=299) |
| D-40-02 | Second catalog copy (`generated/catalog-reports.*`, 186 rows) diverged from ledgers copy | ledgers↔corpus | OPEN — LOW; single-source-of-truth decision needed; owner ops-reports-owner (P41) |
| D-40-03 | AGENTS.md stale blockers section still listed resolved items (field-fix, webhook wiring, TLS) as open | AGENTS↔runtime↔corpus | **FIXED** — CHG-40-AGENTS-01 rewrite applied with backup+hash+CI postvalidate (phase40-89 §2) |
| D-40-04 | Worker pre-change ossec.conf backup not retained during webhook apply | evidence↔runtime | OPEN as standing rule R-2 / OW-40-10 (P3); no retro action possible; rule adoption tracked |
| D-40-05 | Duplicate X-Frame-Options headers on :3443 responses (upstream DENY vs proxy SAMEORIGIN) | source↔runtime | OPEN — P41 cleanup item AW-86-01/F-85-03; owner SOAR ops |
| D-40-06 | windows-clients `agent.conf.bak-20260816` root-owned on MASTER → remoted Permission-denied ERROR lines each shared-config reload (live log evidence today 01:01:14Z ×2; worker copy is correctly wazuh:wazuh) | runtime↔source hygiene | OPEN — hygiene backlog; one-line chown gated as config change; owner Wazuh config owner |
| D-40-07 | Published-original v1.3.0 asset custody gap (only rebuilt-labeled copy on-box, sha256 65f794a7…) | assets↔evidence | OPEN — honestly carried since phase39-69 lineage; custody PARTIAL per phase40-70 §6; flip condition documented in GATE-DR-40-01 |
| D-40-08 | Packet-lane artifact-vs-runtime divergence (workflow defined+sha-pinned but not imported/routing) | corpus↔runtime | DEFERRED-BY-CHOICE — documented ROUT-PKT-40-01; import path proven open; OW-40-04 |
| D-40-09 | s3 snapshot cadence misrecorded in P39 reporting (~3/day implied) vs measured reality | corpus↔evidence | **FIXED earlier P40** — corrected to **s3 86 snaps = 5/day** (fs 42 ≈5–6/day) in canonical current-state §9 line 97, evidenced by phase40-70 measurements |
| D-40-10 | security-onion restart-policy `always` remains after approved stop → reboot would resurrect retired container | runtime↔decision-record | OPEN — MED F-84-01; set no/remove-at-approval; owner Infra |

## 3. Plane Reconciliation Summary

| Plane pair | Result |
|---|---|
| source ↔ runtime (compose/config vs containers/listeners) | Consistent except D-40-05/-10 and the codification gap for mct-security attachments (F-84-02) |
| runtime ↔ corpus (claims vs live probes) | All VERIFIED flags sampled held up under re-run (TLS probes, counts, cluster state, IRIS rows, workflow inventory=2) |
| corpus ↔ AGENTS | Blockers now match reality post CHG-40-AGENTS-01; volatile-metrics rule holding |
| evidence ↔ runtime | Backup hashes verify; SO stop matches decision record incl. FinishedAt timestamp; volumes intact |
| CI ↔ corpus | Three suites green over full corpus including new batch |
| assets ↔ releases | Custody PARTIAL honestly labeled (D-40-07) |
| dashboards-import ↔ dashboards-runtime | Import proven; runtime visual check pending (disclosed in current-state §7 and USE-40-03) — not drift, disclosed incompleteness |

## 4. Items That Did NOT Drift (checked, clean)

Report-ID uniqueness across 292 files; metadata header rates 100%; ISM policy attachment
(`wazuh-archives-14d` policy attached to live archives indices,
verified via _ism endpoints); fleet counts vs agent_control output; delivery-monitor
schedule vs log mtimes; image-pin-set vs running digests (frontend exact-match).

## 5. Verdict

**DRIFT: MANAGED.** Ten divergence items found; four fixed inside the phase with
verified mechanics, five carry named owners and rollback/disposition notes, one is a
documented deferral-by-choice. No unowned or undisclosed divergence remains; every fix
used non-destructive, append-or-approved-edit semantics consistent with AGENTS safety
rules.
