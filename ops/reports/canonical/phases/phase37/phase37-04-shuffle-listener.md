# Phase 37 — Shuffle Listener Inventory

**Date:** 2026-08-25T19:28Z

---

## Listener Inventory

| Component | Bind Address | Port | Protocol | TLS | Authentication |
|-----------|-------------|------|----------|-----|----------------|
| Frontend (UI) | 0.0.0.0 | 3001 | HTTP | No | No (login page served) |
| Backend (API) | 127.0.0.1 | 5001 | HTTP | No | Bearer token |

---

## Network Exposure

### Frontend (0.0.0.0:3001)

| Attribute | Value |
|-----------|-------|
| Binding | 0.0.0.0 (all interfaces) |
| Reachable from | Any network with route to host |
| Firewall rules | None |
| Reverse proxy | None |
| TLS termination | None |
| Brute force protection | None |

### Backend (127.0.0.1:5001)

| Attribute | Value |
|-----------|-------|
| Binding | 127.0.0.1 (localhost only) |
| Reachable from | Same host only |
| External exposure | No |

---

## Docker Networking

| Network | Containers |
|---------|------------|
| mct-security | Shuffle frontend, Shuffle backend, supporting services |
| multi-node_default | OpenSearch nodes, Wazuh manager |

---

## Source Networks

| Source | Access |
|--------|--------|
| All networks | Frontend port 3001 reachable |
| Localhost only | Backend port 5001 |

---

## Authentication

| Method | Status |
|--------|--------|
| Bearer token | ✅ Functional |
| Session cookie | Set on login (contains token) |
| TLS | ❌ Not deployed |
| IP allowlist | ❌ Not configured |

---

## Current Risk Posture

| Risk | Severity | Status |
|------|----------|--------|
| Plaintext HTTP on all interfaces | HIGH | Active |
| No TLS | HIGH | Active |
| No firewall on 3001 | HIGH | Active |
| No brute force protection | MEDIUM | Active |
| Session token in plaintext cookie | MEDIUM | Active |

---

## No secrets
