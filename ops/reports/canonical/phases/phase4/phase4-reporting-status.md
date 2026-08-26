# Phase 4 Reporting Status

Date: 2026-08-11

## Generated

| Report | Mode | Content | Status |
|---|---|---|---|
| reporting/output/internal/phase4-internal-soc-scorecard.md | LIVE | 1,949,758 alerts/30d; Class A 446, Class B 9,746 | DONE |
| reporting/output/internal/phase4-alert-quality-report.md | LIVE | 1,949,784 alerts; split A=446 B=9,302 C=466,183 D=1,473,853; top rules | DONE |
| reporting/output/client/phase4-client-scorecard-template.md | TEMPLATE | monthly-client-scorecard with placeholders | DONE |
| reporting/output/scorecard-*.md (sample) | SAMPLE | generator smoke tests | DONE |

## Generator fixes applied

1. **Auth 401**: both generators now send Basic auth (self-signed cert TLS context + Authorization header).
2. **Zero alert count**: scorecard live mode now maps count keys to template placeholders (alerts_total/alerts_high/alerts_critical).
3. **KeyError period**: quality report live_data now sets period.
4. **track_total_hits** added so totals aren't capped at 10k.

## Data notes

- Alert totals reflect the 30-day window (includes pre-suppression osquery 24010
  volume: top rule 24010 at 495k in window - suppression applied 2026-08-11
  will reduce the NEXT window).
- Class split: D-class dominates (1.47M) - confirms archive-only behavior is correct.

## Delivery process

ops/runbooks/scorecard-delivery.md - generation, client-safe conversion, cadence, channels.

## Acceptance

- Sample report exists: YES
- Live report exists: YES
- No credentials embedded: YES (auth via env only)
- Client-ready format: YES (template with plain-language sections)
