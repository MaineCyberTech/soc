# Phase 36: Field Cardinality Fix Design

Date: 2026-08-25

## Option A: Increase decoder_order_size (RECOMMENDED)
- Change: Add `analysisd.decoder_order_size=512` to local_internal_options.conf
- Location: /var/ossec/etc/local_internal_options.conf on manager
- Impact: Allows full parsing of 512-field events
- Risk: Low — only affects decoder field count limit

## Option B: Minimize Suricata stats output
- Change: Configure Suricata to reduce stats fields
- Impact: Less data in eve.json stats
- Risk: Medium — may lose useful metrics

## Decision: Option A (increase limit)
- Non-intrusive
- Preserves all data
- Standard Wazuh tuning

## No secrets
