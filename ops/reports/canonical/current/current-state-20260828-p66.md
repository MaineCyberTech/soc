# Canonical Current State — 2026-08-28 (Phase 66 refresh)

**Supersedes:** `current-state-20260828-p65.md` (per its own supersession statement).
This document is the live operational truth. Do not act on any claim older than this
without re-verification. Phase 66 reconciles the Phase 65 Wazuh→IRIS repair into an
operationally closed state and records one new open item (OW-66-01).

## 1. Headline

> **CORRECTION (2026-08-28, same day):** The earlier "IRIS delivery proven (Routed 200)"
> was a misread — `Routed 200` was Shuffle's *internal* routing status, not an IRIS HTTP
> 200. Verification shows the Shuffle→IRIS leg is **auth/connectivity-broken**: BOTH the
> ops-vault `IRIS_API_KEY` AND the Shuffle `iris-shuffle.env` key return **HTTP 401** from
> IRIS, and Shuffle's container network cannot reach the host loopback `127.0.0.1:8443`
> where IRIS is published. No IRIS object creation is confirmable. The Wazuh→Shuffle leg
> remains PROVEN; the IRIS leg is tracked as OW-66-01 (requires a valid IRIS credential).

- **GENUINE Wazuh→Shuffle delivery is PROVEN and PERSISTENT.** Real Wazuh alert
  `1787948087.9767291` (rule 100065, level 12) → wazuh-integratord Response `[200]` →
  Shuffle hook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` → Class-A workflow
  `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` → execution `593b3840-0565-4d46-8574-c676cc7f54a8`
  (created). Evidence: `ops/evidence/phase65-wazuh-canary-alert.json`,
  `ops/evidence/phase65-integratord-delivery.log`.
- **Persistence verified after container recreate:** manager is on the `mct-security`
  network (sudo-edited `docker-compose.yml` + recreate, backed up) and the real Shuffle
  key is set in the host bind-mount `wazuh_manager.conf` (root:wazuh 640). A fresh genuine
  canary produced a NEW Shuffle execution (proving Wazuh→Shuffle survives recreate).
- **OW-65-01 CLOSED** for the **Wazuh→Shuffle** portion (network + webhook + real Shuffle
  key; genuine delivery proven). The **Shuffle→IRIS** portion is NOT confirmed and is
  tracked separately as OW-66-01.
- **OW-66-01 OPEN** — IRIS credential/connectivity break: both available IRIS keys return
  HTTP 401 from IRIS and Shuffle cannot reach host `127.0.0.1:8443`. Independent IRIS
  object read-back is BLOCKED; `iris_object_id` UNRETRIEVABLE, marker parity UNVERIFIED.
  Remediation requires a valid IRIS API key (IRIS admin) + a Shuffle-reachable IRIS URL.
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
