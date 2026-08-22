> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 6 Memory Before

Date: 2026-08-11

| Metric | Value |
|---|---|
| RAM total | 9.3 GiB |
| RAM used | 8.4 GiB (90%) |
| RAM available | ~1.0 GiB |
| Swap used | 4.7 GiB / 8 GiB |
| Disk | 82% |
| Top consumers | indexers x3 (~3.8G), shuffle-opensearch (1.17G), elastiflow (0.66G) |

## Assessment

- Swap pressure unchanged since Phase 5 (4.4 -> 4.7 GiB).
- RAM increase NOT yet applied (PVE API blocked; operator action required).
- resource-post-change-validation.sh ready to validate once changed.

## Recommendation (unchanged)

VM101: 9.3 -> 16 GiB minimum (24 preferred). Requires PVE access
(API unblock or operator console).
