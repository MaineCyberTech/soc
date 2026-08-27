# Phase 56: Synthetic Retention Policy

**Prompt:** 090-retention-policy
**Report ID:** phase56-090
**Phase:** 56
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Classification:** INTERNAL
**Verdict:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/090-retention-policy.md

## Summary
Defined a synthetic-object retention policy (owner, period, legal/evidence needs) from read-only
analysis. No retention rule is currently encoded for objects 60/67/68; they persist indefinitely in
customer 1.

## Evidence
- **EV-IRIS-060/067/068** (VERIFIED): objects persist with no TTL/expiry field; `alert_creation_time`
  spanning 2026-08-27T19:45Z → 23:02Z.
- **EV-OS-001** (UNVERIFIED): IRIS/OpenSearch retention/ISM not directly inspectable from host; no
  synthetic-specific retention policy observed.
- **EV-WF-TTL-001** (VERIFIED): workflow cache writes (p53_dedup/p53_counters/p53_deadletter/
  p53_notifications) carry no TTL — no UTC TTL governance today.

## Proposed policy (definition only)
- Owner: ops-reports-owner / SOAR ops owner (joint). Period: synthetic test objects retained 30d
  UTC then purged via scripted, non-destructive tooling; legal/evidence hold extends to case linkage.
- Namespace isolation: UTC `mct_synthetic_*` keys; retention clock anchored to `alert_creation_time`
  (UTC).

## Backup / Rollback
Read-only. Any future purge uses sanctioned retention tooling only (AGENTS.md: never force-delete
ISM-managed indices; no ad-hoc deletion — see 091).

## Stop conditions
Adopting a period/legal stance and applying any retention action is owner sign-off (retention is
approval-gated, run-context §2/§4 destructive-retention). PARTIAL: policy defined; ratification
owner-gated.

## Limitations
Live retention/ISM metrics unreachable; policy derived from inspection + governance, not live metric.

## Verdict rationale
Retention policy drafted from evidence; owner ratification on period/legal pending → PARTIAL.
