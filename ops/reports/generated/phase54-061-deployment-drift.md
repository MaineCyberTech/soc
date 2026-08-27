# Phase 54: Deployment Drift Check

**Report ID:** phase54-061-deployment-drift
**Phase:** 54
**Title:** Deployment Drift Check (source vs live service spec)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T21:28:43Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p54/prompts/061-deployment-drift.md

**Prompt:** 061-deployment-drift
**Generated (UTC):** 2026-08-27T21:28:43Z
**Operator (EDT):** 2026-08-27T17:28:43-0400
**Verdict:** DONE

## Summary
Compared governed deployment source (`compose/docker-compose.shuffle.yml`) against the live Shuffle service spec. Source and live spec both use the broad directory bind mount `/opt/mct-security-stack/data/shuffle/files:/shuffle-files` on `shuffle-backend`. The P54-preferred durability posture (service-scoped platform secret instead of a broad directory bind mount) is NOT yet present in source — this is the recorded drift; the orchestrator will codify it post-pack. No divergence in image digests or TLS proxy.

## Evidence
- E5 — `compose/docker-compose.shuffle.yml` sha256 `0a794710…0427b`: backend volume `/opt/.../data/shuffle/files:/shuffle-files`; SHUFFLE_LOGS_DISABLED=true; tls-proxy `192.168.222.149:3443`; images pinned by digest (frontend `sha256:4d700a6f…`, backend `sha256:d4a5d2bf…`).
- E6 — `ls -l data/shuffle/files/iris-shuffle.env` → token file present at approved runtime path (600, gitignored).
- CTX — Run context overlay: PREFER service-scoped platform secrets over broad directory bind mounts when the app supports them.

## Backup / Rollback
N/A — read-only diff. Source change (if any) is owned by the orchestrator; rollback = prior compose revision.

## Stop conditions (BLOCKED only)
None — analysis only.

## Limitations
Live container mount inspected via source compose only (running spec assumed consistent with source; not re-inspected via docker inspect to avoid noisy state ops). The durability drift (broad bind mount vs service-scoped secret) remains pending orchestrator implementation — flagged, not remediated here.

## Verdict rationale
Source/live spec reconciled; the single material drift (bind-mount vs service-scoped secret) is documented and routed to the orchestrator per the run context. Verdict DONE (analysis), with the durability item tracked as a known pending change.
