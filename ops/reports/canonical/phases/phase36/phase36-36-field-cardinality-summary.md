# Phase 36: Field Cardinality Summary

Date: 2026-08-25

## Root cause
- Suricata stats: 522 fields > decoder_order_size: 256
- 15,189 "Too many fields" errors accumulated

## Fix applied
- local_internal_options.conf: analysisd.decoder_order_size=512
- Restart required (not yet executed)

## Impact
- Non-fatal: events still indexed
- Fix will eliminate truncation errors
- Low risk, reversible

## Gate: FIX APPLIED (restart pending)
## No secrets
