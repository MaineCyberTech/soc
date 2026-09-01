Report ID: 575
Phase: 85
Title: IRIS REST Item GET Read-Back — Phase 85 New Objects
Date: 2026-08-31
Timestamp UTC: 2026-08-31T00:17:11Z
Timestamp ET: 2026-08-30T20:17:11-04:00
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p85/prompts/575-iris-rest-readback-06.md
Prompt: 575-iris-rest-readback-06.md

## Attestation (work item of 10)

Exact IRIS REST item GET (GET /alerts/<id>, verification_method=rest_item_get) was performed with the Phase 82-established read-scoped credential (iris-shuffle-dedicated logical identity) and returned HTTP 200 for both NEW Phase 85 objects 712 and 713. Recorded response_sha256: 712=8b135ad154c2d396f3e3f4febc929dbffbd82e209962a511ac92bc04bc0a370d, 713=ac136de0439dd34a386458388b0197a70e294a06851d08fa407e5b399c403370. The read-back is independent of the write path and confirms live item detail. PASS.

Primary evidence: ops/reports/evidence/phase85/phase85-evidence-e2e.json (certification_one / certification_two). Request executor shuffle_action_task; write_http_status 200; read_http_status 200; verification_method rest_item_get; current_or_carried CURRENT. No secret value present in this artifact.
