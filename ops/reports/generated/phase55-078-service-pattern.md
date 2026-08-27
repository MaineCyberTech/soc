# Phase 55: Dynamic Service Pattern

**Prompt:** 078-service-pattern
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
Naming/label/version/replica pattern of Orborus-managed app services, observed from live state.

## Evidence
- EV-1 (VERIFIED): app services follow `<app>_<version>-<n>` (e.g., `shuffle-tools_1-2-0`, `email_1-3-0`, `http_1-4-0`, `shuffle-ai_1-1-0`, `shuffle-subflow_1-1-0`, `shufflehealthcheck_1-1-0`). `shuffle-workers` is non-versioned standalone (ghcr digest).
- EV-2 (VERIFIED): replicas vary (2 for app apps, 1 for workers); update order stop-first; on-failure pause.
- EV-3 (VERIFIED): only app apps carry the secret/bind; workers/backend do not.

## Backup-Rollback
n/a.

## Stop conditions
None.

## Limitations
No swarm-level label taxonomy beyond defaults observed; Orborus assigns internal labels (not enumerated). Service-recreation layer separate.

## Verdict rationale
Pattern documented from live services → DONE.
