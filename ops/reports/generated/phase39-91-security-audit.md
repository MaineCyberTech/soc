# Security Audit SEC-39-02

**Report ID:** phase39-91-security-audit
**Phase:** 39
**Title:** Security Audit SEC-39-02 — Token/Redaction Verification, Listener & TLS Posture, Credential Handling, Classification, Supply Chain, Residual Risks
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:18:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-91-security-audit.md`

---

## 1. Token Rotation Verification (recap)

Rotation executed phase39-06/-07 with old-token→401 proof on record and workflow re-auth
(phase39-08). Live corroboration today: API calls authenticate exclusively via the rotated bearer
sourced from `config/shuffle-api-key` at runtime; three consecutive `/api/v1/workflows` probes
returned HTTP 200 (~1.4–2.2 ms). No plaintext token appears in any session output.

## 2. Redaction Completeness

Tracked-tree grep counts for both credential families: **zero** in generated corpus content
(p38-report-ci secret_lines=0 across files=97; p39-canonical-ci Gate4 high-confidence 0 hits
tree-wide). Remaining pattern-array literals are detection regexes only (verified phase39-89 §4).
Historical leak sites redacted under phase39-09/-11 with re-hash.

## 3. Listeners / TLS Posture

| Port | Bind | Posture |
|---|---|---|
| 3001 | `192.168.222.149` | Plaintext on **management LAN** — accepted-risk, documented; firewall applied (phase39-15); TLS deferred to P40 proxy (OW-39-01) |
| 5001 | `127.0.0.1` | Backend loopback-only ✓ |
| 9200 | `127.0.0.1` (nginx-fronted cluster TLS) | auth required + TLS ✓ |
| 443 | `127.0.0.1` local cloudflared edge | public ingress via CF tunnel ✓ |

No wildcard reappearances since hardening apply; unauthorized-access test negative (phase39-18).

## 4. Credential Handling

```
$ ls -la config/shuffle-api-key        → -rw------- 600
$ git check-ignore config/shuffle-api-key compose/.env → both matched, GITIGNORED-OK
$ ls -la /opt/wazuh-docker/multi-node/ops/creds.env → -rw------- 600 (outside repo)
```

VERIFIED: secrets referenced by path only in all new reports; no values printed this session.
Compose validation fails closed without env interpolation (phase39-89 §7) — correct posture.

## 5. Report Classification Compliance

INTERNAL defaults enforced by CI metadata gate. Client-safe separation spot-check:
`canonical/current/final-phase38-operator-report…` lineage keeps the client scorecard in a
dedicated section — phase38-92-scorecard.md **§5 CLIENT-SAFE SCORECARD** contains sanitized
metrics tables only (fleet counts, service-period outcomes), no credentials, no internal paths of
sensitivity. PASS.

## 6. Workflow Auth

IRIS bearer lives only in the Shuffle datastore (recovered-copy redacted during DNS remediation
arc, phase39-32/-33); scripts consume it from protected file paths, never inline. Live-only
principle held throughout this phase's delivery checks.

## 7. Supply Chain

Image pins from P36 program hold: spot-verified digests —
`wazuh/wazuh-manager:4.14.7` = `sha256:c364ef100ba4…`, `ghcr.io/dfir-iris/iriswebapp_app:v2.4.29`
= `sha256:d7d23026bdde…`. Unpinned-image gate rerun green (policy exceptions documented).

## 8. Rules / Licenses

Suricata ruleset remains **ET Open (GPL)** — free tier, no subscription feed configured; licensing
permits internal commercial use without redistribution obligations. Note carried unchanged;
subscription upgrade is a budget decision, not a security gap.

## 9. Provenance

Release v1.3.0 archive in `ops/releases/v1.3.0/` carries REBUILT-ARTIFACT label with explicit
DIFFERENCE-FROM-PUBLISHED warning (rebuilt sha256 `65f794a7…` ≠ published `da72bde4…`; tree,
commit, tag object pinned). Honesty model compliant — no equivalence overclaimed.

## 10. Synthetic Isolation

Packet workflow runtime BLOCKED by routing decision (phase39-42); import-ready artifact only.
No synthetic events touched production counters, cases, or billing this phase. N/A-clean.

## 11. Residual Risks (ranked, owned)

| # | Risk | Sev | Owner | Ref |
|---|---|---|---|---|
| R1 | Shuffle UI plaintext on mgmt LAN until TLS proxy | MED | SOAR ops (P40) | OW-39-01 |
| R2 | Published-asset original not yet retrieved/pinned | LOW-MED | Release owner | OW-39-02 |
| R3 | Auto-routing disabled → manual-lane dependency for real alerts | MED | SOAR+Detection | BCK-38-006 |
| R4 | merged.mg perms defect noise (log flooding masks other errors) | LOW-MED | Wazuh config owner | BCK-38-012 |
| R5 | ET Open signature lag vs subscription | LOW | Detection owner | standing note |

Verdict: **PASS with accepted risks** — every residual item owned and scheduled.
