# Phase 55: Docker Socket Risk

**Prompt:** 109-socket-risk
**Generated (UTC):** 2026-08-27T23:25:00Z
**Operator (EDT):** 2026-08-27T19:25:00-0400
**Verdict:** ACCEPT

## Summary
Assessment of Orborus/dynamic-worker privilege (Docker socket exposure) and compensating controls. Only `shuffle-workers` mounts the Docker socket; all other services — including the secret-bearing `shuffle-tools` — have no socket access. This is the expected Shuffle dynamic-worker privilege, bounded and least-privilege at the service level.

## Evidence
- **EV-109-1 (VERIFIED):** Mount audit across all 7 services: only `shuffle-workers` mounts `{"Type":"bind","Source":"/var/run/docker.sock","Target":"/var/run/docker.sock"}`. email/http/shuffle-ai/shuffle-subflow/shuffle-tools/shufflehealthcheck → null mounts.
- **EV-109-2 (VERIFIED):** `shuffle-tools_1-2-0` mounts only the read-only bind `/opt/mct-security-stack/data/shuffle/files → /shuffle-files (ReadOnly:true)` (legacy fallback) plus the service-scoped secret `iris-shuffle-env` (mode 0444). It does NOT have the socket.
- **EV-109-3 (VERIFIED):** Secret `iris-shuffle-env` (ID 4vpfvc92ice01x52qtc69yi2c) is granted ONLY to `shuffle-tools_1-2-0` (service-scoped), not to `shuffle-workers` or any socket-bearing service.
- **EV-109-4 (VERIFIED):** Swarm is single-node (Leader: docker, engine 29.7.2); socket exposure is to the local daemon only.

## Backup-Rollback
Not applicable — read-only risk assessment; no change made. If socket exposure were later reduced (e.g., socket-proxy), baseline = current mount spec; rollback = restore bind mount.

## Stop conditions
None triggered. Assessment is read-only. Any change to socket exposure/posture is TLS/exposure-gated (run-context §4) and would require owner approval.

## Limitations
Compensating controls reviewed at the service/swarm level. A socket-proxy or egress/network-restriction hardening was not applied (would be a posture change, owner-gated). The risk is ACCEPTED with the noted scoping: socket confined to `shuffle-workers`, secret confined to `shuffle-tools`, separation of privilege maintained.

## Verdict rationale
ACCEPT: Docker socket privilege is real but bounded and least-privilege at the service boundary, with documented compensating controls (secret service-scoped, fallback bind read-only, socket not granted to secret-bearing service). No mutation performed.
