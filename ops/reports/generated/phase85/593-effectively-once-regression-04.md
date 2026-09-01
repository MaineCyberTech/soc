Report ID: 593
Phase: 85
Title: Effectively-Once Regression — Phase 85
Date: 2026-08-31
Timestamp UTC: 2026-08-31T00:17:11Z
Timestamp ET: 2026-08-30T20:17:11-04:00
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p85/prompts/593-effectively-once-regression-04.md
Prompt: 593-effectively-once-regression-04.md

## Attestation (work item of 10)

Exactly-once regression: each of the two Phase 85 certifications created exactly ONE NEW IRIS object (712, 713) with no duplicate object produced. The dedup/ledger keyed on the event_id (p85cert1-88A01/p85cert2-88B02) prevents duplicate creation (DELIVERED immutable). PASS.

Primary evidence: ops/reports/evidence/phase85/phase85-evidence-e2e.json (certification_one / certification_two). Request executor shuffle_action_task; write_http_status 200; read_http_status 200; verification_method rest_item_get; current_or_carried CURRENT. No secret value present in this artifact.
