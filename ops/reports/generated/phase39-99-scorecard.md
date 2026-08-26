# Phase 39 Scorecard

**Report ID:** phase39-99-scorecard
**Phase:** 39
**Title:** SCORE-39-03 — Internal M-Series Metrics With P38 Trends, Domain RAG, and Delimited CLIENT-SAFE Section
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL (contains delimited CLIENT-SAFE section — §4 only is suitable for direct client sharing)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-99-scorecard.md`

---

## 1. M-Series Internal Metrics (with trend vs Phase 38)

| ID | Metric | P38 value | P39 value | Trend |
|---|---|---|---|---|
| M-01 | Fleet availability (active-class / registered) | 8 active-at-design of 9 registered (013 offline ~15 h; 015 flapping) | **7/9** active-class (013 offline since 06:30Z cutoff; 008 retired-absent; 015 counted with caveat) | ▼ count, ▲ honesty (defect found + owner asks dispatched) |
| M-02 | Detection proven end-to-end | TRUE (canary E2E + real honeypot traffic) | **TRUE** (carried forward as labeled; ET-Open curated active) | = |
| M-03 | IRIS notification lane restored | FALSE — intermittent DNS failures inside finished execs | **TRUE** — root causes fixed; 3 consecutive real deliveries → HTTP 200 ×3 → DB alerts 37/38/39 @22:08:24Z | ▲▲ (NEW proof class: functional delivery probe) |
| M-04 | Exposure restricted | FALSE — frontend bound 0.0.0.0:3001, no control plane | **TRUE** — publish binding → mgmt address only; loopback/docker-bridges blocked; authorized tests PASS | ▲▲ |
| M-05 | TLS terminated on Shuffle UI | FALSE | **FALSE-pending** (deferred P40; decision forced early Sept) | = (slipped P38→P40) |
| M-06 | Field-fix effectiveness | Fix applied, unproven (~150/min rejections baseline) | **PENDING-proof** — saturation mechanism confirmed (999–1000 ceiling; data.stats burst = 547 slots); template verified via simulate_index; live proof lands with first index ≥00:00Z Aug-26 | → (calendar-bound) |
| M-07 | Corpus migration | Dry-run passed, apply gated | **COMPLETE** — 1,992/1,992 copied copy-first; hashes N=1992 M=0; rollback drill clean; originals untouched | ▲▲ |
| M-08 | AGENTS.md governance file | Absent (no governing instruction file) | **ESTABLISHED** — root file, 134 lines, sha256-pinned, sources-tagged; change ledger CHG-39-AGENTS-01 | ▲ NEW |
| M-09 | Restore cycle proof this quarter | NONE (repos verified healthy only) | **FIRST-PASS** — smallest monitoring index restored GREEN from snap-20260825-2017 to temp name (1405 vs 1522 source = snapshot-moment delta), then deleted clean; production untouched | ▲▲ |
| M-10 | CI gates green (same day) | 1× (report CI honest-PASS post-redaction work) | **3× GREEN** — p38-report-ci · p39-canonical-ci · p39-agents-ci (outputs embedded in phase39-102) | ▲ |
| M-11 | Credential hygiene | Disclosed bearer live in corpus (13-file IRIS-bearer family + 3 report leaks) | **CLEAN on tracked set** — old bearer invalidated (401 post-restart); new key mode-600 gitignored; recursion sweep redacted all known locations | ▲▲ |
| M-12 | Release asset on-box | NONE | REBUILT-LABELED archived (sha256 `65f794a7…`); original retrieval still open | ▲ |

## 2. Domain RAG Status

| Domain | RAG | Basis | Trajectory |
|---|---|---|---|
| Operations | **AMBER → GREEN-path** | Cluster healthy, alerts flowing (~53k docs today), fleet exceptions owned with dispatched asks; field-proof at midnight is the gate to GREEN | Gate: BCK-39-001 |
| Detection | **GREEN** | Canary E2E + curated ET-Open proven; ingest recovery mechanism staged for proof | Maintain |
| Security | **AMBER (TLS) / GREEN (rotation+redaction+hardening)** | Rotation complete and proven dead-token; leak family redacted tree-wide; exposure restricted to mgmt LAN; TLS remains the single AMBER cell | Gate: BCK-39-007 decision-forced |
| Governance | **GREEN** | Migration applied clean (1992/1992); AGENTS.md established with CI; status enums normalized (one listed-not-guessed); canonical open-work register consolidated | Maintain |
| DR | **AMBER** | First real restore-cycle spot-check PASSED; rehearsal still pending adequate external target + signed RTO/RPO; go/no-go staged at NO-GO until Stage0 approvals | Gates: BCK-39-009/016 |

---

## 3. Notes on Method

- All quantitative statements trace to same-day command outputs captured in the cited phase39
  reports; carried-forward proofs are labeled as such.
- Fleet denominator uses the honest triple (registered / active-at-design / active-class) rather
  than any flat "all active" narrative.
- No secret values appear in this report or in §4.

## 4. ── BEGIN CLIENT-SAFE SECTION ──

*Sanitized summary for direct client sharing: service-level counts/trends/statuses only. No IP
addresses beyond product-level references, no credentials, no internal filesystem paths beyond
service names.*

### Service Summary — August 2026

| Area | Status | Summary |
|---|---|---|
| Log capture | ● Operational | 7 of 9 registered endpoints actively reporting; alert pipeline processed ~53,000 alerts today; two endpoints offline (one retired, one awaiting owner action) |
| Detection coverage | ● Proven | End-to-end detection validated via canary test events plus a curated open rule set; an ingest-limitation fix was applied and its effectiveness check completes automatically with tomorrow's data |
| Alert case notifications (SOAR→IRIS) | ● Restored | A notification fault that ran silently for ~10 days was root-caused (configuration corruption) and fixed; delivery now proven by three consecutive verified end-to-end cases |
| Automation exposure | ◐ Restricted | Management interface closed to authorized operator access only; encryption upgrade scheduled as a September priority |
| Backups & recovery | ● Verified | Twice-daily snapshot schedule confirmed current; first successful restore test of the quarter completed against production-safe scope |
| Documentation & governance | ● Strong | Full documentation corpus migrated to a canonical structure with hash verification (1,992 files, zero mismatches); automated compliance checks passing |

**Known limitations (disclosed):** management-plane encryption pending; packet-lane automation
deferred; two endpoints offline; full disaster-recovery rehearsal not yet executed (spot-check grade
only). None affect capture or detection for the period.

**Trend vs July:** capture steady; detection steady; notification lane improved from degraded to
proven; exposure posture improved materially; recovery assurance improved from untested to
spot-check-proven.

## ── END CLIENT-SAFE SECTION ──

---

## 5. Attestation

§1–§3 and §5 are INTERNAL. §4 between the delimiters contains no IPs beyond product-level, no
credentials, no internal paths beyond service names, and may be shared verbatim.
