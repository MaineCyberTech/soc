# Phase 55: Bind Mount Consumers

**Prompt:** 054-bind-consumers
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Enumerate every filename/workflow with access to the legacy `/shuffle-files` bind (and its relationship to the secret). Read-only inspection confirms: exactly one Docker consumer of the secret (and thus the bind), and that the packet-routing workflow references BOTH the secret path and the bind path. The bind is broader-surface than the secret (whole files tree vs single mounted file).

## Evidence
- EV-06 (VERIFIED): Docker scan — only `shuffle-tools_1-2-0` consumes `iris-shuffle-env` (and is the sole mount of the `/shuffle-files` bind).
- EV-01 (VERIFIED): Bind mount `Source=/opt/mct-security-stack/data/shuffle/files → Target=/shuffle-files, ReadOnly=true`. Whole directory shared, not just the token file.
- EV-03 (VERIFIED): Runtime shows `/shuffle-files/iris-shuffle.env` (0600, 78B) present alongside `/run/secrets/iris-shuffle.env` (0444).
- EV-04 (VERIFIED): Workflow `suricata-packet-routing` (`e133a645-...`, active) contains both `/run/secrets/iris-shuffle.env` AND `/shuffle-files/iris-shuffle.env` inside `load_iris_token` — i.e., it is the only workflow consuming the bind, and only as a documented fallback. Class-A (`eb937a37-...`) does NOT reference either path (HTTP-app header wiring).

## Backup-Rollback
Bind removal (future, gated) rollback = re-add the bind via `docker service update --mount-add type=bind,source=/opt/mct-security-stack/data/shuffle/files,target=/shuffle-files,readonly` (see 058).

## Stop conditions
Bind removal/change is a service-update change requiring approval (see 056/057). Enumeration here is read-only and complete.

## Limitations
Bind consumers enumerated at the container + workflow level. Cross-service or host-level readers of `/opt/mct-security-stack/data/shuffle/files` are out of container scope (host perms: directory 0755, file 0600 owned by `user`).

## Verdict rationale
DONE — every consumer enumerated and VERIFIED: one container (`shuffle-tools_1-2-0`), one workflow (`suricata-packet-routing`) referencing the bind strictly as a fallback.
