# Phase 17 White-Label Production Wiring

Date: 2026-08-16

## Status: WIRED - production scorecard renderer

## Scripts

- scripts/reporting/render-branded-template.py (sample/email)
- scripts/reporting/render-client-scorecard.py (production scorecard)

## Behavior

- Reads config/brand.yml (or example) + config/clients/<slug>.yml (or example).
- Renders 3-endpoint scorecard (013/014/015).
- Client-safe: brand vars only, no internals.

## Next (backlog)

- Real brand.yml + client profile for production.
- Wire into monthly ops (render at scorecard time).

## No secrets
