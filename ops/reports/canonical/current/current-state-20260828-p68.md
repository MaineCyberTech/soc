# Current State — MCT Security Stack (2026-08-28, Phase 68)

**Scope:** Canonical current-state after Phase 68 (540-report hardening pack).
**Supersedes:** `current-state-20260828-p67.md` (per its own supersession statement).
**Superseded by:** any newer `current-state-2026*.md`.

## 0. TL;DR

The Class-A Wazuh→IRIS route is **functional and proven** (genuine event + IRIS object 149
read-back VERIFIED, marker parity VERIFIED). Phase 68 hardens it. Bounded **retry + dead-letter
are WIRED** (Phase 67). The remaining hardening items — least-privilege IRIS credential, internal
TLS (remove `verify=False`), source-event idempotency, and re-certification after
task/container recreation — are **DESIGNED / DEFERRED (approval-gated)** and recorded honestly;
they are NOT fabricated as implemented.

## 1. Truth Baseline (verified, persistent)

| Leg | Evidence | Status |
|---|---|---|
| Wazuh alert | genuine `1787948087.9767291` (rule 100065) | VERIFIED |
| integratord | HTTP 200 | VERIFIED |
| Shuffle hook | `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` | VERIFIED |
| Class-A workflow | `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` | VERIFIED |
| Shuffle execution | `593b3840-0565-4d46-8574-c676cc7f54a8` | VERIFIED |
| IRIS POST | HTTP 200 | VERIFIED |
| IRIS object | **149** (tags `source:wazuh,class:A`) | VERIFIED read-back |
| Marker parity | unique Class-A Wazuh marker | VERIFIED |

IRIS contains live objects **140–149** (`source=wazuh`). The erroneous "broken leg" finding from
earlier was corrected in Phase 66 and is **not** re-opened here.

## 2. Implemented This Phase (carried from P67)

- **Bounded retry + durable dead-letter + failure alerting** — wired into the Class-A workflow
  (`execute_python`, OpenSearch doc `c6b3fcd8`). 3 attempts, exponential backoff; on exhaustion
  `state=DEAD_LETTER` is recorded. Success path unchanged.
  Backup: `ops/backups/workflow-c6b3fcd8-20260828T223000Z.json` (gitignored).
- Evidence JSONs: `p68-correlation.json`, `p68-markers.json`, `p68-retry.json`.

## 3. Designed / Deferred (NO-GO without sign-off)

| Item | Target | Blocker / Why deferred |
|---|---|---|
| Least-privilege IRIS service account | scoped key replaces admin key (prefix c21731) | needs IRIS RBAC + swarm-secret rotate (recreates shuffle-tools); approval-gated |
| Internal TLS (remove `verify=False`) | internal CA + IRIS cert; `verify=True` | needs internal CA; `verify=False` exception recorded |
| Source-event idempotency | idempotency from Wazuh rule/alert id (not exec id) | IRIS list API 500s blocks pre-check |
| Guarded replay / recovery-replay | approved, audited, duplicate-safe | list API 500 blocks replay-guard enforcement |
| Re-certification after task/container recreation | re-run genuine→IRIS proof | approval-gated; not performed to avoid disrupting verified delivery |

Packet production remains **UNAUTHORIZED**; DR remains **DEFERRED**.

## 4. Open / Gated (NO-GO without sign-off)

| ID | Pri | Title | Status | Owner |
|---|---|---|---|---|
| OW-67-01 | P2 | Least-privilege IRIS credential + internal TLS + idempotency | OPEN — DESIGN only (retry/dead-letter done) | IRIS/SOAR ops |
| OW-40-05 | P1 | RTO/RPO sign-off | AWAITING-SIGNATURE | Platform + SOC lead |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO | Infra + SOC lead |
| OW-40-04 | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE | SOAR ops + Detection |
| OW-42-01 | P1 | Indexer disk-threshold policy decision (R-DISKBYPASS) | NEW-P42 | Wazuh/indexer config owner |
| OW-42-02 | P2 | v1.3.1 release-page publication | TOKEN-BLOCKED | MCT SOC |
| OW-42-03 | P2 | Dashboard W2 v2 artifact swap + sign-off | STAGED | Dashboard owner |
| OW-41-03 / OW-40-01..03/11/12 | various | carried from prior phases | see open-work.md | see owners |

## 5. Resilient Control Posture (verified, carried)

- Single watchdog supervisor (s6; `supervisor_count=1`); stale-lock recovery (`cleanup_stale`).
- 13 routing states with real execution ids; dashboard v2 (4 objects); disk watermark ENABLED (67%);
  corrupt `eb937a37` absent; kill-switch negative proof.
- Retry/dead-letter states added (`ROUTED`, `DEAD_LETTER`).

## 6. Credential / Security

- Real Shuffle key: host bind-mount `wazuh_manager.conf` (root:wazuh 640). IRIS key (prefix c21731)
  in `creds.env` (mode 600, outside repo). **GAP (OW-67-01):** IRIS key is the full administrator
  key; a scoped least-privilege key is the recommendation (deferred, approval-gated).
- TLS: Shuffle :3443; Class-A workflow uses `verify=False` (exception recorded, not removed until
  internal TLS in place). Secret scan CLEAN for phase68 reports/evidence.

## 7. Canonical Navigation

- Current truth: this file (`current-state-20260828-p68.md`).
- Open-work ledger: `canonical/current/open-work.md`.
- Reports: `ops/reports/generated/phase68/` (540). Operator final: `ops/reports/current/phase68-operator-report.md`.
- Superseded by: any newer `current-state-2026*.md`.
