# Phase 42 AGENTS.md Audit — AGT-AUD-42-01

**Report ID:** phase42-85-agents-phase42-audit
**Phase:** 42
**Title:** AGENTS.md vs Phase-42 Audit — Canon Pointer Stale (postp41 → p42), Packet Blocker Text Pre-Dates DEFINITIVE-Negative Research, Zero Phase-42 References; Three Durable Candidates Adjudicated (HTTP-app Interpolator Extension = APPLY, Disk-Threshold Pointer = APPLY, Sensor-Mask Reminder = STANDS/No-Change); Commands and Paths Validated
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:08:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-85-agents-phase42-audit.md`

---

## 1. Method

Line-level read of root `AGENTS.md` (163 lines, sha256 `7401ac9b836d9137…123ab`
at audit time) against every Phase-42 anchor; live greps for reference currency;
path/command validation via test -e and one CI run.

## 2. Stale-entry findings

| # | Finding | Evidence | Disposition |
|---|---|---|---|
| A1 | Canonical Truth bullet points to `current-state-20260826-postp41.md`; CS-42-01 (`current-state-20260826-p42.md`) now supersedes it | grep 'postp41' = 1 hit | FIX in CHG-42-AGENTS-01 |
| A2 | Packet blocker cites ROUT-PKT-41 + platform defect only; P42 added the T1–T5 DEFINITIVE-negative capability verdict and B>A>C remediation order | grep 'phase42' count = **0** | FIX |
| A3 | Resolved list ends at v1.3.0 custody; P42 closures (churn, nosniff, VT-container, v1.3.1 custody, EID root-cause) absent | §Known Blockers tail | FIX |
| A4 | Field-containment line lacks the staged-adjudicator fact (flip mechanism now a concrete script + window) | same paragraph | FIX (one clause) |

## 3. Durable candidates adjudicated

| Candidate | Verdict | Rationale |
|---|---|---|
| (a) Shuffle Tools refs-literal note (added P41) — extend with HTTP-app-is-only-interpolator | **APPLY** (extend existing bullet, not a new one) | The existing execute_python scripting note is the correct home; T5 control-positive (phase42-15: HTTP app DOES interpolate `${body:*}`, Class-A delivery HTTP 200 ×2; exec `1fac8e6f`) is durable platform knowledge that changes how any future workflow is built |
| (b) Indexer disk-thresholds disabled | **APPLY** as pointer-style config-truth note | Durable until an owner decision flips it; belongs as one line referencing the config path + risk ID, never volatile values (AGENTS.md holds no metrics rule respected: no percentages, paths only) |
| (c) Sensor unit masked reminder | **STANDS — no change** | Already present verbatim ("systemd unit state may NOT reflect what production runs…"); re-verifying it this session via ssh (masked; single ens19 process count=1) confirms continued accuracy; duplication would violate minimalism |

## 4. Command/path validation

```
$ test -e ops/scripts/p39-agents-ci.sh && echo ok        → ok
$ bash ops/scripts/p39-agents-ci.sh                       → RESULT: PASS (0 warnings)
$ grep -c "phase42" AGENTS.md                             → 0   (confirms A2 scope)
$ grep -c "postp41" AGENTS.md                             → 1   (A1 target)
$ wc -l < AGENTS.md                                       → 163 (≤200 cap, headroom for diff)
$ grep -rn "wazuh1.indexer.yml" AGENTS.md                 → 0   (b target absent today)
```

All paths referenced by the planned diff exist: `ops/reports/generated/phase42-48…80`,
`multi-node/config/wazuh_indexer/wazuh1.indexer.yml`, `canonical/current/current-state-20260826-p42.md`.

## 5. Handoff

Findings A1–A4 + candidates (a)/(b) feed the minimal diff executed under
**CHG-42-AGENTS-01** with full compliance chain in phase42-86.
