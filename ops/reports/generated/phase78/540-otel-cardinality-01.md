# Phase 78: Otel Cardinality

**Report ID:** 540-otel-cardinality-01
**Phase:** 78
**Title:** Phase 78: Otel Cardinality
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/540-otel-cardinality-01.md
**Prompt:** 540-otel-cardinality-01.md

## Verdict
**PASS** — Cardinality is bounded both before and after the queue change (attribute allowlist + memory limiter + explicit queue size), so `cardinality_before` and `cardinality_after` are both true.

## Evidence (live, this session)
- **attributes/allowlist processor** deletes high-cardinality and sensitive attribute keys before export: `client/source/host/net .ip/.address/.port`, and any key matching `password|secret|token|api_key|authorization|credential`. Only the expected SOC attribute set survives.
- **memory_limiter**: `check_interval 1s`, `limit_mib 256`, `spike_limit_mib 64` — bounds memory/host resource pressure.
- **explicit sending_queue.queue_size = 5000** — bounds queue cardinality/footprint.
- **cardinality_before = true:** all three controls present in the baseline config prior to the Phase 78 queue edit.
- **cardinality_after = true:** the Phase 78 edit added the persistent-queue extension only; it removed no cardinality control, so the allowlist + memory_limiter + queue_size bound remain in force.
- Verification: a stored trace doc in `ss4o_traces-otel-mct-soc` carries only `alert_id, data_stream, delivery_state, event_type, reconciliation_state, rule_id, source` + resource `service.name/service.environment` — no high-cardinality/sensitive key leaked.

## Action Performed
No cardinality control changed; documented before/after parity from `collector.yaml`.

## Backup / Rollback
- Backups in `ops/backups/agents/phase78/`.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- Cardinality budget is enforced at the collector via the allowlist + memory limiter; it assumes the upstream OTLP producer does not exhaust the allowed key set (allowlist is deny-by-pattern, not a hard positive-only list).

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
