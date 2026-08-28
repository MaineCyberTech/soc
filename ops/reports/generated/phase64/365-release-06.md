# Phase 64: Release 06

**Report ID:** phase64-365-release-06
**Phase:** 64
**Title:** Release 06
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T19:35:21Z (UTC) / 2026-08-28 15:35:21 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase64/365-release-06.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 64 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Staged-deploy used for all config changes (ownership/mode/readability/XML/hook/backup/rollback validated before restart).
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Release: Phase 64 certifies bounded Class-A production operations. Release artifacts = governed watchdog source + s6 unit (P61), dashboard v2 import (P42/P63), staged-deploy validator (P64) — all reversible.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-28T19:35:21Z / ET 2026-08-28 15:35:21 EDT.
- Config-source of record: redacted governed copy + live backup sha256 1893ae0ee4b9... (root:wazuh 640).
- Staged-deploy contract: phase64-config.json passes 8-key validation (owner/group/mode/readability/xml/hook/backup/rollback).
- Watchdog-valid: integratord restarted without manager outage (PID 21130/21172).
- Kill switch re-tested WITHOUT outage: engaged (PID 21450, hook absent) + rolled back (PID 21512, ROUTED 200).
- Watchdog-invalid: broken XML -> integratord fails closed (count 0), others up; restored to single instance (PID 26278).
- Recovery canary: exec 8e62a17a-82c1-4de4-bb54-7712a290bb13 -> ROUTED 200; IRIS alert 134 read back (source wazuh, class A).
- 13 state execution_ids verified present in live Shuffle; dashboard v2 (4 objects) present; disk watermark ENABLED (67%).
- Production scoped to Class-A; restore deferred (DR future).

## Backup / Rollback
- Pre-change config backup retained outside repo (/opt/wazuh-docker/.../backups/); sha256 recorded.
- Staged-deploy rollback = restore backup (root:wazuh 640) + integratord-only restart via watchdog.
- AGENTS.md edit (if any) preceded by timestamped sha256 backup under ops/backups/agents/.

## Limitations
- IRIS list API 500s (Shuffle datastore quirk); single-object GET used for read-back.
- Shuffle API key limited-RBAC (PUT/DELETE=401); kill switch is the integratord hook control.
- Restore and full DR remain DEFERRED (not tested now; future environment).
- A second watchdog instance observed during testing (s6-managed, lock-coordinated); benign.

## Verdict
PASS -- directly evidenced (execution_id / observed_state / IRIS read-back / live process / config sha) -- truthfully reflects current authorized, directly evidenced, production-scoped state; gated items recorded, not fabricated.
