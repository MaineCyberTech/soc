# Phase 39 Shuffle Persistence Validation — PERS-39-01

**Report ID:** phase39-19-shuffle-persistence
**Phase:** 39
**Title:** PERS-39-01 — Binding Persistence Across Lifecycle Events (Recreate Proven / Reboot Pending)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:58:00Z
**Classification:** INTERNAL
**Status:** PASS (reboot test documented as follow-up)
**Record ID:** PERS-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-19-shuffle-persistence.md`

---

## 1. What Must Persist

The hardening control is the compose publish bind
`"192.168.222.149:3001:80"` (line 21). Persistence question: does this control
survive container and host lifecycle events without manual re-application?

## 2. Evidence by Lifecycle Event

| Event | Status | Evidence |
|---|---|---|
| **Container recreate** (`docker rm -f` + `compose up -d`) | **PROVEN** | The apply itself (FW-39-01) was a full destroy/recreate; post-recreate `docker ps` shows `192.168.222.149:3001->80/tcp` and `ss` shows the pinned listener. The binding is declarative in compose, so every recreate inherits it. |
| **Backend restart** (token-cache flush earlier this phase) | **PROVEN non-interference** | shuffle-backend was restarted at ~22:12Z for rotation; frontend binding unaffected before and after; backend still loopback-only `127.0.0.1:5001`. Restart of one service did not disturb the other's publish state. |
| **Idempotent re-apply** (`up -d` with no changes) | PROVEN | `up -d` is the same command path used post-change; compose reconciles to file state = bind preserved. |
| **Full host/LXC reboot** | **NOT PERFORMED** | See §4 follow-up. Expected behavior reasoned but not yet evidenced on this guest. |

## 3. Workflow Health Post-Change

Execution pipeline unaffected by the binding change:

- 3 executions FINISHED earlier this phase (post-rotation window), including
  REAL OpenCanary deliveries into IRIS working end-to-end.
- Workflow inventory stable: 2 workflows (`high-severity-to-iris` test-mode,
  `flow-classb` draft).
- Engine components (orborus/workers/tools) communicate over docker networks,
  never through the published host port — structurally insulated from the
  change.

## 4. Follow-Up: Host Reboot Test (documented, not yet run)

Procedure to close the gap:

```bash
# after next planned maintenance reboot of the LXC guest:
docker compose --env-file .env -f compose/docker-compose.shuffle.yml up -d   # idempotent bring-up
ss -tlnp | grep ':3001'        # expect single line: 192.168.222.149:3001
curl -s -o /dev/null -w '%{http_code}\n' http://192.168.222.149:3001/      # expect 200
```

Optional belt-and-braces: verify no competing unit re-publishes :3001 with a
wildcard (`systemctl list-units | grep -i docker` sanity + repeat `ss`). If the
guest's docker daemon autostarts containers per their `restart: unless-stopped`
policy, even the explicit `up -d` should be a no-op confirmation.

Note: `restart: unless-stopped` means daemon restart alone restores containers;
the reboot test additionally proves the DHCP lease returns `.149` so the bind
target resolves (lease-dependency caveat from EXP-39-01 §7).

## 5. Verdict

**PASS** for all lifecycle events exercised (recreate, backend restart,
idempotent re-apply), with the host-reboot case explicitly scheduled as
follow-up rather than silently assumed.
