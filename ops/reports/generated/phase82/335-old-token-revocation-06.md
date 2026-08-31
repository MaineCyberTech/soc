Report ID: 335
Phase: 82
Title: Old Token Revocation
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T06:03:30Z
Timestamp ET EDT: 2026-08-31T02:03:30 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p82/prompts/335-old-token-revocation-06.md
Prompt: 335-old-token-revocation-06.md

== Summary ==
The previously-valid token (pre-renewal key for user 9001) was verified to be rejected: GET with the old token returns HTTP 401, confirming revocation and that old_secret grants are removed. Evidence: /opt/mct-security-stack/ops/reports/evidence/phase82/phase82-evidence-rotation.json (old_token_rejected=true, old_secret_grants_removed=true).
