# Phase 31v2 Rule Profile

Date: 2026-08-24
- Focused ruleset: 4 alert-only rules (sid 4100001-4: DNS sinkhole, HTTP UA, TCP scan
  threshold, ICMP tunnelling). 0 rules failed to load.
- **0 alerts on real SPAN traffic** (mDNS/SSDP/broadcast profile) - noise-safe but
  low detection coverage. Rule profiling: cost/checks to be measured when profiling-enabled
  build used (build supports profiling).

## No secrets
