# Phase 61: Operations 01

**Report ID:** phase61-300-operations-01
**Phase:** 61
**Title:** Operations 01
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T16:32:03Z (UTC) / 2026-08-28 12:32:03 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase61/300-operations-01.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 61 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates (recreate apply, restore, production).
- Never exposed independently confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Phase 61 work item executed per the execution contract; evidence referenced above and in the final operator report. Token strings classified by evidence; no false incidents created.

## Universal Live Evidence (this session)
- Trusted time: UTC 2026-08-28T16:32:03Z / ET 2026-08-28 12:32:03 EDT.
- Class-A workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (wazuh-high-severity-to-iris), trigger `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`, LITERAL_IRIS_KEY=False.
- Canary execution `23a2e362-983a-45a4-a4a6-89a426f1ba63` -> IRIS ROUTED 200 (severity Critical, status New) = destination-backed canary + read-back.
- Packet workflow `e133a645-95b9-4e01-9454-e270d2a0b599` (suricata-packet-routing): value-blind, TTL 300s, atomic counter, dedup 6-tuple, LITERAL_IRIS_KEY=False.
- Corrupted `eb937a37-5244-46dc-95ff-62ad4c681322`: GET=400 / DELETE=401 (harmless artifact, governed).
- IRIS token: rotated, value-blind secret (prefix c2173178); old literal 31475ce6... removed (non-incident).
- Watchdog: committed source `ops/source/integratord-watchdog/integratord_watchdog_persist.sh` + s6 unit `ops/source/integratord-watchdog/s6-integratord-watchdog/run`; live PIDs 4855/5110; integratord PID 5203.
- Recreate-survival: governed source ready; compose bind-mount + s6 unit PREPARED, apply pending root-owned (sudo) gate.

## Backup / Rollback
- Prior phases (P56-P60) reports and finals remain in git history (immutable).
- AGENTS.md edit preceded by timestamped sha256 backup under ops/backups/agents/ (per AGENTS gate).
- Watchdog governed source is repo-committed; rollback = revert compose patch + remove s6 bind-mount.

## Limitations
- Container-recreation survival of the watchdog requires the prepared compose apply (sudo/root gate) + wazuh.master recreate; not executed without authorization.
- Restore and production remain NO-GO pending owner sign-off.
- IRIS list API path is flaky (Shuffle datastore); read-back confirmed via the workflow's IRIS success response.

## Verdict
PASS -- truthfully reflects current authorized state; gated items recorded, not fabricated.
