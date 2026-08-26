# Phase 42 Full Drift Audit — DRIFT-42-01

**Report ID:** phase42-95-full-drift
**Phase:** 42
**Title:** D-42-x Dispositions — Catalogs Lag FIXED (Append) With P41-Row Absence Disclosed (D-42-CATL), AGENTS Staleness FIXED (CHG-42-AGENTS-01), Disk-Thresholds-Disabled vs Governance Presumption = D-R-DISKBYPASS MAJOR FOUND+DISCLOSED, event.code Panels FIXED-v2-Pending-Swap, Rejection Resumption RECONCILED as Bounded Legacy-Window, Worker Backup Gap CARRIED, Sensor Mask Rationale DOCUMENTED, New Discoveries Logged — Verdict MANAGED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-95-full-drift.md`

---

## 1. Disposition table

| ID | Drift item | Disposition | Evidence |
|---|---|---|---|
| D-42-CAT | Catalogs lag corpus | **FIXED for P42** — 99/99 phase42 rows appended to both catalog copies with real sha256s; NEW sub-item: generated copy holds ZERO phase41 rows despite phase41-84 claiming appends → split as D-42-CATL, owner decision, append-only repair available | phase42-87 §4; pre/post counts live |
| D-42-AGT | AGENTS.md staleness vs P42 | **FIXED** — CHG-42-AGENTS-01 applied with full chain (canon pointer, closures, packet blocker, two notes); CI green after | phase42-85/-86 |
| **D-R-DISKBYPASS** | Governance text presumes watermark protection ("MUST NOT weaken…disk watermarks") while indexer AND shuffle-store configs run `threshold_enabled:false` | **MAJOR DRIFT — FOUND + DISCLOSED**: docs-vs-reality gap now first-class risk R-DISKBYPASS + owner decision OW-42-01; exact file/line evidence banked (wazuh1.indexer.yml:44; compose line 100; `_nodes` ×3) | phase42-89 §6 |
| D-42-EID | Dashboard panels (event.code) vs indexed reality | **FIXED-v2-pending-swap** — root cause proven (event.code never populated; signal is eventID keyword); v2 artifact staged 4/4 parity; swap owner-gated OW-42-03 | phase42-69; CS-42-01 §5 |
| D-42-REJ | Prior "zero rejections trailing-24h" flatline claims vs today's resumption | **RECONCILED** — flatline was true when claimed; bursts resumed against the immutable LEGACY window (08.26 mapping) in two bounded bursts (07:02/07:45Z, zero since), ending at rollover; narrative updated everywhere to bounded interim risk R-FIELD-LEGACY; adjudicator C4 verifies true flatline on 08.27 | phase42-91 §2 |
| D-42-WBK | Worker ossec.conf historical no-backup gap | **CARRIED** — paired-backup rule binding forward; no new worker config change occurred this phase to trigger it | R-BAK-HIST carry |
| D-42-SNS | Sensor unit masked while production runs | **RATIONALE DOCUMENTED** (stands) — mask is deliberate dual-process fix; stale failed-state labeled pre-mask record; AGENTS note + fresh ssh evidence aligned | phase42-89 §4 |

## 2. New discoveries this audit cycle

| # | Discovery | Severity | Where logged |
|---|---|---|---|
| N1 | Threshold-disabled posture exists on Shuffle's OpenSearch too (compose line 100), widening D-R-DISKBYPASS beyond the indexer finding | MEDIUM | phase42-89 §6 |
| N2 | Generated-catalog P41-row absence contradicts phase41-84's append claim (working tree shows none) | MEDIUM (governance debt) | D-42-CATL above |
| N3 | p42 adjudicator `[REDACTED-PW]` literal blocks unattended auth | MEDIUM (window-blocking) | phase42-88 §6a |
| N4 | netdata :19999 wildcard listener joins LAN-exposure watchlist | LOW | phase42-90 §2 |
| N5 | Alert-volume spike hour 07:00 (~2× baseline) coincident with burst window, clean recovery | INFO | phase42-92 §3 |

## 3. Verdict

**MANAGED.** Every drift item found this phase carries a disposition: fixed,
fixed-pending-owner-swap, reconciled-with-bounded-window, carried-with-rule, or
disclosed-as-major-risk-with-decision-tracked. Nothing discovered was left
unlogged; nothing material was silently absorbed. The single major disclosure
(D-R-DISKBYPASS) is intentionally loud: top-tier risk row, dedicated OW row,
infra-audit evidence section, and security-audit rank 1 all point at the same
owner decision.
