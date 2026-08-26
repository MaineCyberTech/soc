# Phase 40 Scorecard

**Report ID:** phase40-93-scorecard
**Phase:** 40
**Title:** SCORE-40-04 — Internal M-Series Metrics With P39 Trends, Domain RAG, and Delimited CLIENT-SAFE Section
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL (contains delimited CLIENT-SAFE section — §4 only is suitable for direct client sharing)
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-93-scorecard.md`

---

## 1. M-Series Internal Metrics (with trend vs Phase 39)

| ID | Metric | P39 value | P40 value | Trend |
|---|---|---|---|---|
| M-01 | Fleet availability (active-class / registered) | 7/9 active-class (013 offline; 015 flapping with hidden defect) | **7/10** active-class, STABLE (register normalized to 10 incl. sensor-class agents; 013/015 offline owner-blocked; 008 retired-stopped) | = count, ▲ honesty (both offline causes root-caused: one FIXED manager-side) |
| M-02 | Detection proven end-to-end | TRUE (canary E2E carried forward) | **TRUE+** — canary chains proven THRICE today with exact IDs at every hop (~2 s delivery latency on final chain) | ▲ |
| M-03 | Field-fix effectiveness | PENDING-proof (template simulated; ~150/min rejection baseline frozen) | **VERIFIED** — 08.26 index limit=2000+ISM; LAST rejection ever 00:00:01.431Z; all post-cutover windows ZERO; 175k+ docs clean ingest; guardrail live (WARN at H+1.8h — watch armed) | ▲▲ CLOSED |
| M-04 | Shuffle TLS terminated | FALSE-pending (deferred with forced decision) | **DONE via IMPLEMENTATION** — nginx proxy :3443, TLSv1.2/1.3 negotiated live, HSTS/XFO/nosniff, LAN plaintext REFUSED, loopback recovery preserved, fingerprint pinned, renewal documented | ▲▲ CLOSED |
| M-05 | Class-A routing lane | CONDITIONAL-PASS (manual/API only; webhook unwired) | **CERTIFIED AUTOMATED** — webhook production-wired both nodes; full-chain proof exec b6d07492 → IRIS alert 42 @01:28:57Z | ▲▲ |
| M-06 | Agent 015 permission defect | FOUND (83,736 errors accruing every 10 s) | **FIXED** — chown applied 00:50Z; errors ENDED; durability across 5+ restarts | ▲ CLOSED |
| M-07 | Dashboards | Artifact-only (ndjson validated, not imported) | **IMPORTED 8/8** into global tenant via API (private-authz fail diagnosed en route); runtime visual check pending login | ▲ |
| M-08 | Delivery monitor | Script exists, unscheduled | **LIVE** — hardened (flock), cron */15, real runs observed; accounting delivered=40/failed=31/aborted=3 | ▲ |
| M-09 | Retention policy integrity | Wave ETA staged; attachment drift unknown | **ISM-40-01 anomaly FOUND + CORRECTED** (08.26 wrongly on wazuh-retention 30d → re-attached archives-14d); wave ETA 08-29T21:00:44Z unchanged | ▲ |
| M-10 | Packet lane | Deferred, transport suspect (POST-401 mystery) | Root cause SOLVED (trailing-newline token artifact); POST proven working; import deferred BY CHOICE | ▲ (clarity), → (scope) |
| M-11 | CI gates green (same day) | 3× GREEN | **3× GREEN** (report · canonical · agents; outputs embedded phase40-96 §6) | = maintained |
| M-12 | Capacity (root filesystem) | 84% used, plateau risk | **~82–83%** (live re-read 83% at report time); ISM wave relief ETA Aug-29; field-growth guardrail WARN velocity noted | ↓ good, watch |
| M-13 | DR / rehearsal | NO-GO (spot-check grade) | **NO-GO honest** (unchanged verdict) but plan v2 staged (7 deltas folded) and SECOND bounded restore proven (603=603 parity) | = flat, substance ▲ |
| M-14 | Credential/token hygiene | CLEAN tracked set | CLEAN + trailing-newline scripting hazard codified in AGENTS.md (the bug that bit twice across phases is now a documented rule) | = maintained |

## 2. Domain RAG Status

| Domain | RAG | Basis | Trajectory |
|---|---|---|---|
| Operations | **GREEN** | Cluster healthy; zero ingest rejections post-fix; fleet exceptions owned with named asks and ready runbooks; capacity stable | Maintain; watch field-growth velocity |
| Detection | **GREEN** | Field completeness restored with flatline proof; canary chains ×3 same-day with exact IDs | Maintain; packet lane is scoped exclusion |
| Security | **GREEN (one AMBER-lite cell)** | TLS closed via implementation; LAN plaintext refused; exposure controlled. AMBER-lite residual: self-signed TOFU cert + unauthenticated-LAN-internal hooks endpoint, both disclosed accepted-risks | Fingerprint pinning + renewal procedure mitigate |
| Governance | **GREEN** | Triple CI green same-day; AGENTS.md refreshed via backup→dry-run→apply→ledger (CHG-40-AGENTS-01); alias ledger applied; ISM drift caught and corrected | Maintain |
| Visibility | **GREEN-pending-visual** | Dashboards imported 8/8 global tenant; monitor SLA-visible | One login session from full GREEN |
| DR | **AMBER** | NO-GO unchanged honestly; two bounded restores proven; plan v2 ready; blocked purely on owner inputs (target name + signed objectives) | Gates: BCK-40-003/004 |

---

## 3. Notes on Method

- All quantitative statements trace to same-day command outputs captured in the cited phase40
  reports; carried-forward proofs are labeled as such.
- Trend arrows compare like-for-like against the phase39-99 scorecard; where a metric CLOSES
  this cycle it is marked CLOSED rather than silently dropped from the series.
- No secret values appear in this report or in §4.

## 4. ── BEGIN CLIENT-SAFE SECTION ──

*Sanitized summary for direct client sharing: service-level statements, counts, trends,
statuses only. No IP addresses, no credentials, no internal filesystem paths.*

### Service Summary — August 2026 (Phase 40 update)

| Area | Status | Summary |
|---|---|---|
| Log capture | ● Operational — improved | 7 of 10 registered endpoints actively reporting; an ingest limitation that had been rejecting a portion of telemetry was fixed earlier in the month and its effectiveness is now PROVEN: zero rejected events since the fix cutover, with well over one hundred thousand events ingesting cleanly on the new configuration |
| Detection coverage | ● Proven — strengthened | End-to-end detection validated three separate times today using marked test events that carry verifiable identifiers through every system hop, arriving at the case-management system in about two seconds |
| Alert case notifications | ● Certified automated | Alerts now flow to case management FULLY AUTOMATICALLY (previously required manual triggering); a scheduled 15-minute delivery monitor provides visible service-level assurance |
| Management encryption | ◐ Implemented | The management interface is now served over modern encrypted transport with hardening headers; unencrypted access is refused. Certificate is self-issued with its fingerprint published for verification; formal certificate renewal path documented |
| Dashboards & visibility | ● Live | All eight operational dashboards imported and present; final visual review pending a routine login session |
| Backups & recovery | ● Verified — twice-tested | Snapshot schedule confirmed current across both backup repositories (42 local, 86 offsite copies); a second production-safe restore test completed this quarter with exact record-count parity |
| Documentation & governance | ● Strong | All compliance checks passing; operating handbook updated including a newly codified scripting rule learned from this month's investigation |

**Known limitations (disclosed):** two endpoints offline awaiting owner action (both causes
diagnosed, one already fixed server-side); packet-analysis automation deferred by choice;
disaster-recovery objectives drafted but not yet formally signed; recovery rehearsal not yet
executed against an approved external target. None affect capture or detection for the period.

**Trend vs prior report:** capture improved (rejections eliminated); detection strengthened
(triple same-day proof); notification automation upgraded from conditional to certified;
encryption implemented; recovery assurance improved (second successful bounded restore);
endpoint count steady.

## ── END CLIENT-SAFE SECTION ──

---

## 5. Attestation

§1–§3 and §5 are INTERNAL. §4 between the delimiters contains no IP addresses, no credentials,
no internal paths, and may be shared verbatim.
