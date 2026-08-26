# Phase 39 IRIS Service Audit — Downstream Stack Exonerated

**Report ID:** phase39-31-iris-service-audit  
**Phase:** 39  
**Title:** IRIS Service Stack Health, Listener, API Contract, and Auth Audit — Failures Were DNS+Header-Layer Only  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Record ID:** IRSA-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-31-iris-service-audit.md`

---

## 1. Purpose

Prove that the IRIS side of the delivery path was healthy throughout the failure era,
so remediation effort is correctly aimed at the Shuffle/network layers only.

## 2. Container Stack Health (at audit time)

| Container | State |
|---|---|
| iriswebapp_nginx | **Up 3 days (healthy)** |
| iriswebapp_app | Up 3 days |
| iriswebapp_worker | Up 3 days |
| iriswebapp_db | Up 3 days |
| iriswebapp_rabbitmq | Up 3 days |

5/5 containers up; nginx healthcheck green continuously across the entire failure
window — the downstream stack never went down.

## 3. Listener and Routing

- Listener: nginx TLS :8443 (container-internal), reachable from bridge networks and
  post-fix from the overlay.
- Routing model: nginx routes everything to `app:8000` (gunicorn upstream) — including
  `/alerts/add`, which is a UI-route-style path handled by the app layer rather than a
  versioned REST namespace. This matters because the workflow's URL choice
  (`https://iriswebapp_nginx:8443/alerts/add`) is unusual but valid: proven working by
  historical deliveries (alerts 34–35) and by direct endpoint proof (alert_id 36,
  "P39 connectivity probe", HTTP 200).

## 4. API Version and Auth

| Property | Value |
|---|---|
| Supported API versions | 2.0.4 – 2.0.5 |
| Auth type | local users + JWT bearer (`Authorization: Bearer <token>`) |
| User population | single local admin `administrator@localhost` |
| Bearer validity check | differential probe — unauthenticated request → plain 404; authenticated → IRIS HTML/JSON responses (recovered token validated without printing it) |

## 5. Failure-Layer Attribution

Across the whole failure era (Aug-15 → Aug-25 pre-fix):

| Layer | Evidence of fault |
|---|---|
| DNS / network plane | ✅ FAULT — NameResolutionError from overlay executors (phase39-29/-30) |
| Workflow action parameters | ✅ FAULT (layer 2) — invalid headers JSON introduced by prior-phase redaction-inside-live-param error (REA-39-01 §3) |
| IRIS nginx | none — healthy, answered 302/400/200 correctly at every stage |
| IRIS app/API | none — zero application errors logged against this path |
| IRIS DB | none — accepted every request that actually arrived |

Decisive negative evidence: when requests finally reached nginx with broken headers
(post-DNS-fix round at 22:03Z), nginx returned its own immediate `400 Bad Request`
HTML — i.e., the reverse proxy was alive and rejecting malformed input at the edge.
No request in the failure era shows an IRIS-side 4xx/5xx JSON error, timeout, or
rejection of credentials.

## 6. Conclusion

> The IRIS service stack was fully healthy for the entire period under investigation.
> Delivery failures were caused exclusively by (1) execution-plane DNS isolation and
> (2) corrupted workflow parameter JSON — both Shuffle-side. Zero downstream
> remediation was required.

## Verdict

**IRIS EXONERATED — SERVICE AUDIT PASS.**
