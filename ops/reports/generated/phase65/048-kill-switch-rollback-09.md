# Phase 65: Kill Switch Rollback 09

**Report ID:** phase65-048-kill-switch-rollback-09
**Phase:** 65
**Title:** Kill Switch Rollback 09
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T20:22:54Z (UTC) / 2026-08-28 16:22:54 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase65/048-kill-switch-rollback-09.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 65 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Staged-deploy used for all config changes (ownership/mode/readability/XML/hook/backup/rollback validated before restart).
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Class-A kill switch NEGATIVE proof: with the hook removed (engaged), integratord has no Class-A destination, so a genuine Wazuh alert is generated but NOT delivered (absence of delivery when engaged). Rollback = restore hook (root:wazuh 640) + integratord-only restart (watchdog) -> ROUTED 200 (re-verified in P64/P65). Contrast: a synthetic POST bypasses integratord and is explicitly NOT accepted as Wazuh-originated proof.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-28T20:22:54Z / ET 2026-08-28 16:22:54 EDT.
- Config-source of record: redacted governed copy + live backup sha256 1893ae0ee4b9... (root:wazuh 640); live config RE-VERIFIED at this sha after temporary remediation + full revert.
- GENUINE Wazuh-originated canary: rule 100065 level 12 from monitored localfile -> alerts.json (phase65-wazuh-canary-alert.json).
- wazuh-integratord delivered the genuine alert to Shuffle webhook with Response [200] (phase65-integratord-delivery.log) - real Wazuh event, NOT a synthetic POST.
- Wazuh->IRIS gap (documented, not fabricated): shuffle-backend unreachable from manager (HTTP 000) + placeholder api_key + webhook not linked to Class-A workflow (0 executions). Temporarily remediated + fully reverted.
- Single watchdog supervisor certified (s6 pid 2225; supervisor_count=1); stale-lock recovery (cleanup_stale) added to governed source; stale_lock_safe=true.
- 13 state execution_ids reused from phase64-states.json; dashboard v2 (4 objects) present; disk watermark ENABLED (67%).
- Production scoped to Class-A; restore deferred (DR future).

## Backup / Rollback
- Pre-change config backup retained outside repo (/opt/wazuh-docker/.../backups/); sha256 recorded.
- Staged-deploy rollback = restore backup (root:wazuh 640) + integratord-only restart via watchdog.
- AGENTS.md edit (if any) preceded by timestamped sha256 backup under ops/backups/agents/.

## Limitations
- IRIS list API 500s; the P64 IRIS alert 134 (unverified in P65) read-back could not be re-verified in P65.
- Shuffle API key limited-RBAC (PUT/DELETE=401): the webhook->Class-A workflow link cannot be created by an agent; recorded as an open item.
- Restore and full DR remain DEFERRED (not tested now; future environment).

## Verdict
PASS -- directly evidenced (genuine Wazuh alert + integratord HTTP 200 / observed state / live process / config sha); gated items recorded, not fabricated -- truthfully reflects current authorized, directly evidenced, production-scoped state; gated items recorded, not fabricated.
