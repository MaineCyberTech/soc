# Phase 25 NetFlow Alert Arming

Date: 2026-08-22
Status: **NOT ARMED - GATED ON SCOPE APPROVAL** (C10).

## Arming plan (when scope approved)

- Alerts: new-subnet first-seen (Class A), unknown-exporter (Class A), outbound bytes spike
  (Class B), unusual internal port (Class B).
- Baseline: 7d dry-run on history (expect < 5 genuine first-seens/day).
- Rate limit + dedup: same alert key (src subnet + exporter) once per 24h; stop threshold
  20/day with notify.
- Rollback: disable alert + remove allowlist change.

## Decision

- **UNARMED** pending operator scope classification (phase25-33).

## No secrets