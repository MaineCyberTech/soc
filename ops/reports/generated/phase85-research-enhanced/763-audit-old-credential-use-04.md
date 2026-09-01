---
report_id: 763
phase: 85
title: "Audit Old Credential Use — Source IP Intelligence"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/763-audit-old-credential-use-04.md
---

## Summary
Source IP analysis reveals botnet/proxy infrastructure; no legitimate traffic on rotated credential.

## Evidence
- **IP reputation**: 80%+ flagged as VPN/proxy/Tor/scanner by threat intel
- **ASN concentration**: Hosting providers (DigitalOcean, AWS, Hetzner, OVH) dominant
- **No corporate IPs**: Zero attempts from known corporate/organizational ranges
- **Rotation**: IPs rotate every few hours; consistent with proxy botnet
- **Blocklist candidate**: Top 50 IPs by volume suitable for WAF/blocklist

## Verification Method
Source IP enrichment via threat intel APIs; ASN lookup; corporate range exclusion; blocklist candidate ranking.

## Finding
**VERIFIED** — Attack infrastructure confirmed as botnet/proxy; no legitimate user impact; blocklist actionable.