# Phase 56: Wazuh Integratord Logs

**Prompt:** 040-classa-wazuh-logs
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Read-only inspection of the Wazuh `integratord` daemon on `multi-node-wazuh.master-1` to
search for Class-A hook delivery evidence. The daemon is alive and draining its alert queue,
but in the sampled window **every alert is skipped** ("Group doesn't match") — i.e. no alert is
currently forwarded to the Shuffle webhook. This is consistent with the Class-A drift described
in the run context (webhook-id mismatch + group filter). No webhook was invoked (never GET; this
is log inspection only).

## Evidence
- EV-WZ-LOG-01 (VERIFIED): `integratord` process active — log lines `integrator.c:154 OS_IntegratorD(): jqueue_next()` and `integrator.c:161 Sending new alert` observed in `docker logs multi-node-wazuh.master-1`.
- EV-WZ-LOG-02 (VERIFIED): Class-A integration configured — `wazuh_manager.conf:346` `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>` with `<group>suricata,</group>` (Wazuh integratord layer).
- EV-WZ-LOG-03 (PARTIAL): In the sampled tail (~200 lines) **0 successful deliveries** — every `Sending new alert` is followed by `integrator.c:240 Skipping: Group doesn't match`. No POST to the Shuffle webhook is evidenced in this window. (Wazuh integratord layer — delivery gap.)
- EV-WZ-LOG-04 (VERIFIED): `shuffle-backend` is reachable from the Wazuh container — both `multi-node-wazuh.master-1` and `shuffle-backend` join the `mct-security` docker network (see 041/044). (Network layer, separate.)

## Backup-Rollback
Read-only. No change made. Config reference: `/opt/mct-security-stack` is not the Wazuh config owner; Wazuh config at `/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf` (sha256 `7a640035…44844a8`, see 046).

## Stop conditions
None encountered for read-only inspection. Note: repair of the delivery gap (047 repair-plan, 050 align-hook, Wazuh apply 257) is owner/approval-gated — STOP there.

## Limitations
- Sampled `docker logs --tail 200` only; integratord is at DEBUG level so queue churn is high. A longer window may show a matching `suricata` alert, but none appeared in sample.
- Delivery success at the Shuffle side cannot be confirmed from Wazuh logs alone; cross-referenced with trigger registry (044/045) which shows the Class-A trigger is absent from the live registry.

## Verdict rationale
Inspection completed and evidence captured. The integratord→Shuffle Class-A path is currently
non-delivering (group-skip + webhook-id mismatch per 045). Marked DONE because the read-only
task succeeded; the underlying path defect is recorded as a finding, not a fabricated PASS.
