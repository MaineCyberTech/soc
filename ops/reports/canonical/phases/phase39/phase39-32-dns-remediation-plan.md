# Phase 39 DNS Remediation Plan — NET-39-01

**Report ID:** phase39-32-dns-remediation-plan.md  
**Phase:** 39  
**Title:** NET-39-01 — Minimal Durable Fix for Execution-Plane Resolution of `iriswebapp_nginx` (Overlay Attach with Alias)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** APPROVED-FOR-APPLY → superseded by phase39-33 (APPLIED)  
**Record ID:** NET-39-01  
**Author:** opencode/ox-alpha  
**Owner:** MCT SOC (automation: opencode/ox-alpha)  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-32-dns-remediation-plan.md`

---

## 1. Problem Statement

HTTP action containers execute on the Swarm overlay `shuffle_swarm_executions`
(10.224.224.0/24); IRIS nginx lives only on bridges (`iris_frontend`, `iris_backend`,
`mct-security`). Docker embedded DNS does not cross unshared networks →
`NameResolutionError` for every delivery attempt in the failure era.

## 2. Chosen Fix

```
docker network connect shuffle_swarm_executions iriswebapp_nginx \
    --alias iriswebapp_nginx
```

Attach the existing IRIS nginx container to the attachable overlay, keeping its
service name as a Docker-managed alias on that network. Result: executors resolve
`iriswebapp_nginx` via embedded DNS to the new overlay IP (observed 10.224.224.66).

### Why this qualifies as minimal + durable

| Property | Assessment |
|---|---|
| Survives container restart | ✅ network attachments persist across restarts/recreates of the attached container's lifecycle events short of re-create; documented residual: full `docker rm/run` re-creation requires re-attach (→ compose hardening, §6) |
| No hardcoded IPs | ✅ alias-based resolution; IP assignment by Docker |
| Name preserved | ✅ `--alias iriswebapp_nginx` keeps workflow URL unchanged |
| Blast radius | ✅ one container gains one interface; no Swarm service edits; IRIS keeps all three bridge memberships |
| Reversible | ✅ single `docker network disconnect` |

## 3. Alternatives Considered and Rejected

| Alternative | Why rejected |
|---|---|
| Hosts-entry injection into app images / exec containers | fragile: per-execution ephemeral containers, image rebuilds, fights Docker DNS; breaks silently again |
| Rewrite workflow URL to an overlay IP (e.g., https://10.224.224.66:8443) | anti-pattern: pins dynamic IP into config, breaks TLS SNI/cert name matching, breaks on any re-allocation |
| Move IRIS fully onto the overlay | bigger blast radius: touches IRIS compose topology, swarm dependency for core DFIR service, wider security surface; disproportionate to the fault |
| Publish IRIS :8443 on host and target host gateway from executors | adds host-port exposure + NAT path; new firewall surface; still not name-consistent |

## 4. Configuration Source of Record

- Applied via docker CLI (phase39-33).
- **Compose adoption (follow-up hardening, P40 backlog):** add to the IRIS compose
  service definition:

```yaml
services:
  iriswebapp_nginx:
    networks:
      iris_frontend: {}
      iris_backend: {}
      mct-security: {}
      shuffle_swarm_executions:
        aliases:
          - iriswebapp_nginx

networks:
  shuffle_swarm_executions:
    external: true
```

This makes the attach survive full stack re-creation and removes the manual step
from disaster-recovery runbooks.

## 5. Restart Scope

None required at apply time. `docker network connect` hot-attaches; no container or
stack restarts; zero user-visible downtime (verified: nginx healthy throughout).

## 6. Rollback

```
docker network disconnect shuffle_swarm_executions iriswebapp_nginx
```

Reverts resolution state exactly; no other config touched. Post-condition check:
overlay resolution returns to NXDOMAIN, bridge paths unaffected.

## 7. Monitoring

Delivery-failure alerting ALERT-39-01 (phase39-35) watches actual execution outcomes —
the same class this fix addresses would be detected within one poll cycle instead of
accumulating silently for 10 days. Runbook pointer: phase39-33 §validation.

## 8. Acceptance Criteria for Apply

1. `docker network connect` succeeds.
2. Overlay-attached test container resolves `iriswebapp_nginx`.
3. HTTPS probe from execution plane reaches nginx (2xx/3xx).
4. Real workflow executions deliver end-to-end (deferred to DLV-39-01 because layer-2,
   parameter corruption, was discovered during validation).

## Verdict

**PLAN APPROVED (NET-39-01).** Minimal, durable, reversible; applied under
NET-39-01-APPLY (phase39-33).
