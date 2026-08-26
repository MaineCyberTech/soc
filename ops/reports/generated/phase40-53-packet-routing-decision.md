# Phase 40 Packet Routing Decision — ROUT-PKT-40-01

**Report ID:** phase40-53-packet-routing-decision
**Phase:** 40
**Title:** Decision ROUT-PKT-40-01 — Packet Lane Routing DEFERRED (Explicitly NOT Rejected): Candidate SIDs, Enumerated Unmet Preconditions, Limits Proposal, Kill Switch, Rollback, Client Impact, Phase-41 Review
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:43:00Z
**Classification:** INTERNAL
**Status:** DEFERRED
**Record ID:** ROUT-PKT-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Review date:** **Phase 41**
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-53-packet-routing-decision.md`
**Supersedes:** ROUT-39-02 (phase39-42) as the current decision record; candidate shortlist carried forward unchanged

---

## 1. Decision

> **DEFERRED.** The packet/Suricata lane remains UNENABLED for production routing.
> This is a deferral to complete the proof chain — not a rejection of the design,
> which is fully specified and frozen in an import-ready artifact. No packet event
> reaches any production client surface as of this record.

Context: the high-severity lane is production-proven via the webhook (E2E-007 chain
today: flow_id 999000777 → exec b6d07492 → IRIS row 42 @01:28:57Z; phase40-37/-40).
The packet lane shares the sensor (agent 016 `mct-packet-sensor`), analysisd,
integratord, and Wazuh→Shuffle transport path, but by design requires its own
ISOLATED workflow, webhook, dedup/counters, and proofs before any enablement —
shared plumbing success confers nothing on this lane.

## 2. Candidate SIDs (unchanged shortlist)

| Priority | SID | Basis |
|---|---|---|
| 1 | **2027967** | canary signature; E2E-proven in the P35 era; sole allowlist entry frozen in the artifact (`^(2027967)$`) |
| 2+ | ET Open curated set | curated population reference from ROUT-39-02 §2; expansion ONLY after FP review of SID-1 behavior at volume; one SID per review cycle |

No new SIDs are added this phase. Expansion candidates are re-affirmed from the ET
Open curated population at each review against live lane data.

## 3. Unmet Preconditions (enumerated — all REQUIRED before revisit)

| # | Precondition | Status |
|---|---|---|
| P1 | Import session executed (UI runbook per phase40-41 §7, or API path now shown viable by IMP-40-01 differential); amendments applied + register entry + post-import structural diff | NOT DONE |
| P2 | REPLAY-PKT-01 full matrix pass (E1–E8) | BLOCKED-RUNTIME |
| P3 | MAL-PKT-01 zero-side-effect pass incl. amended V4/V5 rejections | BLOCKED-RUNTIME |
| P4 | DSF-PKT-01 fail-closed pass (read/write/counter cases) | BLOCKED-RUNTIME |
| P5 | DNF-PKT-01 pass incl. ordering-limitation mitigation decision | BLOCKED-RUNTIME |
| P6 | VOL-PKT-01 24 h window with all thresholds T1–T7 met | BLOCKED-RUNTIME |
| P7 | FP review sign-off (sampled dispositions, change-register entry) | NOT DONE |
| P8 | Residue cleanup: stray probe workflow `p40-import-probe-minimal` deleted (R-IMP-40-A) | OPEN — operator |

## 4. Limits (proposed at enablement)

- Real-route cap **50 events/min** (workflow-enforced per PACKET-COUNTER-40-01 §4;
  sustained breach ⇒ auto-disable review).
- Fixed severity mapping (IRIS severity id 6), fixed internal test tenant
  (`customer_id=1`) during the entire test era.
- Notify-only destination until certification explicitly upgrades posture.
- Hourbucket dedup (TTL 3600 s proposal): worst-case re-alert cadence 1/hour/tuple.

## 5. Kill Switch (any one, immediate)

1. Remove/disable the integration group-filter entry feeding this lane in ossec.conf
   on BOTH cluster nodes (source-level stop; CFG block precedent, phase40-35 §8);
2. Shuffle UI workflow toggle OFF;
3. Delete/unbind the workflow webhook URL.
Independent layers; #2 is the default first move and requires no config change.

## 6. Rollback

Reverse of enablement order: K-switch → optional deletion of imported workflow
instance → register closure entry. The evidence artifact
(`packet-workflow-import.json`, sha256 `8242145e…37fc`) is immutable and unaffected;
no Wazuh-side configuration exists to undo until post-certification wiring occurs,
by construction. Counters/state die with the instance; nothing external persists.

## 7. Client Impact Assessment

Low volume expected: canary sid fires on dedicated interaction paths only; further
SIDs are gated by FP review plus rate cap. No client-visible SLA surface depends on
this lane in Phase 40. Worst-case failure mode while deferred = absence of packet
alerts (fail-silent by omission, mitigated by the separate proven high-severity
lane retaining coverage for matching events).

## 8. Review Plan (Phase 41)

Revisit upon P1–P8 completion or at scheduled review, whichever first: confirm
shortlist, consume VOL-PKT-01 scoreboard, decide enablement vs continued deferral
with operator sign-off recorded in the change register per AGENTS.md gates.

## Verdict

**ROUT-PKT-40-01: DEFERRED (not rejected).** Design frozen and import-ready;
proof chain fully enumerated with pre-committed protocols; enablement remains
gated on evidence, owner sign-off, and the kill-switch/rollback posture above.
Owner: MCT SOC.
