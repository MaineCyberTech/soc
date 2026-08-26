# Phase 39 DNS Remediation Apply Record — NET-39-01-APPLY

**Report ID:** phase39-33-dns-remediation-apply  
**Phase:** 39  
**Title:** NET-39-01-APPLY — Overlay Network Attach Executed, Validated From the Exact Execution Environment, Status APPLIED  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** PASS (applied)  
**Record ID:** NET-39-01-APPLY  
**Author:** opencode/ox-alpha  
**Owner:** MCT SOC (automation: opencode/ox-alpha)  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-33-dns-remediation-apply.md`

---

## 1. Change Executed (ops window 2026-08-25 ~22:00Z)

```bash
docker network connect shuffle_swarm_executions iriswebapp_nginx \
    --alias iriswebapp_nginx
# → success (no output; exit 0)
```

No restarts performed. nginx remained `Up 3 days (healthy)` throughout.

## 2. Attach Verification

`docker inspect iriswebapp_nginx` network summary at report time:

```
iris_backend               = 172.23.0.3   aliases:[iriswebapp_nginx nginx]
iris_frontend              = 172.22.0.2   aliases:[iriswebapp_nginx nginx]
mct-security               = 172.20.0.7   aliases:[iriswebapp_nginx nginx]
shuffle_swarm_executions   = 10.224.224.66 aliases:[iriswebapp_nginx]   ← NEW
```

Overlay inspect facts:

```
Name: shuffle_swarm_executions  Driver: overlay
Subnet: 10.224.224.0/24  attachable=true  scope=swarm
```

## 3. Validation — From the EXACT Execution Environment

The execution environment for workflow HTTP actions is a container attached to
`shuffle_swarm_executions`. Validation therefore runs in that same plane:

### 3.1 DNS resolution from overlay-attached test container

```
$ docker run --rm --network shuffle_swarm_executions curlimages/curl getent hosts iriswebapp_nginx
10.224.224.66     iriswebapp_nginx  iriswebapp_nginx     ← RESOLVES
```

Embedded-DNS direct query cross-check (busybox):

```
$ docker run --rm --network shuffle_swarm_executions busybox nslookup iriswebapp_nginx 127.0.0.11
Non-authoritative answer:
Name:	iriswebapp_nginx
Address: 10.224.224.66
```

### 3.2 HTTPS reachability from the same plane

```
$ docker run --rm --network shuffle_swarm_executions curlimages/curl \
    sh -c 'curl -sk -o /dev/null -w "%{http_code} in %{time_total}s\n" https://iriswebapp_nginx:8443/'
302 in 0.010906s        ← nginx alive and answering TLS on :8443
```

### 3.3 Control-plane components unaffected

| Component | getent result | Path |
|---|---|---|
| shuffle-backend | 172.20.0.7 | bridge (unchanged) |
| shuffle-orborus | 10.224.224.66 | overlay alias |
| shuffle-workers task | 10.224.224.66 | overlay alias |

## 4. Acceptance Criteria Status

| # | Criterion (phase39-32 §8) | Result |
|---|---|---|
| 1 | connect succeeds | ✅ exit 0 |
| 2 | overlay resolution of name | ✅ 10.224.224.66 |
| 3 | HTTPS probe from exec plane | ✅ 302 (nginx alive) |
| 4 | end-to-end delivery | ⚠ discovered blocked by layer-2 (invalid headers JSON) — fixed separately same window; final proof in DLV-39-01 |

## 5. Direct Endpoint Proof (post layer-2 repair)

```
POST https://iriswebapp_nginx:8443/alerts/add   (from app-network plane,
Bearer auth, JSON body) → HTTP 200 {"status":"success"}, alert_id 36 created
("P39 connectivity probe")
```

## 6. Runbook (repeatable procedure)

1. Verify overlay exists/attachable: `docker network inspect shuffle_swarm_executions`.
2. If `iriswebapp_nginx` absent: apply connect command (§1) with alias.
3. Validate §3.1–3.3.
4. Trigger one API execution and confirm IRIS row (or run
   `ops/scripts/p39-iris-delivery-check.sh`).
5. If stack re-created later: re-run step 2 OR land the compose change
   (phase39-32 §4) to make it permanent.

Rollback remains one command: `docker network disconnect shuffle_swarm_executions iriswebapp_nginx`.

## Verdict

**APPLIED AND VALIDATED.** Layer-1 closed; residual compose hardening tracked as
condition (a) of ROUT-39-01.
