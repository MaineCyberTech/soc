# Canonical Current State — 2026-08-28 (Phase 67 refresh)

**Supersedes:** `current-state-20260828-p66.md` (per its own supersession statement).
This document is the live operational truth. Do not act on any claim older than this
without re-verification. Phase 67 refreshes the register and records the P66 truth-correction
that the Shuffle→IRIS leg is NOT broken.

## 1. Headline

- **TRUTH CORRECTION (carried from P66):** the Shuffle→IRIS leg is **NOT broken**. The
  workflow's `execute_python` reads the **correct mounted secret** (prefix `c21731`, identical
  to the recovered `creds.env` key) and POSTs to the **Shuffle-reachable** URL
  `https://iriswebapp_nginx:8443/alerts/add`. The earlier "delivery broken / 401" finding was
  INCORRECT — it tested the wrong standalone `iris-shuffle.env` files, not the mounted secret.
- **GENUINE Wazuh→IRIS delivery PROVEN + PERSISTENT:** Wazuh alert `1787948087.9767291`
  (rule 100065) → integratord `[200]` → Shuffle hook `webhook_e3fec000` → Class-A workflow
  `c6b3fcd8` → execution `593b3840` → IRIS POST `200` → **IRIS object 149**. Independent
  read-back VERIFIED (`GET /alerts/149` → 200 live Critical/New); marker parity VERIFIED
  (tags `source:wazuh,class:A`). IRIS contains live objects 140–149 from the pipeline.
- **Endpoint selected and in use:** `iriswebapp_nginx:8443` (shared `mct-security` +
  `shuffle_swarm_executions` network; loopback forbidden). Not a change — it was already correct.
- **OW-65-01 CLOSED** (P66) and **OW-66-01 CLOSED** (P66). **OW-67-01 OPEN (partial):** retry
  loop + dead-letter are **WIRED** into the Class-A workflow execute_python (OpenSearch doc
  c6b3fcd8 updated 2026-08-28; backup at ops/backups/workflow-c6b3fcd8-20260828T223000Z.json;
  success path unchanged, so genuine Wazuh->IRIS delivery remains VERIFIED). Idempotency/replay/
  alerting remain deferred (IRIS list API 500s). Least-privilege IRIS credential CREATION is
  deferred (requires IRIS admin UI / known API + a swarm-secret rotate to wire; the mounted
  secret still uses the full-administrator key).

## 2. Open / Gated (NO-GO without sign-off)

| ID | Pri | Title | Status | Owner |
|---|---|---|---|---|
| OW-67-01 | P2 | Least-privilege IRIS credential + wire retry/dead-letter/replay | OPEN — DESIGN only; implement on request | IRIS/SOAR ops |
| OW-40-05 | P1 | RTO/RPO sign-off | AWAITING-SIGNATURE | Platform + SOC lead |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO | Infra + SOC lead |
| OW-40-04 | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE | SOAR ops + Detection |
| OW-42-01 | P1 | Indexer disk-threshold policy decision (R-DISKBYPASS) | NEW-P42 | Wazuh/indexer config owner |
| OW-42-02 | P2 | v1.3.1 release-page publication | TOKEN-BLOCKED | MCT SOC |
| OW-42-03 | P2 | Dashboard W2 v2 artifact swap + sign-off | STAGED | Dashboard owner |
| OW-40-01/02/03/11/12, OW-41-03 | various | carried from prior phases | see open-work.md | see owners |

## 3. Closed This Phase (register refresh)

- **OW-65-01** — Wazuh→IRIS delivery leg: CLOSED + PERSISTENT (P66). Verified genuine delivery.
- **OW-66-01** — IRIS read-back + genuine-event delivery: CLOSED (P66). Read-back fixed + delivery verified.

## 4. Resilient Control Posture (verified, carried)

- Single watchdog supervisor (s6; `supervisor_count=1`); stale-lock recovery (`cleanup_stale`).
- Kill-switch negative proof; 13 routing states with real execution ids; dashboard v2 (4 objects);
  disk watermark ENABLED (67%); corrupt `eb937a37` absent.

## 5. Credential / Security

- Real Shuffle key: host bind-mount `wazuh_manager.conf` (root:wazuh 640). IRIS key (prefix c21731)
  in `creds.env` (mode 600, outside repo). **GAP (OW-67-01):** the IRIS key is the full
  administrator key; a scoped least-privilege key is the P67 recommendation.
- TLS: Shuffle :3443; workflow is value-blind (verifies cert pin skipped — `verify=False`);
  noted as a security item to pin/validate. Secret scan clean for phase67 reports/evidence.

## 6. Canonical Navigation

- Current truth: this file (`current-state-20260828-p67.md`).
- Open-work ledger: `canonical/current/open-work.md` (OW-65-01/OW-66-01 resolved; OW-67-01 open).
- Superseded by: any newer `current-state-2026*.md`.
