# Phase 55: Execution Service Spec

**Prompt:** 027-service-inspect
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Inspect the execution service `shuffle-tools_1-2-0` spec: image digest, replicas, update config, mounts, secrets, labels, constraints.

## Evidence
- **EV-027-1 (VERIFIED):** Service ID `po8aaadaybgj6viyqmdvva8ii`, Name `shuffle-tools_1-2-0`, Mode Replicated, Replicas 2/2.
- **EV-027-2 (VERIFIED):** Image `frikky/shuffle:shuffle-tools_1.2.0` (no digest pin observed in spec; referenced by tag).
- **EV-027-3 (VERIFIED):** UpdateConfig: Parallelism 1, On failure pause, Monitoring Period 5s, Max failure ratio 0, Update order stop-first. RollbackConfig: same shape (pause on failure, stop-first).
- **EV-027-4 (VERIFIED):** Mounts: bind `/opt/mct-security-stack/data/shuffle/files` → `/shuffle-files` (ReadOnly true). Secrets: `iris-shuffle-env` → `/run/secrets/iris-shuffle.env` (mode 0444).
- **EV-027-5 (VERIFIED):** Networks `t1rv43olc7ev4hvpjpnqzp469`; published port 33334/tcp (ingress). No placement constraints; no resource limits set.

## Backup-Rollback
Read-only. No change.

## Stop conditions
None.

## Limitations
Image is tag-referenced, not digest-pinned in the live spec (durability note, not a P55 change).

## Verdict rationale
Service spec fully inspected; secret grant and fallback bind mount both present as expected. DONE.
