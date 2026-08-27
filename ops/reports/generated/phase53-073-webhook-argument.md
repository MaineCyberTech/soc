# Phase 53: Webhook execution_argument

**Prompt:** 073-webhook-argument
**Generated (UTC):** 2026-08-27T20:08:35Z
**Operator (EDT):** 2026-08-27T16:08:35-0400
**Verdict:** DONE

## Summary
Proves the webhook path carries the raw marker/fields as execution_argument.

## Evidence
- E1: execution 254d6c05 execution_argument (type=str, len=313) contains the raw marker JSON: timestamp, flow_id=2027967001, event_type=alert, src_ip=203.0.113.71, dest_ip=198.51.100.71, alert.signature_id=2027967, marker string.
- E2: triggers API confirms hook 736b7410 -> workflow e133a645 (suricata-packet-routing) consumes the body.
- E3: LIVE ROUTED PROOF execution 4d5b9d15 shows the same pattern (webhook body -> execution_argument -> workflow -> IRIS object 60).

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
Argument shown is the surrogate marker; no real Suricata fields. Field mapping into IRIS is performed by the workflow (proven by object 60 in the ROUTED proof).

## Verdict rationale
Webhook execution_argument faithfully carries the raw JSON marker/fields. DONE.
