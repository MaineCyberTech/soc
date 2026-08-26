# Phase 40 Field-Proof Readiness

**Report ID:** phase40-03-field-proof-readiness
**Phase:** 40
**Title:** Phase 40 Field-Proof Readiness — Checklist Verified Before Adjudicating the Midnight Roll
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:53:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-03-field-proof-readiness.md`

---

## 1. Purpose

Confirms, before any PASS/FAIL is issued downstream, that the proof apparatus defined
in Phase 39 (phase39-22 checklist C1–C6, phase39-24 frozen baselines, phase39-28 flip
gates) was actually in place and usable at arc start. Readiness failures found here are
logged as gaps, not silently patched.

## 2. Readiness Checklist

| # | Item | Expected | Found | Verdict |
|---|---|---|---|---|
| R1 | Ready-script availability | `ops/jobs/fieldlimit-proof-capture.sh` per phase39-28 §5 | **NOT materialized** — `/opt/mct-security-stack/ops/jobs/` does not exist; phase39-22 carried the capture procedure INLINE (checklist table) only | GAP-40-A (closed this arc by `ops/scripts/p40-field-growth-check.sh` for growth duty; full capture remains manual) |
| R2 | Credential reference method | Path-only references in docs; runtime consumes `${WAZUH_ADMIN_PASSWORD}` from `/opt/wazuh-docker/multi-node/ops/creds.env` (mode 600) | Confirmed: creds file mode 600, contains `WAZUH_ADMIN_PASSWORD`; all docs render value as `[REDACTED]`; no values printed to reports | READY |
| R3 | Expected index pattern/name | `wazuh-archives-4.x-2026.08.26`, midnight roll ±jitter (00:00:02.000–04.000Z) | Matches historical creation series (phase39-22 §2) | READY |
| R4 | Expected template resolution | fieldlimit wins at priority 320 over p19-retention 310 / wazuh-main 300 / legacy wazuh order 0 | Priorities re-read live this session (phase40-05 §3) | READY |
| R5 | Baseline rejection counter frozen | 1503/10min · 8960/hr · 9109 visible-total @ Aug-25 22:50–55Z | Present verbatim in phase39-24 §2; comparable windows used post-roll | READY |
| R6 | Evidence destinations | `ops/evidence/fieldlimit-proof-<ts>.log` sink + report embedding | Sink convention honored conceptually; outputs embedded directly in phase40-04..09; guardrail state now persisted by script | READY-WITH-NOTE |
| R7 | Rollback armed | Delete-template non-destructive path verified P39 (phase39-27) | Revalidated design-only this arc (phase40-12); not executed | ARMED |

## 3. Credential Handling Statement

Per AGENTS.md: values never enter files. Reports use `[REDACTED]` placeholders;
commands shown with `-u admin:[REDACTED]`. Runtime sessions sourced the creds env
internally (`set -a; . /opt/wazuh-docker/multi-node/ops/creds.env; set +a`) and the
value was consumed only inside process memory. The path itself is outside the repo.

## 4. Baseline Freeze Reference

The "before" side of every after-window comparison in phase40-08 comes from the
frozen P39 table plus a fresh per-minute histogram captured pre-cutover in retained
docker logs — both reproduced there. No baseline number was re-derived after the fact.

## 5. Verdict

**COMPLETE** — readiness confirmed with one disclosed gap (R1) and one note (R6);
both closed or bounded before certification.
