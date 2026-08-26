# Phase 31 Suricata Detection Quality

Date: 2026-08-24

## Test (safe traffic only - no invasive scans)

- Generated safe traffic (outbound HTTPS/DNS/ping) during the benchmark; Suricata produced
  **70 alert events** from the focused ruleset (sid 4100001-4) with correct timestamps,
  src/dst, and signature fields in eve.json (JSON validated).
- No false-positive flood (bounded, ~0.05% of packets).

## Wazuh ingest

- EVE JSON schema confirmed compatible with the Wazuh JSON decoder design (14); production
  ingest + alert routing to be validated on SPAN-backed deploy (17 continuation).

## No secrets
## PRODUCTION TRAFFIC DETECTION (SPAN, 2026-08-24)

- Real SPAN traffic (mDNS/SSDP/broadcast-heavy): **0 alerts** from the focused 4-rule set -
  zero false positives (bounded), but limited coverage on this profile.
- Detection quality conclusion: the minimal ruleset is validated as noise-safe; a broader
  curated ruleset (targeting the actual protocols present) is required for production
  detection value - Phase 32, with careful FP/volume management.
- Field/timestamp validation: eve.json JSON valid; stats + alert schema correct.

## No secrets
