# Phase 56: Service Recreation Persistence

**Prompt:** 059-classa-service-recreate
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DEFERRED

## Summary
Service-recreation persistence (recreating the Shuffle/IRIS service backing Class-A to prove state
persists) is approval-gated (059). Not performed. Kept as a SEPARATE layer from task recreation
(058), Orborus recreation, host recovery, and full restore — none of which are touched.

## Evidence
- EV-SVC-01 (VERIFIED): Run-context §6 lists 059 (service recreation) among owner-gated prompts. Service recreation is a destructive/lifecycle operation.
- EV-SVC-02 (VERIFIED): Live services observed (docker ps): `shuffle-backend`, `shuffle-orborus`, `shuffle-tools`, `iriswebapp_nginx/app/db/worker` all Up; no recreation needed or performed. (Inventory only — no mutation.)
- EV-SVC-03 (VERIFIED): Overlay freeze on nonessential Shuffle lifecycle changes; service deletion/recreation is explicitly approval-gated (AGENTS.md: "service deletion" gated; host reboot, full restore gated).

## Backup-Rollback
Baseline in 046. If an approved service recreate is later done: capture post-recreate service ids
and `GET /api/v1/triggers` proof; rollback = redeploy from 046 references. No snapshot taken (read-only).

## Stop conditions
**STOP — do not recreate/delete services.** Requires owner approval (048). No host reboot, no full
restore (302-305), no disk (300), no TLS/exposure change. SEPARATE from task/Orborus/host/full-restore layers.

## Limitations
- Persistence across service recreation cannot be proven without the gated operation.
- We did not stop/start any container; only inspected running state.

## Verdict rationale
Service recreation persistence is approval-gated. Marked DEFERRED (legitimate stop).
