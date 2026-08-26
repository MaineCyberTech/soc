# Phase 11 Stale Reference Scan

Date: 2026-08-16

## Scan scope

- Current operational docs (ops/runbooks, ops/checklists, integrations,
  client-onboarding, service-packaging, reporting/templates, README,
  STACK-OVERVIEW).
- Historical reports EXCLUDED (evidence).

## Patterns scanned

| Pattern | Current docs | Historical (excluded) |
|---|---|---|
| "pack root"/"prompt pack"/"pack run" | 0 | 0 |
| "phase 2" / "Phase 2" (as stack name) | normalized to "stack" | preserved |
| "Phase 3-8" prose in current docs | normalized titles/refs | preserved |
| "514/udp" remote syslog | 0 (all 15140 since P9) | preserved |
| "SO bridge"/Wazuh->SO forwarding | 0 (packet-ingestion model since P9) | preserved |
| "syslog-ng sidecar" as current | 0 (retired) | preserved |

## Remaining acceptable references

- Recent-phase references (Phase 9/10/11) in current docs - these describe
  recent changes, acceptable as change-log context.
- Historical decision docs (workload-move-decision, canarytokens-plan) -
  phase refs are point-in-time narrative.

## Verification

- verify-no-stale-phase-refs.sh (P11.09) will encode this scan for reuse.

## No secrets

No secret values printed.
