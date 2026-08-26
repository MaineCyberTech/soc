# Phase 40-30: TLS Persistence Verification (PERS-40-02)

**Report ID:** phase40-30-tls-persistence
**Phase:** 40
**Title:** Phase 40-30: Shuffle TLS Closure Persistence — Recreate/Restart Proven, Reboot Scoped
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:01:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-30-tls-persistence.md`

---

Test ID PERS-40-02.

## 1. Compose-Defined Durability (proven during implementation)

The closure is compose-defined (`shuffle-tls-proxy` service + loopback frontend
publish), not ad-hoc `docker run`. Container-recreate survival was **proven live**
during the change itself: shuffle-frontend was recreated mid-operation from its pinned
digest and re-registered with the new `127.0.0.1:3001` binding automatically
[VERIFIED].

## 2. Proxy Restart Cycle — EXECUTED THIS SESSION (as directed)

```
$ docker inspect -f '{{.State.StartedAt}}' shuffle-tls-proxy      # pre
2026-08-26T00:53:41.467592897Z
$ docker restart shuffle-tls-proxy && sleep 3
shuffle-tls-proxy
$ docker inspect -f '{{.State.Status}} {{.State.StartedAt}}'
running 2026-08-26T01:59:31.68667663Z
$ curl -sk -o /dev/null -w 'http=%{http_code} time=%{time_total}s' https://192.168.222.149:3443/
http=200 time=0.005885s        # at 2026-08-26T01:59:34Z
```

Proxy restarts cleanly under `restart: unless-stopped` semantics and serves TLS
immediately after restart [VERIFIED].

## 3. Host-Reboot Scope — DEFERRED

Full host-reboot validation is **deferred to prompt 69's approved restart window**
(scheduled follow-up). Rationale: rebooting this LXC impacts unrelated production
services (Wazuh cluster, IRIS, Tenzir) and requires operator sign-off per AGENTS.md
approval gates. Compose definition + proven recreate/restart behavior make reboot
failure unlikely but UNVERIFIED until prompt 69 executes it.

## 4. Certificate Expiry Horizon

Cert valid to **2036-08-23** (10-year self-signed). Annual review cadence owned by
MCT SOC; renewal = documented one-command regen + proxy restart (phase40-27 §5).
No expiry-driven action required within the review horizon.

## 5. Recovery Access Intact

Post-change loopback check: `curl http://127.0.0.1:3001/` → `http=200` [VERIFIED,
01:59Z]. SSH-tunnel emergency lane preserved alongside backend `127.0.0.1:5001`.

Cross-refs: blocked tests phase40-29 · certification phase40-32 · reboot follow-up:
prompt 69.
