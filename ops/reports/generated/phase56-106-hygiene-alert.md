# Phase 56: Hygiene Alert

**Prompt:** 106-hygiene-alert
**Generated (UTC):** 2026-08-27T23:28:07Z
**Operator (EDT):** 2026-08-27T19:28:07-0400
**Verdict:** DONE

**Report ID:** phase56-106-hygiene-alert
**Phase:** 56
**Classification:** INTERNAL
**Status:** DONE

## Summary
Bounded destination for hygiene alerts on unlabeled synthetic objects. The workflow already has a bounded failure-notification sink: `notify()` writes to `p53_notifications` category (best-effort, never raises) on failure states. A synthetic-hygiene alert should reuse this bounded `p53_notifications` destination (NOT production alert routing). Production alert routing remains approval-gated (AGENTS.md Operational Safety).

## Shared read-only evidence (VERIFIED unless flagged)
- EV-WF-SRC (VERIFIED): Workflow `suricata-packet-routing` (`e133a645-95b9-4e01-9454-e270d2a0b599`)
  source exported read-only via `GET /api/v1/workflows/e133a645-...` (Shuffle API `127.0.0.1:5001`,
  `SHUFFLE_API_KEY` read programmatically, never printed) to a nonsecret temp file. Single
  `execute_python` action `parse-eve-json`.
- EV-DEDUP-DEFECT (VERIFIED): `dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port)` —
  omits `proto` and `agent`. Distinct-protocol / distinct-agent events with identical
  sid/src/dst/port are falsely collapsed. Confirms Phase 55 carryover dedup defect.
- EV-COUNTER-FLAG (VERIFIED): `set_cache_value(key="p53_packet_routed", value="1", category="p53_counters")`
  stores literal `"1"` (a boolean-style flag), NOT an atomic cumulative increment. No `append`/
  increment, no TTL, no UTC/synthetic namespace. Confirms Phase 55 counter gap.
- EV-NORM-ABSENT (VERIFIED): No normalization for `proto` (TCP/tcp/6), address (IPv4/IPv6),
  port, SID, or direction. Raw `alert.get(...)` values feed both `dedup_key` and IRIS body.
- EV-OBS-ABSENT (VERIFIED): `dedup_key` has no agent / sensor / manager / tenant component and no
  governed observer identity policy.
- EV-KEY-VER-HASH-ABSENT (VERIFIED): `dedup_key` is plaintext field interpolation; no version
  prefix (e.g. `v1:`) and no stable nonsecret digest (hash). No TTL / UTC namespace.
- EV-SYNTH-POLLUTE (VERIFIED): Allowlisted (non-synthetic) events increment `p53_packet_routed`;
  the `synthetic and fault` path can also reach counter increment, so synthetic events may pollute
  the production counter. IRIS object is tagged `alert_tags: "source:suricata,class:A,test:true"`
  but carries NO explicit `MCT_SYNTHETIC` exclusion label / isolated namespace.
- EV-TRIG-ONLY-ONE (VERIFIED, REST/trigger layer — SEPARATE from Wazuh integratord/sensor-origin):
  `GET /api/v1/triggers` returns exactly ONE webhook: `suricata-eve-in` (`736b7410-...`, status
  `running`). Class-A `wazuh-high-severity-to-iris` (`eb937a37-...`) is ABSENT from the live
  trigger list — confirms Phase 55 carryover drift (contradicts AGENTS.md "both live" claim).
- EV-OS-UNREACH (UNVERIFIED, datastore layer — SEPARATE): OpenSearch `127.0.0.1:9200` returns empty
  reply (curl http 000). ISM/capacity metrics unreadable; synthetic-case monitoring unverifiable live.
- EV-EXEC-SAMPLE (VERIFIED): `GET /api/v1/workflows/e133a645-.../executions?limit=200` returned 100
  executions; sampled states MALFORMED / DATASTORE_READ_FAIL / UNKNOWN / ENV_PROBE / ROUTED confirm
  dead-letter (`p53_deadletter`) and notification (`p53_notifications`) branches exist.

## Evidence layers (kept separate)
- REST / webhook / Wazuh integratord / sensor-origin: see EV-TRIG-ONLY-ONE (REST/trigger layer) and
  carryover Class-A drift (Wazuh integratord `webhook_eb937a37` vs live trigger id mismatch) — handled
  in the Class-A owner-gated prompts, NOT mutated here.
- task / service / Orborus / host / full-restore: NOT touched; no service deletion, host reboot, or
  full restore performed (approval-gated; see run-context §4).

## Backup / Rollback
No mutation performed (read-only inspection only). Workflow source exported read-only to a nonsecret
temp path; no live workflow revision, no secret, no production change. Rollback is N/A; if a future
orchestrator applies the recommended workflow fix, the Shuffle workflow revision history provides the
prior revision (reversible per Phase 53 dead-letter/notification change design).

## Stop conditions
Stop: enabling production alert routing is approval-gated; synthetic-hygiene alert reuses the existing bounded notification category only. No mutation.

## Limitations
Live IRIS/OpenSearch not queried (secret/unreachable). Bounded-destination mechanism VERIFIED from source.

## Verdict rationale
DONE: bounded synthetic-hygiene alert destination identified (existing `p53_notifications`); production routing left approval-gated.
