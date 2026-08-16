# Phase 15 Windows Detection Promotion Plan

Date: 2026-08-16

## Gate (all must pass before promotion)

1. [ ] 7-day FP re-measure: < 10 level>=9/day (agents 012+013)
2. [ ] Malicious-variant VaultCli test confirms alerting intact
3. [ ] W1/W2 dashboards built (P15.14)
4. [ ] Defender-Lsass suppression validated (no legit Lsass alerts, non-Defender still fires)

## Promotion steps

1. Enable PS ScriptBlockLogging on pilot 012 (measure EID 4104 volume).
2. Deploy D1-D4 detection rules (LOLBin/encoded PS/temp paths) pilot-only.
3. Build W4/W5 dashboards from new telemetry.
4. Re-measure 7 days -> then client-facing Windows monitoring readiness.

## External Windows client expansion

- BLOCKED until gate passes (currently: client 013 is the only external
  Windows endpoint, monitoring already active).

## No secrets
