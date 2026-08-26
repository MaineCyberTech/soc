# Phase 42 Usability Audit — USE-AUD-42-01

**Report ID:** phase42-93-usability-audit
**Phase:** 42
**Title:** Usability Audit — Canonical Truth Fresh Today (CS-42-01), Dashboard v2 Artifact Ready With Swap Pending Owner + Render Still Login-Gated, Monitor Observability Strong (Two Real Catches Visibly Logged), Ownership Clear Per Register; False-Health Watchlist REFRAMED: Watermark Advisory-Only Converts Prior Green-Cluster Risk Into Known-Limitation; Quick-Ref Cards Updated
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:45:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-93-usability-audit.md`

---

## 1. Current-state freshness

`canonical/current/current-state-20260826-p42.md` written TODAY (CS-42-01,
10:02Z) with every anchor evidence-tagged; open-work register rewritten same
hour; AGENTS.md canon pointer updated under CHG-42-AGENTS-01. An agent or
operator opening the repo cold lands on truth <1h old.

## 2. Dashboards

| Item | State |
|---|---|
| W2 v2 artifact | EXISTS: `ops/evidence/p42-dashboard-v2/w1-w2-windows-endpoints-v2.ndjson` + SHA256SUMS (`771be36e…2057d9`); `.keyword` field fix; imported with 4/4 panel parity in validation set; originals retained |
| Swap into global tenant | PENDING OWNER sign-off (+ browser session) — OW-42-03 |
| Visual render | LOGIN-GATED (data layer validated; pixels unverified until operator session) — OW-41-03 |
| Operator-facing meaning | Until swap, W2 panels querying `event.code` show empty states BY DESIGN of the broken mapping — documented in CS-42-01 §5 so nobody misreads silence as "no Windows data" |

## 3. Monitor observability

Strong. Both real fail-closed ERRORs are plainly visible in
`shuffle-delivery-monitor.log` (lines 31 and 71) with green SUMMARY resumption
adjacent — an operator skimming the log sees fault-and-recovery at a glance.
Watchdog sink exists and its emptiness is itself the healthy signal (documented).
Certification language (PASS-WITH-WINDOW-NOTE) tells the reader exactly when
full-window confidence arrives (08-27T01:45Z).

## 4. Ownership clarity

Every open row in OPENWORK-42-01 carries a named owner class; the go/no-go
matrix names gate holders individually (phase42-83 §2). The two red gates are
unambiguous about WHO must act (Platform+SOC lead for signature; Infra+SOC lead
for target). No orphan work found.

## 5. Mobile / accessibility

UNKNOWN — unchanged honest posture: both remain browser-session-gated items
(phase41-63/-64 lineage, phase42-70/-71 executed what API-accessible checks were
possible). Nothing new claimable this phase.

## 6. False-health watchlist — UPDATE (reframe)

Prior entry "green cluster while disk climbs" was a SUSPECTED false-health risk:
GREEN status might have been masking capacity danger. This phase's discovery
(`disk.threshold_enabled:false` cluster-wide, R-DISKBYPASS) RESOLVES the
ambiguity in the honest direction: the cluster genuinely will not self-protect,
so GREEN is now a **known-limitation**, not false-health. Watchlist entry changes
from "is green lying?" to "green is truthful but weak — capacity is manually
watched until OW-42-01 decides". Other watchlist rows (login-gated render,
qualitative FP stats, monitor window note) stand unchanged.

## 7. Quick-ref card updates

- Custody quick-facts now: v1.3.0 byte-exact AND v1.3.1 on-box `4e6c3712…`;
  publication = token-blocked only.
- Header health check: ONE XFO + ONE nosniff expected at :3443 (was "expect duplicate nosniff").
- Repair script behavior: healthy tick prints NO-OP; restart ONLY on real reconnect.
- Rejection bursts on legacy archives: EXPECTED until rollover; alarm only if seen on 08.27-born index.
- Adjudicator first run: export creds first ([REDACTED-PW] literal caveat).
