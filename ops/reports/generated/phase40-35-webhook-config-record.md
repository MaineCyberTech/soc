# Phase 40 Webhook Config of Record — CFG-40-01

**Report ID:** phase40-35-webhook-config-record
**Phase:** 40
**Title:** Config of Record CFG-40-01 — Shuffle Integration Blocks (Master+Worker), Filter Rationale, Failure Semantics, Backup & Rollback
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:08:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Record ID:** CFG-40-01
**Supersedes:** phase39-37-wazuh-shuffle-config.md (CFG-39-01 DESIGNED-NOT-APPLIED)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-35-webhook-config-record.md`

---

## 1. Verbatim Integration Block — MASTER

`/wazuh-config-mount/etc/ossec.conf` (synced to `/var/ossec/etc/ossec.conf`),
line 344:

```xml
<ossec_config>
  <integration>
    <name>shuffle</name>
    <api_key>[REDACTED-PLACEHOLDER]</api_key>
    <hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>
    <group>suricata,</group>
    <alert_format>json</alert_format>
  </integration>
</ossec_config>
```

## 2. Verbatim Integration Block — WORKER

`/wazuh-config-mount/etc/ossec.conf` (synced to `/var/ossec/etc/ossec.conf`),
line 312 — byte-identical block.

Sync proof (measured 02:04Z): master `/var/ossec/etc/ossec.conf` md5 ==
`/wazuh-config-mount/etc/ossec.conf` md5 == `6de1e19907739482004ad40b182318c6`.

## 3. Referenced Workflow / Hook Objects

| Object | ID | State |
|---|---|---|
| Workflow | `eb937a37-5244-46dc-95ff-62ad4c681322` (`wazuh-high-severity-to-iris`) | status `test`, FINISHED executions verified |
| Webhook trigger | `24636c49-a2d0-40c2-887e-ccecdf22fc5c` (`wazuh-high-severity`) | `is_valid=True`, `status='running'` |
| Hooks datastore doc | `hooks/_doc/eb937a37-…` | found=true; start=trigger id; type=webhook; owner=soc@mainecybertech.com; org_id=`264c0502-9136-4cfc-938b-390b97b861b8` |

Secret policy: the deployed `<api_key>` value is itself a **non-secret placeholder
string** (`SHUFFLE_API_KEY_PLACEHOLDER`) because Shuffle hooks are
unauthenticated-by-design on this LAN-internal deployment. It is still rendered
redacted in all corpus files per SECRET-HANDLING; residual risk noted in
phase40-40 §4.

## 4. Filter Rationale — why `<group>suricata,</group>` and NOT `<rule_id>`

The P39 design used `<rule_id>86601, 2027967</rule_id>`. In this Wazuh build the
rule_id filter did NOT match even with rule 86601 alerts present; integratord debug
during the ops window showed:

```
integrator.c:240 at OS_IntegratorD(): DEBUG: Skipping: Group doesn't match.
```

— i.e. the skip reason was group-based despite rule_id being present in the alert,
and the only other observed skip class ("level too low") belonged to VirusTotal
traffic, not this lane. Replacing filters with `<group>suricata,</group>`
(trailing comma = any-match semantics within the group list) made integratord fire
on the very next eligible alert (E2E-007). Group filtering is also semantically
correct for the packet lane: EVE alerts decode into groups `["ids","suricata"]`.

## 5. Failure Semantics

- Integratord fires once per matching alert; **no queue, no retry** exists
  upstream of the HTTP POST. Unreachable backend → logged failure in
  `/var/ossec/logs/integrations.log`, alert processing unaffected (fail-closed for
  the lane, non-blocking for detection).
- Delivery outcomes are compensated by monitoring:
  `ops/scripts/p39-iris-delivery-check.sh` classifies every execution as
  DELIVERED / FAILED / ABORTED from stored action results (phase40-39 §5).
- Script exit codes: non-zero transport → execution marked FAILED in Shuffle;
  workflow-level failure does NOT roll back to the sensor path.

## 6. Backups

| Node | Path | Verified |
|---|---|---|
| Master (container) | `/wazuh-config-mount/etc/ossec.conf.bak-pre-shuffle-p40` (10944 B, Aug 26 01:00) | YES (ls 02:04Z) |
| Master (host-side attempt) | perm-denied → container-side backup taken instead | documented |
| Worker | host-side `.bak` attempt denied; container-side pre-change copy NOT retained | **GAP — see phase40-40 §4 residual** |

## 7. Test Procedure Summary

1. Marked hook probe: POST synthetic payload to the hook URL → expect
   `{"success": true, "execution_id": …}` and an IRIS row (§ phase40-37 §2).
2. Manual workflow fire → IRIS row (phase40-37 §3).
3. Full-chain canary: marker-tagged EVE event through sensor → IRIS row with ~2s
   latency (phase40-37 §4).
4. Post-check: delivery monitor totals + `Skipping: Group doesn't match` presence
   proves fail-closed behavior for non-lane traffic.

## 8. Rollback

```bash
# 1. Remove the integration blocks from BOTH host-side configs
#    /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf   (master)
#    /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_worker.conf    (worker)
# 2. Restore master if needed from its in-container backup:
docker exec multi-node-wazuh.master-1 \
  cp /wazuh-config-mount/etc/ossec.conf.bak-pre-shuffle-p40 /wazuh-config-mount/etc/ossec.conf
# 3. Restart both managers
docker restart multi-node-wazuh.master-1 multi-node-wazuh.worker-1
# 4. Optional network isolation (full disconnect):
docker network disconnect mct-security multi-node-wazuh.master-1
docker network disconnect mct-security multi-node-wazuh.worker-1
```

Workflow/hook objects may remain (harmless, unfed). No datastore or IRIS changes.

## 9. Verdict

**CFG-40-01: ACTIVE — VERIFIED on both nodes.** Supersedes CFG-39-01.
