# Phase 38-24 — Packet Path (Suricata) Claim Verification

**Report ID:** phase38-24-packet-claim-verification
**Phase:** 38
**Title:** Phase 38-24 — Packet Path (Suricata) Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-24-packet-claim-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:30 UTC
**Scope:** Verify Suricata sensor config/rules, agent-016 EVE ingestion paths, decode/rule layering, indexed evidence, and routing state.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | Agent 016 is an active Suricata sensor | **VERIFIED** | `agent_control -l` / `-i 016` |
| 2 | Agent 016 runs Wazuh v4.14.7 | **VERIFIED** | agent info output |
| 3 | Suricata alerts are indexed in OpenSearch | **VERIFIED** | `_count?q=suricata` = 433 |
| 4 | EVE JSON log paths flow from `/var/log/suricata/eve*.json` | **VERIFIED** | alert `location` fields in indexed docs |
| 5 | Decode + rule layers exist for suricata events | **VERIFIED** | ruleset file present; decoder=json on docs; rule 86601 firing |
| 6 | `grep -r "eve.json"` in cluster config dir finds references | **UNVERIFIED (no hits)** | command returned empty — config lives elsewhere |
| 7 | Packet workflow routing state | **PARTIAL** | Shuffle routing wf exists & runs (see phase38-23); IRIS delivery not re-proven here |

---

## Evidence Detail

### 1–2. Agent 016 identity and version
```
$ docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l | grep 016
ID: 016, Name: mct-packet-sensor, IP: any, Active

$ .../agent_control -i 016
Status:          Active
Operating system: Linux |mct-soc-scan |6.12.101+deb13-amd64 ... Debian 6.12.101-1 (2026-08-05)
Client version:   Wazuh v4.14.7
```
Sensor host `mct-soc-scan` (Debian 13), active, claimed version confirmed exactly. **VERIFIED.**

### 3–4. Indexed evidence and EVE paths
```
$ curl -sk -u admin:*** "https://127.0.0.1:9200/wazuh-alerts-*/_count?q=suricata"
{"count":433,"_shards":{"total":57,"successful":57,...}}

$ curl -sk -u admin:*** ".../_search?q=suricata&size=2&sort=@timestamp:desc"
hit#1 location=/var/log/suricata/eve.json       decoder=json
      event_type=alert, signature=SURICATA Applayer Wrong direction first Data,
      sig_id=2260001, src 172.183.7.192:443 → iface ens19, vlan [111]
hit#2 location=/var/log/suricata/eve-alert.json decoder=json
      marked MCT_TEST_ONLY=true, MCT_TEST_ID=P35-EVE-REPLAY-002,
      sig ET MALWARE ... [MCT-CANARY-P35-TEST-002]
most recent hit: @2026-08-25T19:18:18Z, agent.id=016, rule.id=86601
```
433 suricata-tagged alerts indexed; live traffic within the last hour from agent 016; two distinct EVE files observed (`eve.json`, `eve-alert.json`) matching the sensor's configured outputs. Test/replay documents are explicitly flagged (`MCT_TEST_ONLY=true`) — good provenance hygiene. **VERIFIED.**

### 5. Decode/rule layers
```
$ docker exec multi-node-wazuh.master-1 find /var/ossec/ruleset -name "*suricata*"
/var/ossec/ruleset/rules/0475-suricata_rules.xml     ← stock suricata rule mapping (incl. 86601)

$ docker exec multi-node-wazuh.master-1 grep -ln suricata /var/ossec/etc/rules/*.xml
(no output — no local/custom suricata rules overrides)

$ docker exec multi-node-wazuh.master-1 ls /var/ossec/etc/decoders/ | grep -i suricata
(no output — custom decoders dir has no suricata entries; JSON decoder handles EVE natively)
```
Pipeline is stock-ruleset driven (rule 86601 seen firing on live docs) with the built-in JSON decoder; no local customization detected. Layer claims hold as "present and functioning". **VERIFIED** for existence/effect; note absence of custom tuning.

### 6. Config grep
```
$ grep -r "eve.json" /opt/wazuh-docker/multi-node/config/wazuh_cluster/
(no output)
```
The prescribed command produced no matches — the cluster-shared config directory does not contain EVE path references (sensor-local ossec.conf on 016 governs the logcollector path; not readable from master's mounted config tree). The *claim that EVE paths are wired* is verified via alert `location` metadata above; this specific grep-based corroboration found nothing. **UNVERIFIED by this method / superseded by doc-level verification.**

### 7. Routing state
Cross-reference with phase38-23: `wazuh-flow-classb-to-iris` (flow classification) and `wazuh-high-severity-to-iris` both exist; classb wf has 1 FINISHED execution (test class B flow alert, rule 120500). IRIS containers running. Whether Suricata-class events specifically reach IRIS end-to-end was not directly demonstrated in this session (only one classb execution on record, dated 2026-08-10 test payload). **PARTIAL.**

---

## Verification Commands Used
```bash
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i 016
curl -s -k -u admin:*** "https://127.0.0.1:9200/wazuh-alerts-*/_count?q=suricata"
curl -s -k -u admin:*** ".../wazuh-alerts-*/_search?q=suricata&size=2&sort=@timestamp:desc"
docker exec multi-node-wazuh.master-1 find /var/ossec/ruleset -name "*suricata*"
docker exec multi-node-wazuh.master-1 grep -ln suricata /var/ossec/etc/rules/*.xml
grep -r "eve.json" /opt/wazuh-docker/multi-node/config/wazuh_cluster/
```

## Summary
The packet path is real and current: active v4.14.7 sensor, EVE JSON flowing, 433 indexed suricata alerts including fresh same-day events, stock rules/decoders doing the work. Gaps: no custom suricata rules/decoders, config-grep corroborations came up empty (paths managed sensor-side), and full packet→IRIS delivery proof remains outstanding.

## No secrets
