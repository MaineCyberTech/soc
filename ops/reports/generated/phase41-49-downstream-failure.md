# Phase 41 Downstream-Failure Detection — Evidence From History

**Report ID:** phase41-49-downstream-failure
**Phase:** 41
**Title:** DSF-EV-41-01 — Detection Capability PROVEN From Class-A History: 31 FINISHED-With-Failed-Downstream Executions Held Out Of delivered For Months Via Result-Status Parsing; Packet-Lane Equivalent Pending First Real Failure
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:51:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (evidence-based; packet-lane live-fire pending)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-49-downstream-failure.md`

---

## 1. The claim under test

When IRIS (or any downstream) fails but Shuffle marks the execution FINISHED,
does the accounting catch it? On this stack the answer has been demonstrated by
history, not manufactured.

## 2. Historical evidence [VERIFIED via lifetime counters]

The Class-A lane's DNS-failure era left **31 executions** in exactly that shape:
terminal status FINISHED while the IRIS action carried connection/HTTP failures.
The P40-hardened monitor's parser (`success": false` / exception-class scan over
stored results) has classified all 31 as FAILED in every cycle since — they
appear in `failed=31`, never in `delivered`, across months of runs including all
14 overnight cycles and today's fresh re-run.

That is months-long continuous operation of the exact detection path this proof
targets, on real failures nobody had to fabricate.

## 3. Packet-lane equivalent — pending, honestly

The packet lane has recorded zero downstream failures since rebuild (all 12
clean runs delivered IRIS 200; the 6 ABORTEDs were upstream node failures, not
downstream ones). No packet-lane failed-downstream event exists yet to observe.
Injection was considered and declined for the same contamination reasons as
phase41-38; when the first real one occurs, the monitor will classify it by the
same parser, and this report's successor can cite it.

## 4. Bridge to phase41-51

This record establishes detection capability; the merged failure-mode catalog
(phase41-51) places it among all failure modes with their individual proof
states so nothing gets lost between reports.
