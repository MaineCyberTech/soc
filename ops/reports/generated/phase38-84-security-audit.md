# Phase 38-84: Security Audit Report

**Report ID:** phase38-84-security-audit
**Phase:** 38
**Title:** Phase 38-84: Security Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-84-security-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-84 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | FAIL |

**Status:** FAIL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-84-security-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Core platform listeners conform to the least-exposure matrix (indexer/API/dashboard all localhost-bound; agent ingest intentionally published). The stack FAILS on three fronts: (1) Shuffle frontend serves **plaintext HTTP on 0.0.0.0:3001** — confirmed by protocol handshake, no TLS anywhere on that path; (2) **plaintext credentials and a live bearer token are printed in 5 generated reports** despite no-secret attestations; (3) workflow export backups embed bearer references. Image supply-chain posture is good but incomplete (Wazuh + opensearch + alpine refs not digest-pinned).

## 2. Identities & Listeners vs Expected

`ss -tlnp` verified matrix:

| Port | Expected binding | Observed | Verdict |
|------|------------------|----------|---------|
| 9200 indexer | 127.0.0.1 | 127.0.0.1 | OK |
| 55000 Wazuh API | 127.0.0.1 | 127.0.0.1 | OK |
| 443 dashboard | 127.0.0.1 (via cloudflared externally) | 127.0.0.1 | OK |
| 1514/15140 agent ingest | 0.0.0.0 (nginx) | 0.0.0.0 | OK (by design) |
| 5001 shuffle backend | 127.0.0.1 | 127.0.0.1 | OK |
| **3001 shuffle frontend** | should be 127.0.0.1 or firewalled+TLS | **0.0.0.0, plaintext** | **FAIL (P0)** |
| portainer 8000/9443 | management ACL | 0.0.0.0 | review (P3) |
| opencanary 21/23/1433/3306/8008/9100 | intentional deception surface | 0.0.0.0 | OK (by design) |

## 3. TLS Absence on 3001 — Confirmed

```
$ curl -v http://127.0.0.1:3001 2>&1 | head -5
*   Trying 127.0.0.1:3001...
* Connected to 127.0.0.1 (127.0.0.1) port 3001
* using HTTP/1.x
> GET / HTTP/1.1
```

Plaintext HTTP/1.x handshake succeeds directly — no redirect to TLS, no `Secure` transport layer. Combined with the 0.0.0.0 bind and absence of host firewall rules for 3001, the frontend admin surface is reachable off-host in cleartext with basic-auth credentials (which are themselves exposed — §5). Remediation remains deferred in phase38-73 (Steps 2–4 pending operator approval). This is the single largest attack-surface item on the stack.

## 4. Credential File Permissions

Verified modes WITHOUT reading contents:

```
-rw------- user user  671 /opt/mct-security-stack/.env                      (600 ✓)
-rw------- root root 1098 /opt/wazuh-docker/multi-node/wazuh-local.env      (600 ✓)
-rw------- user user   17 /opt/mct-security-stack/ops/backups/iris-admin-pw.txt  (600 ✓)
-rw------- user user   65 /opt/mct-security-stack/ops/backups/iris-api-key.txt   (600 ✓)
-rw------- user user   40 /opt/mct-security-stack/ops/backups/misp-api-key.txt   (600 ✓)
```
PASS — mode 600 across all checked stores.

## 5. Token Disclosure in Generated Reports (P0)

Confirmed at cited locations:
- `phase38-00-master.md:63` — dashboard/basic auth password in clear ([REDACTED cred pair])
- `phase38-01-preflight.md:131` — Shuffle bearer token literal
- `phase38-73-shuffle-hardening.md` §Step 1 — migration invocation embedding credential arguments

Corpus sweep: 5 files match credential patterns (00, 02, 13, 50, 90). These reports sit inside the v1.3.0 release tree scope (release manifest claims `sensitive_files: 0` — contradicted; see phase38-89 D-07). Required: redaction pass + rotation of the Shuffle bearer token and dashboard password. Until rotated, treat both as compromised-if-repo-shared.

## 6. Workflow Auth

- Live API requires bearer auth (anonymous `/api/v1/workflows` → `{"success": false}`); backend correctly rejects unauthenticated calls.
- BUT: all 5 archived workflow exports under `ops/backups/shuffle-workflows/*.json` contain exactly 1 bearer reference each → flagged. Exports must be scrubbed or moved into the 600-only secret store.

## 7. Synthetic Isolation

N/A this cycle — no isolated packet-capture workflow exists yet (phase38-75/76 designed but not deployed). The two production workflows are webhook-triggered from Wazuh integrations only.

## 8. Supply Chain — Image Digest Pinning

From compose grep (P36 verification state):

| Image | Pinning |
|-------|---------|
| ghcr.io/shuffle/{frontend,backend,orborus} | ✅ sha256 digest-pinned |
| thinkst/opencanary | ✅ pinned |
| elastiflow/flow-collector | ✅ pinned |
| nginx:stable, python:3-alpine, balabit/syslog-ng | ✅ pinned |
| wazuh/wazuh-{manager,indexer,dashboard}:4.14.7 | ⚠ tag only |
| opensearchproject/opensearch:3.2.0 | ⚠ tag only |
| alpine:3.20 | ⚠ tag only (used by healthcheck sidecars) |

Status: PARTIAL — mutable tags remain on the highest-value platform images (Wazuh/indexer), though version-pinned to 4.14.7. Digest pinning of the three tagged families is backlog P3.

## 9. Classification & Provenance

- Report corpus carries classification headers; generated ops reports marked Internal/Operational.
- Provenance: git repo at `/opt/mct-security-stack` clean lineage through v1.3.0 tag (2026-08-24); release bundle SHA256 recorded (`da72bde…`).
- Evidence preservation: zero deletions of reports or indices this phase (ISM delete not yet triggered).

## 10. Disposition Summary

| Finding | Severity | Action owner |
|---------|----------|--------------|
| 3001 plaintext exposure | P0 | SOC lead — execute phase38-73 Steps 2–4 |
| Creds/bearer in 5 generated reports | P0 | SOC lead — redact + rotate |
| Bearer refs in workflow exports | P1 | SOC — scrub exports |
| Tag-only pins (wazuh/opensearch/alpine) | P3 | Platform — extend P36 pinning |

---
*No secrets reproduced beyond file:line pointers already flagged.*
