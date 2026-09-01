# Report ID: 820-otel-capacity-01
# Phase: 85
# Title: Phase 85 Governance — OTel Capacity (Item 1 of 10)
# Date: 2026-08-31
# Timestamp (UTC): 2026-09-01T01:56:26Z
# Timestamp (ET): 2026-08-31T21:56:26 EDT
# Classification: INTERNAL
# Status: PASS
# Source Path: ops/reports/evidence/phase85/phase85-evidence-governance.json
# Prompt: /home/user/mct-p85/prompts/820-otel-capacity-01.md

## Governance Disposition

Evidence class: CURRENT. Primary non-secret source: ops/reports/evidence/phase85/phase85-evidence-governance.json (reconciled against canonical current-state, open-work ledger, and prior Phase 83/84 evidence).

OTel capacity posture explicit. The OTel collector (contrib) exports traces to shuffle-opensearch:9200 over TLS as scoped user otel_collector; capacity remains a manual watch and disk watermarks are advisory only. Disposition: governed.

## Reconciliation

This attestation is governed by phase85-evidence-governance.json. Objects 688/689 (Phase 83 cert objects) and 701/702 (Phase 84 fresh cert objects) are carried from prior attestation (IRIS REST re-GET infeasible from the attest host at generation time). The two fresh Phase 85 cert objects IRIS 712 and 713 are evidenced CURRENT via REST item GET 200 in phase85-evidence-e2e.json. Historical objects 192/193 remain a documented immutable duplicate failure. Phase 84's deliberate exclusion of prompt indices 920-939 and stray 1000-* artifacts is adjudicated: exclusions were intentional and are not canonicalized. No secret value is printed, logged, or committed in this artifact.
