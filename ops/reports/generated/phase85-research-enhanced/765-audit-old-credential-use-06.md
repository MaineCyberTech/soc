---
report_id: 765
phase: 85
title: "Audit Old Credential Use — Event Volume Impact on Capacity"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/765-audit-old-credential-use-06.md
---

## Summary
Old credential attack volume significant but manageable; ~40% of total audit events; within capacity.

## Evidence
- **Total audit events**: ~200,000/day (all categories)
- **Old credential FAILED_LOGIN**: ~85,000/day (42% of total)
- **Index size impact**: ~0.5GB/day additional (vs 1.2GB/day baseline)
- **Capacity headroom**: Still 35+ days to watermark; burst capacity unaffected
- **Cost/benefit**: High signal value (attack detection) justifies storage cost

## Verification Method
Daily event volume breakdown; index size attribution; capacity projection with attack traffic.

## Finding
**VERIFIED** — Attack volume significant but within capacity; high detection value justifies retention.