# Phase 43: Security Audit

**Report ID:** phase43-90-security-audit.md
**Phase:** 43
**Title:** Phase 43 Security & Supply-Chain Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-90-security-audit.md`

---

## 1. Rotation & Credential Posture

| Item | Status | Evidence |
|------|--------|----------|
| Shuffle Bearer | ROTATED (old→401, new→200) | Phase42-06/07 |
| Shuffle API Key | Stored in `config/shuffle-api-key` (600, gitignored) | Verified |
| VT Key (Master) | REAL (64-char hex); container 640 ✓; host 640 pending | Verified |
| VT Key (Worker) | None | Verified |
| Wazuh API Key | Placeholder `SHUFFLE_API_KEY_PLACEHOLDER` in ossec.conf | Verified (both nodes) |
| GH Token | **PRESENT** in creds.env (`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`) | Verified |
| DO Spaces Keys | Present in creds.env | Verified |

---

## 2. Listeners & TLS

| Listener | TLS | Auth | Exposure |
|----------|-----|------|----------|
| Shuffle Frontend (3443) | TLS 1.2/1.3 | Basic (Bearer) | Mgmt IP only |
| Shuffle Frontend (3001) | No | None | Loopback only |
| Shuffle Backend | No | Bearer | Loopback only |
| OpenSearch | Yes (mutual TLS) | Basic | Loopback |
| Wazuh API | Yes | Basic | Loopback |
| Wazuh Agent | Yes (SSL) | Cert | 0.0.0.0:1514 |
| IRIS | TLS (nginx) | Basic | Mgmt IP |

---

## 3. Credential Handling

| File | Mode | Owner | Gitignored |
|------|------|-------|------------|
| `config/shuffle-api-key` | 600 | root | Yes |
| `/opt/wazuh-docker/multi-node/ops/creds.env` | 600 | root | Yes |
| `.env` (root) | 600 | root | Yes |
| `ossec.conf` (master) | 640 | root | No (tracked in wazuh-docker) |
| `ossec.conf` (worker) | 640 | root | No (tracked in wazuh-docker) |

---

## 4. Supply Chain

| Component | Pinning | Verification |
|----------|---------|--------------|
| Shuffle Frontend | `ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f...` | Digest pinned |
| Shuffle Backend | `ghcr.io/shuffle/shuffle-backend@sha256:...` | Digest pinned |
| Nginx TLS Proxy | `nginx:1.27-alpine@sha256:46ccc48f...` | Digest pinned |
| OpenSearch | `opensearchproject/opensearch:2.11.0` | Tag pinned |
| Wazuh | `wazuh/wazuh:4.7.0` | Tag pinned |

---

## 5. Residual Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Shuffle API token leak | Low | High | Rotated; stored 600 gitignored |
| VT key in ossec.conf | Low | Medium | Container 640; host 640 pending |
| Shuffle webhook unauthenticated (LAN) | Medium | Medium | Network restricted to mgmt IP |
| Self-signed TLS (Shuffle) | Low | Low | TOFU; fingerprint pinned |
| GH Token in creds.env | Low | High | Scoped to repo; rotation runbook |

---

## 5. Status

**COMPLETE** — Security audit complete; residual risks documented and tracked.