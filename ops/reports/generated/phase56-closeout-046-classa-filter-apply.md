# Phase 56 Closeout: Apply Filter Repair

**UTC:** 2026-08-28T01:12:00Z
**America/New_York:** 2026-08-27 21:12:00 EDT

## Prompt
Apply the Wazuh `<group>` filter repair — only if covered by authorization.

## Task
Change the Wazuh integratord `<group>` filter so Class-A high-severity alerts route to Shuffle.

## Evidence
- EB §3 (updated 2026-08-28T01:12Z): filter was `<group>suricata,</group>`. Owner authorized the change ("do it", 2026-08-28) — supersedes the earlier gate.
- EB §10 (updated): Wazuh filter now FIXED (authorized).

## Method
GENUINE-APPLY (authorized). Replaced `<group>suricata,</group>` with `<level>10</level>` (minimum level to forward) in BOTH the running volume (`/var/ossec/etc/ossec.conf`) and the durable host bind source (`/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf`). Applied via in-place edit (sed+cat to avoid bind-mount rename failure), then `chown wazuh:wazuh` + `chmod 640` on the running config, `rm -f /var/ossec/var/run/wazuh-db.failed`, and `docker restart` of the Wazuh master. Integratord (PID 428) restarted cleanly; no new XML `(1226)` errors (prior 08-27 lines are historical incident only). Packet-routing lane (`suricata-eve-in`, fed independently) is unaffected.

## Backup
- Running config: `/var/ossec/etc/ossec.conf.bak-filter-20260828011156` (in-container).
- Host source: `/tmp/opencode/ossec.host.bak-filter-20260828011156`.

## Rollback
Re-apply `<group>suricata,</group>` (or `<level>N</level>`) to both paths from the backups, `chown wazuh:wazuh` + `chmod 640`, restart. One-line threshold adjustment is supported (`<level>8</level>` = High+, `<level>12</level>` = Critical only).

## Stop conditions
None hit — change authorized and applied safely (backups taken, perms correct, restart clean).

## Limitations
End-to-end delivery of a *real* level-10+ Wazuh alert uses the Class-A webhook trigger `e3fec000-555f-4e81-9497-77b7c91c5b98` (LIVE, status=running) on recreated workflow `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (original `eb937a37` corrupted). The filter itself is verified applied and valid; a synthetic POST bypasses the Wazuh filter so cannot prove the filter, but config validity + integratord clean restart confirm correct application.

## Verdict
DONE — Wazuh integratord filter changed to `<level>10</level>` (authorized), applied to running volume + durable host source (manager + worker), backed up, restart clean. Class-A now forwards high-severity (level 10+) Wazuh alerts to `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` (workflow recreated as `c6b3fcd8-13e5-44a8-a818-024e4ae4422b`; original `eb937a37` corrupted). RESOLVED: trigger is live; full automatic end-to-end is operational.

## Update (2026-08-28)
The Class-A workflow was recreated as `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` after the original `eb937a37` was corrupted by an API `PUT` (HTTP 400). Wazuh `hook_url` on both manager and worker now points to `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` (trigger created in Shuffle UI, status=running). The filter change (`<level>10</level>`) remains valid on both nodes. The trigger is live (status=running, webhook returns 200); the flow is operational. Real-alert confirmation: a genuine level-12 Wazuh alert (custom rule 100999, desc `CLASSA-E2E-TEST`) was generated and `wazuh-integratord`'s shuffle integration (`<level>10</level>`, no group) forwarded it to the live webhook; the webhook fires the workflow → IRIS (proven IRIS POST). Full Wazuh→integratord→webhook→workflow→IRIS path confirmed. Test rule/localfile reverted; no config residue.
