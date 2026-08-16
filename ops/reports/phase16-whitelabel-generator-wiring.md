# Phase 16 White-Label Generator Wiring

Date: 2026-08-16

## Status: WIRED - config-driven rendering operational

## Script

- scripts/reporting/render-branded-template.py
- Reads: config/brand.yml (or example) + config/clients/<slug>.yml (or example).
- Outputs: branded scorecard + branded kickoff email.

## Behavior

- Prefers live config (gitignored) -> falls back to committed examples.
- Client-safe: only brand vars + placeholders in output (no internals).

## Tested

- Render with examples: scorecard + email generated successfully.

## No secrets
