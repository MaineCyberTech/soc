# Phase 56: Synthetic Tag Schema

**Prompt:** 081-synthetic-tag-schema
**Report ID:** phase56-081
**Phase:** 56
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Classification:** INTERNAL
**Verdict:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/081-synthetic-tag-schema.md

## Summary
Defined a safe synthetic label/field schema and provenance from read-only inspection. The
current production path tags routed alerts with a free-text `alert_tags` string
`source:suricata,class:A,test:true`; there is NO governed, machine-keyable synthetic marker
field that downstream billing/scorecard/notification/client/queue systems can filter on.

## Evidence
- **EV-WF-SRC-001** (VERIFIED): workflow `e133a645-…` `execute_python` builds IRIS body with
  `"alert_tags": "source:suricata,class:A,test:true"`. This is the only labeling applied on
  ROUTED today.
- **EV-IRIS-067/068/060** (VERIFIED): all three carry `test:true` inside `alert_tags`; no
  dedicated `synthetic`/`MCT_SYNTHETIC` field exists on the object.
- **EV-IRIS-CUST-001** (VERIFIED): objects sit in production customer 1, not a test tenant.

## Proposed schema (definition only — not applied)
- Add a governed marker field, e.g. IRIS `alert_tags` token `mct_synthetic:true` (or a
  custom attribute `MCT_SYNTHETIC=true`), plus `mct_synthetic_owner`, `mct_synthetic_src`
  (workflow exec id), `mct_synthetic_ts` (UTC). Provenance = Shuffle `execution_id` +
  workflow `e133a645-…`. Namespace `mct_synthetic` kept isolated from production labels.

## Backup / Rollback
Read-only. Applying the schema is an IRIS metadata write (owner-gated; see Stop conditions).

## Stop conditions
Applying a governed synthetic label to IRIS objects 60/67/68 is a production IRIS metadata
mutation requiring owner sign-off (new-approval gate, run-context §4). Marked PARTIAL:
schema defined, application DEFERRED.

## Limitations
Schema is a recommendation; no CI/enforcement exists yet to guarantee future synthetic objects
inherit the marker (see 092/097/098/099).

## Verdict rationale
Label schema defined and provenance established from real inspection, but the governed marker
field is not yet applied to objects and no enforcement exists — partial completion.
