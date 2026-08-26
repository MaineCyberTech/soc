# Phase 39 DNS Path Audit — IRIS Name Resolution Across Execution Environments

**Report ID:** phase39-30-dns-path-audit  
**Phase:** 39  
**Title:** Resolver Comparison and Network Topology Audit — Why `iriswebapp_nginx` Resolved Everywhere Except Where Executions Actually Run  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Record ID:** DNS-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-30-dns-path-audit.md`

---

## 1. Scope

Audit every DNS resolution path between Shuffle execution components and
`iriswebapp_nginx` (IRIS nginx, TLS :8443), identify the exact plane where resolution
breaks, and record reachability proofs pre/post remediation.

## 2. Resolver Comparison Table

| # | Context | Resolver | Search/ndots | `iriswebapp_nginx` result (pre-fix) | Mechanism |
|---|---|---|---|---|---|
| R1 | Host | systemd-resolved 127.0.0.53 | host defaults | resolves (bridge-scoped Docker DNS entries) | host-level |
| R2 | shuffle-backend | embedded DNS 127.0.0.11 | search mainecybertech.com ndots:0 | ✅ 172.20.0.7 | shared mct-security bridge membership |
| R3 | shuffle-orborus | 127.0.0.11 | same | ✅ bridge IP | mct-security membership |
| R4 | shuffle-workers | 127.0.0.11 | same | ✅ bridge IP | mct-security membership |
| R5 | **HTTP app containers** (execution env) | 127.0.0.11 on **overlay** | same resolv.conf template | ❌ **NXDOMAIN** | no shared network with IRIS |
| R6 | Test container on `shuffle_swarm_executions` (pre-fix) | 127.0.0.11 | same | ❌ NXDOMAIN | reproduces R5 |

Post-fix state of R5/R6: ✅ alias `iriswebapp_nginx` → **10.224.224.66** on the overlay
(see phase39-33 for apply evidence).

Observed quirk worth recording: busybox `nslookup <name>` inside an overlay container
first probes `<name>.mainecybertech.com` (search-domain expansion) and surfaces that
NXDOMAIN; a direct query against 127.0.0.11 for the bare name returns the Docker-managed
alias. glibc-style `getent hosts` (what Python/urllib3 ultimately uses) resolves the
bare name directly — so R5's NXDOMAIN was genuine pre-fix and its post-fix success is
genuine too.

## 3. Network Topology Diagram

```
                        HOST (systemd-resolved 127.0.0.53)
                                      │
        ┌─────────────────────────────┼──────────────────────────────┐
        │                             │                              │
 ┌──────▼──────────┐        ┌─────────▼─────────┐         ┌──────────▼──────────────┐
 │ bridge:         │        │ bridge:           │         │ swarm overlay:          │
 │ mct-security    │        │ iris_frontend /   │         │ shuffle_swarm_executions│
 │ 172.20.0.0/x    │        │ iris_backend      │         │ 10.224.224.0/24         │
 │                 │        │ (IRIS-internal)   │         │ attachable, scope=swarm │
 ├─────────────────┤        ├───────────────────┤         ├─────────────────────────┤
 │ shuffle-backend │        │ iriswebapp_nginx  │         │ HTTP app containers     │
 │  .x  ←─DNS ok──▶│        │  172.22.0.2       │         │  (spawned per action)   │
 │ orborus         │        │ iriswebapp_app    │         │ shuffle-workers         │
 │ workers         │        │ worker/db/rabbitmq│         │  (task containers)      │
 │ iriswebapp_nginx│        └───────────────────┘         │ + POST-FIX ATTACH:      │
 │  172.20.0.7     │                                     │  iriswebapp_nginx       │
 └────────▲────────┘                                     │  = 10.224.224.66 (alias)│
          │                                              └─────────────────────────┘
          └── backend/orborus/workers ALSO on mct-security:
              they resolve IRIS fine — but they do NOT execute HTTP actions.
```

Key asymmetry: **control-plane components (backend/orborus/workers) live on bridges
where IRIS is present; data-plane components (HTTP app containers) are spawned on the
overlay where IRIS was absent.** Healthchecks therefore passed while deliveries failed.

## 4. Overlay Facts (docker network inspect)

```
Name:        shuffle_swarm_executions
Driver:      overlay
Subnet:      10.224.224.0/24
Attachable:  true
Scope:       swarm
```

The `attachable=true` property is what makes the minimal remediation possible without
touching Swarm services or IRIS compose (see phase39-32).

## 5. Root Cause Statement

> The workflow's HTTP actions execute inside per-action app containers spawned on the
> Swarm overlay network `shuffle_swarm_executions`, which shares no attachment with any
> network hosting `iriswebapp_nginx`. Docker's embedded DNS only resolves names across
> networks both endpoints are attached to; hence `[Errno -2] Name does not resolve`
> from exactly that environment while every other component resolved normally.

Secondary layer discovered after the DNS fix (invalid headers JSON in the action
parameters, prior-phase redaction artifact) is documented in REA-39-01/G6 and does not
belong to this report's layer.

## 6. Reachability Proofs

### Pre-fix (baseline)

```
$ docker run --rm --network shuffle_swarm_executions busybox nslookup iriswebapp_nginx
** server can't find iriswebapp_nginx... NXDOMAIN
```

Workflow evidence: 28 retained executions with `ConnectionError … NameResolutionError`,
era Aug-10T20:51Z → Aug-25T07:13Z (phase39-29 §3).

### Post-fix (re-verified live at report time)

```
$ docker run --rm --network shuffle_swarm_executions curlimages/curl \
    sh -c 'getent hosts iriswebapp_nginx; curl -sk -o /dev/null -w "%{http_code} in %{time_total}s\n" https://iriswebapp_nginx:8443/'
10.224.224.66     iriswebapp_nginx  iriswebapp_nginx
HTTPS 302 in 0.010906s
```

Resolver states across components at report time:

| Component | getent result |
|---|---|
| shuffle-backend | 172.20.0.7 (bridge path) |
| shuffle-orborus | 10.224.224.66 (overlay alias wins for dual-homed targets) |
| shuffle-workers task | 10.224.224.66 |
| overlay test container | 10.224.224.66 + TLS reachable |

## 7. Findings

1. F1: single-plane isolation failure — overlay executors vs bridge-resident target.
2. F2: monitoring blind spot — health checks from bridge-resident components cannot
   prove execution-plane reachability; ALERT-39-01 closes the loop by watching real
   delivery outcomes instead.

## Verdict

**AUDIT COMPLETE.** Root cause confirmed and localized; pre/post proofs recorded;
remediation handed off to NET-39-01.
