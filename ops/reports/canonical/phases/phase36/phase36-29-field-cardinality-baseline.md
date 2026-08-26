# Phase 36: Field Cardinality Baseline

Date: 2026-08-25

## Problem
- Suricata stats events have 522 fields
- Wazuh json decoder limit: 256 (decoder_order_size)
- 15,189 "Too many fields for JSON decoder" errors accumulated

## Impact
- Stats events not fully decoded by Wazuh
- Events still reach archives (indexing works)
- Analysisd processes them but truncates fields

## Wazuh analysisd stats
- events_received: 918,881+
- events_dropped: 0
- All queues at 0%

## decoder_order_size
- Current: 256 (in /var/ossec/etc/internal_options.conf)
- No local_internal_options.conf override

## Recommendation
- Option A: Increase decoder_order_size to 512 (preferred)
- Option B: Minimize Suricata stats output

## No secrets
