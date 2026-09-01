Report ID: 490
Phase: 85
Title: Class-A Certification One — Fresh Phase 85 Shuffle-Driven Write + REST Read
Date: 2026-08-31
Timestamp UTC: 2026-08-31T00:17:11Z
Timestamp ET: 2026-08-30T20:17:11-04:00
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p85/prompts/490-classa-certification-one-01.md
Prompt: 490-classa-certification-one-01.md

## Attestation (work item of 10)

Two fresh strict Class-A end-to-end certifications were performed THIS phase (Phase 85) through the real Wazuh→IRIS Shuffle workflow (wazuh-high-severity-to-iris) executed as a genuine Shuffle action task. Certification one PASSED: a NEW IRIS object 712 was created by action task 484d8d7c-cd18-45d3-88d3-d337447ff670 (request_executor=shuffle_action_task), write_http_status=200; exact REST item GET (verification_method=rest_item_get) on /alerts/712 returned HTTP 200, response_sha256=8b135ad154c2d396f3e3f4febc929dbffbd82e209962a511ac92bc04bc0a370d, unique_marker P85MK1-f2857500a04f present in both write and read (marker_match=true), evidence_class=CURRENT, current_or_carried=CURRENT. Certification two (object 713) also PASSED under the same strict criteria. No secret value appears in any artifact. PASS.

Primary evidence: ops/reports/evidence/phase85/phase85-evidence-e2e.json (certification_one / certification_two). Request executor shuffle_action_task; write_http_status 200; read_http_status 200; verification_method rest_item_get; current_or_carried CURRENT. No secret value present in this artifact.
