# Final Phase 40 Operator Report

**Report ID:** final-phase40-operator-report
**Phase:** 40
**Title:** Phase 40 Operator Closeout — Field Proof DONE, TLS DONE-Implemented, Webhook DONE-Proven, Agent015 Permission DONE; First Full-PASS Phase; Owner-Gated Items Correctly Held Open
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/current/final-phase40-operator-report-20260826-0300Z.md`

| Field | Value |
|-------|-------|
| **Report ID** | final-phase40-operator-report |
| **Generated** | 2026-08-26T03:00Z |
| **Classification** | Internal / Operational summary |
| **Owner** | MCT SOC |
| **Verdict** | **OVERALL PASS** (first full-PASS phase) |
| **Supersession** | Supersedes `final-phase39-operator-report-20260825-2359Z.md`; superseded only by a newer phase final. Historical reports are never rewritten in place. |
| **Companion reports** | phase40-91 (backlog) · 92 (billing) · 93 (scorecard) · 94 (monthly) · 95 (deployability) · 96 (release assurance) · 97 (repo/commit plan) |

---

## 1. Executive Verdict

**PASS — the first full-PASS phase of the engagement.** All four primary gates that entered the
phase as open work closed with live, same-day proof:

- **Field-fix VERIFIED (DONE):** the 08.26 archives index carries limit=2000 + ISM; the last
  rejection ever fired at **00:00:01.431Z** and every post-cutover window reads **ZERO** against a
  ~150/min baseline; 100k+ docs ingested cleanly (175,369 by 03:00Z). Guardrail script shipped —
  already WARN at 1604/2000 fields H+1.8h (growth running faster than budgeted; escalation trigger armed).
- **TLS CLOSED via IMPLEMENTATION (DONE):** nginx reverse proxy on :3443 (TLSv1.2/1.3 negotiated
  live, HSTS/XFO/nosniff); LAN plaintext REFUSED; loopback recovery preserved; cert SHA-256
  fingerprint pinned; renewal procedure documented.
- **Webhook WIRED+PROVEN end-to-end (DONE):** a three-defect discovery chain (invalid trigger →
  missing hooks-doc → DNS isolation master+worker; plus broken-in-build rule_id filter →
  group-suricata semantics) ended in full-chain canary E2E-007 with exact IDs at every hop:
  sensor flow 999000777 → wazuh alert 1787707735.1208554 → exec b6d07492 FINISHED src=webhook →
  IRIS HTTP 200 → alert 42 @01:28:57Z (~2 s). Config-of-record both nodes.
- **Agent015 permission defect FIXED (DONE):** root cause was root-owned shared-config files vs
  the wazuh-user remoted write need; minimal chown fix at 00:50Z; **83,736 lifetime errors ENDED**;
  durability proven across 5+ restarts.

Items still open are open **correctly**: agent013 recovery and the agent015 flap are owner-gated
(runbook ready, no access path), the ISM wave is calendar-gated (Aug-29), RTO/RPO is signature-gated
(DEC-40-01 sheet ready-to-sign), rehearsal is target-gated — none of these are failures of evidence.

Nothing regressed operationally: OS GREEN; fleet 7 active-class (000,006,007,011,012,014,016);
disk ~82–83%; snapshots fs 42 / s3 86 fresh tonight (5/day cadence corrected); dashboards imported
8/8; delivery monitor live at */15.

## 2. Corrections Table (claims retired this phase)

| # | Prior belief/trap | Status | Corrected understanding | Evidence |
|---|---|---|---|---|
| C-40-1 | Integrator rule_id filter assumed semantically functional | RETIRED | The filter is broken-in-build; lane semantics delivered via group-suricata matching instead. Hours were spent assuming documented behavior before reading daemon source | phase40-34/-36/-37 arc |
| C-40-2 | "The integrator" treated as one cluster-wide actor | CORRECTED | Architecture is PER-NODE integratord: master and worker each need their own config path/DNS reachability; config-of-record exists for both nodes | phase40-35/-40 |
| C-40-3 | Historical POST-401s read as platform blocking workflow creation | CORRECTED | Trailing-newline token artifact: `$(cat keyfile)` embeds whitespace into the Authorization header; POST actually works (probe created, then cleaned via datastore + cache restart). Codified as an AGENTS.md scripting hazard | phase40-41; AGENTS.md credential-handling note |
| C-40-4 | s3 snapshot cadence believed daily-of-record | CORRECTED | Cadence of record is 5/day; repo count 86 with s3-snap-20260826-0047 @00:48Z confirms | phase40-94 §6 |
| C-40-5 | 08.26 index believed correctly policy-attached at creation | CORRECTED | It attached `wazuh-retention` (30d) instead of `wazuh-archives-14d` — caught by diff vs baseline, fixed via remove→add; wave ETA 08-29T21:00:44Z unchanged | phase40-56/-60 (ISM-40-01) |

## 3. What Changed Operationally (timestamped, UTC)

1. **00:00:01.431Z** — LAST field-limit rejection ever; index `wazuh-archives-4.x-2026.08.26`
   created 00:00:02.420Z under template limit=2000+ISM; all subsequent windows zero.
2. **00:17Z / 00:48Z** — fs snap-20260826-0017 and s3-snap-20260826-0047 fired; second bounded
   restore this quarter executed against the fs snapshot (count parity 603=603, temp-isolated).
3. **~00:50Z** — merged.mg + agent.conf chowned wazuh:wazuh on mac-clients shared dir; the
   every-10-s permission error stream (83,736 lifetime) ended permanently.
4. **00:57–01:29Z** — webhook proof ladder climbed: hook probe exec f28cb7e2 → IRIS alert 40;
   manual fire 46b8fe3d post-DNS-fix → alert 41; full-chain canary E2E-007 (exec b6d07492,
   src=webhook) → alert 42 @01:28:57Z, ~2 s end-to-end.
5. **~01:44–02:43Z** — field guardrail live: WARN at 1604/2000 (H+1.8h), then 1706 with trend
   ~2448/day projected; escalation trigger armed (BCK-40-001).
6. **~02:00–02:15Z** — TLS proxy authorized/blocked tests re-affirmed (:3443 200-class through
   TLSv1.3; LAN plaintext :3001 refused exit-7); packet POST mystery closed (newline artifact),
   probe residue cleaned during session.
7. **Pre-03:00Z** — dashboards imported 8/8 into global tenant (private-authz fail diagnosed en
   route); monitor cron */15 active with hardened script; SecurityOnion stopped (~18 MiB freed,
   volumes preserved); duplicates alias-consolidated (2 groups); AGENTS.md refreshed through
   backup→dry-run→apply→ledger chain (CHG-40-AGENTS-01).
8. **03:13–03:14Z** — triple CI re-run all GREEN over the landed closeout corpus.

## 4. Risks Register — Top 5

| Rank | Risk | Exposure | Mitigation trajectory |
|------|------|----------|----------------------|
| R1 | **Field-growth WARN velocity** — guardrail hit soft threshold in <2 h; trend projects ~2448/day vs budget | Hard CRIT (1800) could arrive within days if unplateaued; a second saturation era would resurrect rejection noise | Daily guardrail reads armed; containment design pre-staged (sensor-side EVE filtering / compact-stats forwarding), approval-gated (BCK-40-001) |
| R2 | **Owner-batch latency** — 013 power, 015 caffeinate, DEC-40-01 signature, rehearsal-target naming all wait on one human session | Fleet stuck 7/10; objectives stay draft; rehearsal stays NO-GO | Batch explicitly packaged as ONE session in backlog §owner-batch to minimize dispatch count |
| R3 | Self-signed TOFU posture on :3443 | Client-side MITM window until fingerprint verified out-of-band | Fingerprint pinned in release record; renewal procedure documented; disclosed in billing |
| R4 | Hooks endpoint unauthenticated within trusted LAN | Any LAN host can post to the webhook URL | Internal-only exposure; Wazuh-side integrator is sanctioned producer; accepted-risk disclosed (billing §4) |
| R5 | Packet-lane opportunity cost — import deferred BY CHOICE while path is proven OPEN | Detection coverage excludes packet-workflow routing; disclosure persists on billing line | One-session runbook retained (IMP-40-01); scheduled P41 item (BCK-40-006) |

## 5. Domain One-Liners

- **Deployability (DEPLOY-40-05):** PARTIAL maintained honestly — B1 external target ABSENT(owner),
  B2 objectives AWAITING-OWNER (sheet ready), B3 rehearsal never-run, B4 published custody PARTIAL;
  credited this cycle: two bounded restores, plan v2 with seven deltas folded, versioned
  security baselines.
- **Billing (BILL-40-03):** RECOMMENDED for Aug-2026 with disclosures — capture VERIFIED,
  detection VERIFIED, Class-A routing CERTIFIED-AUTOMATED (upgraded from conditional-manual);
  strongest same-day evidence base to date.
- **Scorecard (SCORE-40-04):** Ops GREEN · Detection GREEN+ · Security GREEN (AMBER-lite TOFU cell)
  · Governance GREEN · Visibility GREEN-pending-visual · DR AMBER; client-safe section published
  sanitized and shareable.

## 6. Phase 41 Roadmap (prioritized)

**P0 — morning of Aug-26**
1. Owner batch, ONE session: power on agent 013 · caffeinate/power-settings on agent 015 ·
   sign DEC-40-01 · name/approve the rehearsal target.
2. Watch the first full day of delivery-monitor cron runs (*/15 cadence, flock-hardened).
3. Field-growth daily check — first guardrail read of the morning; escalate per BCK-40-001 if ≥1800.

**P0 — dated**
4. **Aug-29:** observe the first policy-driven ISM deletion wave (ETA 21:00:44Z; checkpoint Aug-30).

**P1**
5. Packet-import session — the path is OPEN; schedule it and close the last lane gap.
6. XFO dedup + windows-clients `.bak` ownership sweep (minutes-level quick-wins).
7. Published-asset retrieval attempt (needs gh/network path).
8. v1.3.1 cut decision against the tabled D-1…D-8 manifest (after the Phase-40 commit lands).

**P2**
9. Rehearsal staging on the named target once B1/B2 clear (RESTORE-PLAN-40-02 ready).
10. FP sampling start (false-positive baseline on the curated ruleset).
11. Mobile/accessibility pass on dashboards ahead of client-facing use.

## 7. Attestation

No secrets appear in this report or its companions; credentials are referenced exclusively by file
location. All quantitative statements trace to command outputs captured in same-day phase reports
(live API counts, snapshot listings, execution/IRIS IDs, guardrail log lines, triple-CI runs
embedded in phase40-96 §6); carried-forward proofs are labeled as such. Commit/push remains
APPROVAL-GATED per phase40-97: tree holds 8 modified + expected-untracked classes enumerated,
redaction sweep counts ZERO, single logical commit message provided verbatim therein awaiting
orchestrator execution.

*— End of Phase 40.*
