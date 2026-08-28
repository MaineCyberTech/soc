# Canonical Current State — 2026-08-28 (Phase 66 refresh)

**Supersedes:** `current-state-20260828-p65.md` (per its own supersession statement).
This document is the live operational truth. Do not act on any claim older than this
without re-verification. Phase 66 reconciles the Phase 65 Wazuh→IRIS repair into an
operationally closed state and records one new open item (OW-66-01).

## 1. Headline

- **GENUINE Wazuh→Shuffle→IRIS delivery is PROVEN and PERSISTENT.**
  Real Wazuh alert `1787948087.9767291` (rule 100065, level 12) → wazuh-integratord
  Response `[200]` → Shuffle hook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` →
  Class-A workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` → execution
  `593b3840-0565-4d46-8574-c676cc7f54a8` → IRIS POST **Routed 200 (status New)**.
  Evidence: `ops/evidence/phase65-wazuh-canary-alert.json`,
  `ops/evidence/phase65-integratord-delivery.log`.
- **Persistence verified after container recreate:** manager is on the `mct-security`
  network (sudo-edited `docker-compose.yml` + recreate, backed up) and the real Shuffle
  key is set in the host bind-mount `wazuh_manager.conf` (root:wazuh 640). A fresh genuine
  canary produced a NEW execution that reached IRIS (Routed 200).
- **OW-65-01 CLOSED** (Wazuh→IRIS pipeline repaired + persistent).
- **OW-66-01 OPEN** — credential drift: the ops-vault `IRIS_API_KEY` returns HTTP 401
  (stale) while the Shuffle-managed IRIS key remains valid. Independent IRIS object
  read-back is therefore BLOCKED; `iris_object_id` UNRETRIEVABLE, marker parity UNVERIFIED.
  Recorded honestly, not fabricated.

## 2. Open / Gated (NO-GO without sign-off)

| ID | Pri | Title | Status | Owner |
|---|---|---|---|---|
| OW-66-01 | P2 | IRIS read-back credential drift (ops-vault IRIS_API_KEY stale, 401) | OPEN — refresh ops-vault key to live Shuffle-owned key | IRIS/SOAR ops |
| OW-40-05 | P1 | RTO/RPO sign-off | AWAITING-SIGNATURE | Platform + SOC lead |
| OW-40-06 | P1 | Restore rehearsal on approved external target | NO-GO | Infra + SOC lead |
| OW-40-04 | P1 | Packet workflow import + routing proofs | DEFERRED BY CHOICE | SOAR ops + Detection |
| OW-42-01 | P1 | Indexer disk-threshold policy decision (R-DISKBYPASS) | NEW-P42 | Wazuh/indexer config owner |
| OW-42-02 | P2 | v1.3.1 release-page publication | TOKEN-BLOCKED | MCT SOC |
| OW-42-03 | P2 | Dashboard W2 v2 artifact swap + sign-off | STAGED | Dashboard owner |
| OW-40-01/02/03/11/12, OW-41-03 | various | carried from prior phases | see open-work.md | see owners |

## 3. Closed This Phase

- **OW-65-01** — Wazuh→IRIS delivery leg. Root causes corrected and PERSISTENT:
  (1) manager on `mct-security` network (compose); (2) real Shuffle key in host bind-mount.
  CORRECTION: `webhook_e3fec000` was ALREADY linked to `c6b3fcd8` (trigger
  `e3fec000-555f-4e81-9497-77b7c91c5b98`); the earlier "0 executions" was a limited-RBAC
  listing artifact, not a missing link. Genuine end-to-end proven (Routed 200, status New),
  verified post-recreate.

## 4. Resilient Control Posture (verified)

- **Single watchdog supervisor:** s6 runs exactly one integratord-watchdog; the
  s6-supervised process + transient worker share the `mkdir(/tmp/integratord_watchdog.lock)`
  critical section so only one acts. `supervisor_count=1`.
- **Stale-lock safe:** `wazuh-control` natively removes pid files for processes not used by
  Wazuh; the governed watchdog source adds `cleanup_stale()` (removes dead integratord pid
  files + dead start-script-lock before start) as defense-in-depth — covers PID-reuse and
  race conditions.
- **Kill switch negative proof:** with the hook removed (engaged), integratord has no
  Class-A destination → genuine alert generated but NOT delivered (absence when engaged).
  Rollback = restore hook (root:wazuh 640) + integratord-only restart via watchdog →
  ROUTED 200.
- **13 routing states** carry REAL Shuffle execution_ids + observed_state
  (`ops/evidence/p66-states.json`); ROUTED live-demonstrated by execution `593b3840`.
- **Dashboard v2** present (4 objects); **disk watermark** ENABLED (manager 67%).
- **Corrupt `eb937a37-…`** absent (GET 400); nothing to delete.

## 5. Credential / Security

- Real Shuffle key: host bind-mount `wazuh_manager.conf` only (root:wazuh 640); never in repo.
- Shuffle TLS :3443; value-blind IRIS token used only in-memory historically.
- **Limitation (OW-66-01):** ops-vault `IRIS_API_KEY` stale (401). Read-only read-back
  credential; staleness documented, not a production-delivery risk.
- Secret scan clean for phase66 reports/evidence.

## 6. Canonical Navigation

- Current truth: this file (`current-state-20260828-p66.md`).
- Open-work ledger: `canonical/current/open-work.md` (OW-65-01 in Resolved Log; OW-66-01 OPEN).
- Superseded by: any newer `current-state-2026*.md`.
