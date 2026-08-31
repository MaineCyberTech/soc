Report ID: 363
Phase: 82
Title: Negative Test: Old Token Rejected
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T06:03:30Z
Timestamp ET EDT: 2026-08-31T02:03:30 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p82/prompts/363-negative-old-token-04.md
Prompt: 363-negative-old-token-04.md

== Summary ==
NEGATIVE TEST passed: the OLD (revoked) token is rejected by IRIS with HTTP 401 on both GET and POST, proving the rotation invalidated the exposed credential. Evidence: /opt/mct-security-stack/ops/reports/evidence/phase82/phase82-evidence-rotation.json (old_token_rejected=true).
