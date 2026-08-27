# Phase 56: Class-A Security Audit

**Prompt:** 077-classa-audit
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27 20:35:00 -0400
**Verdict:** PARTIAL

## Summary
Security audit of the Class-A lane across auth, TLS, source, and synthetic isolation. Auth (value-blind token) and TLS (proxy up) controls are sound; source inspected; synthetic isolation is partially implemented (code honors MCT_SYNTHETIC and tags `test:true`, but no automated enforcement excludes resulting IRIS objects from billing/scorecards/notifications/client views). The lane is also currently broken (062/063/064). Audit = PARTIAL (structural controls OK; exclusion-enforcement + wiring gaps).

## Evidence
- EV-13 (VERIFIED): Token loaded value-blind from approved runtime store (`/shuffle-files/iris-shuffle.env` or `/run/secrets/iris-shuffle.env`); no secret in code/repo. Swarm secret `iris-shuffle-env` (id 4vpfvc92ice01x52qtc69yi2c, mode 0444) to shuffle-tools only.
- EV-14 (VERIFIED): `shuffle-tls-proxy` (nginx) Up; Shuffle TLS on :3443; plaintext LAN exposure closed (Phase 40). [docker ps]
- EV-08 (VERIFIED): Source honors MCT_SYNTHETIC (emits SYNTHETIC_TEST {isolated:True}); IRIS alert_tags `class:A,test:true`. GAP: no automated exclusion of IRIS objects from billing/scorecards/notifications/client views. [wf_packet.json]
- EV-04/05 (VERIFIED): Class-A lane broken (test status, webhook absent, integratord mismatch). [wf_classa.json, ossec.conf:346]
- EV-03 (VERIFIED): Controlled synthetic POST isolated (no IRIS object created) — confirms synthetic isolation at ingress. [resp.json]

## Backup / Rollback
Read-only. No mutation.

## Stop conditions
Enforcing synthetic-exclusion policy or repairing wiring = gated mutations. Not executed.

## Limitations
Cannot confirm IRIS-side labeling of any historical synthetic object without IRIS API read (deferred); code-level tag `test:true` is the only isolation signal present.

## Verdict rationale
Auth/TLS/source controls verified; synthetic-exclusion enforcement gap + broken lane → PARTIAL.
