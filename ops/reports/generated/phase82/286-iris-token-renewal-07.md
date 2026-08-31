Report ID: 286
Phase: 82
Title: IRIS API Token Renewal
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T06:03:30Z
Timestamp ET EDT: 2026-08-31T02:03:30 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p82/prompts/286-iris-token-renewal-07.md
Prompt: 286-iris-token-renewal-07.md

== Summary ==
A NEW IRIS API token was minted via the IRIS API: POST /manage/users/renew-api-key/9001 (service account shuffle-classa-svc, user id 9001). The endpoint returned the new key, which was captured ONLY into the secure backup and the swarm secret/bind file - never into any committed artifact. The prior token was revoked by the renewal. Evidence: /opt/mct-security-stack/ops/reports/evidence/phase82/phase82-evidence-rotation.json (new_token_write_pass / new_token_read_pass / old_token_rejected = true).
