# Phase 66: Single Supervisor 05

**Report ID:** phase66-114-single-supervisor-05
**Phase:** 66
**Title:** Single Supervisor 05
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T21:57:51Z (UTC) / 2026-08-28 17:57:51 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase66/114-single-supervisor-05.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 66 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Staged-deploy used for all config changes (ownership/mode/readability/XML/hook/backup/rollback validated before restart).
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Trusted time captured (UTC 2026-08-28T21:57:51Z / ET 2026-08-28 17:57:51 EDT). Phase 66 reconciles the Phase 65 Wazuh->IRIS repair into an operationally closed state. OW-65-01 RESOLVED: a GENUINE Wazuh-originated canary (rule 100065, level 12) was delivered by wazuh-integratord to the Shuffle webhook with Response [200] and then to IRIS via the Class-A workflow (c6b3fcd8-13e5-44a8-a818-024e4ae4422b, trigger webhook_e3fec000-555f-4e81-9497-77b7c91c5b98) as Shuffle execution 593b3840-0565-4d46-8574-c676cc7f54a8 (Routed 200 (status New); independent read-back BLOCKED by stale ops-vault IRIS_API_KEY (HTTP 401)). The repair is PERSISTENT: manager joined the mct-security network (sudo-edited compose + recreate) and the real Shuffle key is set in the host bind-mount wazuh_manager.conf (live config sha bfb0cf8cdfad...). NEW GAP OW-66-01 (OPEN): the IRIS_API_KEY in the ops vault returns HTTP 401 (stale) while the Shuffle-managed IRIS key remains valid; independent IRIS object read-back is therefore blocked and recorded, not fabricated.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-28T21:57:51Z / ET 2026-08-28 17:57:51 EDT.
- Config-source of record: live manager ossec.conf (volume) sha256 bfb0cf8cdfad... (root:wazuh 640); real Shuffle key PERSISTENT in host bind-mount wazuh_manager.conf; manager on mct-security network (sudo-edited compose + recreate, verified post-recreate).
- GENUINE Wazuh-originated alert 1787948087.9767291 (rule 100065, level 12) -> integratord Response [200] -> Shuffle hook webhook_e3fec000-555f-4e81-9497-77b7c91c5b98 -> Class-A workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b -> execution 593b3840-0565-4d46-8574-c676cc7f54a8 -> IRIS Routed 200 (status New). (phase65-wazuh-canary-alert.json, phase65-integratord-delivery.log.)
- OW-65-01 RESOLVED (pipeline repaired + persistent). OW-66-01 OPEN: ops-vault IRIS_API_KEY stale (HTTP 401) blocks independent IRIS read-back (marker parity UNVERIFIED); recorded, not fabricated.
- Single watchdog supervisor certified (s6; supervisor_count=1); stale-lock recovery (cleanup_stale) present; stale_lock_safe=true.
- 13 state execution_ids reused (p66-states.json); dashboard v2 (4 objects) present; disk watermark ENABLED (67%).
- Production scoped to Class-A; restore deferred (DR future).

## Backup / Rollback
- Pre-change config backup retained outside repo (/opt/wazuh-docker/.../backups/); compose edit backed up before sudo recreate.
- Staged-deploy rollback = restore backup (root:wazuh 640) + integratord-only restart via watchdog.
- AGENTS.md edit (if any) preceded by timestamped sha256 backup under ops/backups/agents/.

## Limitations
- Independent IRIS object read-back is BLOCKED: ops-vault IRIS_API_KEY returns HTTP 401 (stale); Shuffle-owned key stays valid. iris_object_id UNRETRIEVABLE; marker parity UNVERIFIED. Recorded as OW-66-01.
- Shuffle API key limited-RBAC (PUT/DELETE=401): the webhook->Class-A workflow link was created by an operator (beyond limited RBAC) and is verified linked.
- Restore and full DR remain DEFERRED (not tested now; future environment).

## Verdict
VERIFIED -- directly evidenced (genuine Wazuh alert + integratord HTTP 200 + Shuffle execution + IRIS Routed 200 / observed state / live process / config sha); gated items recorded, not fabricated -- truthfully reflects current authorized, directly evidenced, production-scoped state; gated items recorded, not fabricated.
