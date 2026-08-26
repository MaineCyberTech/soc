# Phase 42 VT Secret-Reference Migration Plan

**Report ID:** phase42-52-vt-migration-plan
**Phase:** 42
**Title:** MIG-VT-42-01 — Native Secret-Reference Support Confirmed ABSENT In This Wazuh Version (integrationsd Reads ossec.conf Literally); Options Ranked: (a) Accepted-Risk With Hardening + Rotation Runbook [RECOMMENDED] > (b) Custom Env-Var Wrapper [Deferred]; Rotation Runbook Skeleton Included
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:03:00Z
**Classification:** INTERNAL
**Status:** DECIDED (option a; b deferred)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-52-vt-migration-plan.md`

---

## 1. Platform finding — migration BLOCKED at version level

This Wazuh build's integrations daemon parses `<integration>` blocks straight
from `ossec.conf` and consumes the literal `<api_key>` string. There is no
secret-reference/env-var/vault indirection in this version: any pointer syntax
would be sent to VirusTotal verbatim and fail auth. A true "move the secret
out of the config" migration is therefore **blocked by platform capability**,
not by operator effort.

## 2. Options ranked

| Rank | Option | Description | Cost / residual |
|---|---|---|---|
| **(a) RECOMMENDED** | **Accepted-risk + compensating hardening + rotation runbook** | Keep key in ossec.conf. Compensations: container conf 640 root:root (**DONE**, phase42-53); host conf 640 (**owner item**, sudo required); git/history proven clean (VT-42-01); rotation-on-demand runbook below keeps blast radius time-boxed | Residual: plaintext at rest in two files; mitigated by perms + clean history |
| (b) Deferred | Custom integration wrapper reading key from env var (sidecar script replaces integrationsd call path or pre-render step injects value at container start) | Engineering + maintenance cost; diverges from upstream image; adds failure modes to detection path | Revisit if Wazuh upgrade ships native refs or if compliance demands zero plaintext |

## 3. Decision

Option (a). Rationale: threat model is local-read/exfiltration, fully covered
by 640 perms + clean git posture; option (b)'s wrapper would touch the
alert-enrichment pipeline that production detections depend on — risk/cost
disproportionate today.

## 4. Rotation runbook skeleton (option-a compensator)

```text
ROT-VT-01 — VirusTotal api_key rotation (on demand / on suspicion)
Pre:  confirm sudo available; maintenance window not required (single reload)
 1. Regenerate key at VirusTotal portal (old key stays valid until revoke).
 2. Atomic replace:
      new=$(cat /dev/stdin)            # never echo to logs
      tmp=$(mktemp) && chmod 600 "$tmp"
      sed "s|<api_key>OLD</api_key>|<api_key>${new}</api_key>|" \
        /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf > "$tmp"
      mv -f "$tmp" /opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf
      docker cp  (or volume-path write) into /var/ossec/etc/ossec.conf; chmod 640
 3. Restart integrations: docker exec multi-node-wazuh.master-1 \
      /var/ossec/bin/wazuh-control restart   (or targeted integrationsd reload)
 4. Differential test (value-blind):
      - trigger one syscheck alert → confirm VT enrichment appears in archive
      - monitor cycle p39-iris-delivery-check.sh → delivered advances, no new FAILED
      - grep -c '<api_key>' conf unchanged (=2); lengths classified only
 5. Revoke OLD key at portal.  6. Update phase42-53 attestation date.
Never: print key, commit conf, or loosen perms during rotation.
```

## 5. Review trigger

Re-evaluate option (b)/native support at next Wazuh image upgrade or Phase 43
review, whichever first.
