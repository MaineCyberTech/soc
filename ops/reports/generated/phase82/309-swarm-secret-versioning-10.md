Report ID: 309
Phase: 82
Title: Docker Swarm Secret Versioning
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T06:03:30Z
Timestamp ET EDT: 2026-08-31T02:03:30 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p82/prompts/309-swarm-secret-versioning-10.md
Prompt: 309-swarm-secret-versioning-10.md

== Summary ==
The Docker Swarm secret 'iris-shuffle-dedicated' was versioned to carry the new IRIS_API_KEY while preserving IRIS_BASE_URL/IRIS_CA/VERIFY_CERTS. Because swarm secrets are immutable, rotation used a temporary-name swap (create -new, update shuffle-tools_1-2-0, remove old, recreate canonical, update back) so the canonical name continues to serve the Shuffle Tools app at /run/secrets/iris-shuffle.env. Evidence: /opt/mct-security-stack/ops/reports/evidence/phase82/phase82-evidence-rotation.json.
