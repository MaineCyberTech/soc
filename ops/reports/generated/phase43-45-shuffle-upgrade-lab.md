# Phase 43: Shuffle Upgrade Lab

**Report ID:** phase43-45-shuffle-upgrade-lab.md
**Phase:** 43
**Title:** Phase 43 Shuffle Upgrade Lab — Staging Environment
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T19:00:00Z
**Classification:** INTERNAL
**Status:** PLANNED (DEFERRED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-45-shuffle-upgrade-lab.md`

---

## 1. Lab Environment

| Component | Specification |
|---------|---------------|
| Isolation | Separate Docker network (`mct-lab`) |
| Resources | 4 vCPU, 8GB RAM, 50GB disk |
| Isolation | No production network access |
| Data | Synthetic test data only |

---

## 1. Lab Setup Commands

```bash
# Create isolated network
docker network create mct-lab

# Deploy Shuffle stack (target version)
docker compose -f lab/docker-compose.shuffle.yml up -d

# Verify health
curl -s http://localhost:5001/api/v1/health
curl -s http://localhost:3001/
```

---

## 2. Test Matrix

| Test | Command | Expected |
|-------|---------|----------|
| Health | `curl /api/v1/health` | 200 OK |
| Workflow create | POST /api/v1/workflows | 201 Created |
| execute_python | POST /api/v1/workflows/{id}/execute | Input variable injected |
| if_else_routing | POST /api/v1/workflows/{id}/execute | Routes correctly |
| HTTP app | POST /api/v1/workflows/{id}/execute | 200 OK to IRIS |

---

## 3. Rollback

```bash
docker compose -f lab/docker-compose.shuffle.yml down -v
docker network rm mct-lab
```

---

## 3. Status

**PLANNED (DEFERRED)** — Lab environment defined; execution deferred pending remediation decision (Option B).