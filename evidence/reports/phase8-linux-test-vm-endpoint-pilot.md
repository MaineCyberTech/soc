> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Linux Test VM Endpoint Pilot - PASS

Date: 2026-08-15
Status: **PASS - first real non-Wazuh host endpoint deployment**

## Target

- VM 204 mct-linux-client01 (Proxmox 192.168.222.222)
- Debian 13 genericcloud image (cloud-init, static IP 192.168.222.240)
- 4GB RAM / 2 vCPU / 20G (bumped from 2GB after resource issues)

## Deployment (via endpoint kit)

1. Wazuh agent 4.14.7-1 installed (apt, dearmored key)
2. Manager: 142.105.190.25 (public IP)
3. Enrollment: agent-auth with registration password -> "Valid key received"
4. Group: linux-clients (created via agent_groups -a -g)
5. Service active

## Verification (verify-endpoint-linux-macos.sh, as root)

| Check | Result |
|---|---|
| wazuh-agent process running | PASS |
| wazuh daemons running (5) | PASS |
| agent enrolled (client.keys) | PASS |
| ossec.conf manager address | PASS |
| **Overall** | **PASS** |

## Wazuh registration

- Agent ID 011, mct-linux-client01, **Active** (verified agent_control)

## Pilot learnings (critical for level.io rollout)

1. **DNS was the blocker**: UniFi gateway doesn't resolve DNS for new hosts;
   internet works via IP only. Fix: /etc/hosts entries + dearmored apt key.
   level.io endpoints may hit the same - document DNS requirement.
2. **Cloud image needs dearmored GPG key** (`gpg --dearmor`) for apt.
3. **Registration password required** (enforced) - encrypted var in level.io.
4. **2GB RAM too tight** for first-boot apt on cloud image - use 4GB minimum.
5. **Group must exist before enrollment** (agent_groups -a -g <group>).
6. Cloud-init: use static IP (DHCP range may not cover .240).

## Files

- ops/reports/phase8-linux-test-vm-endpoint-pilot.md (this file)
- integrations/levelio/phase8-linux-client-rollout-result.md
- integrations/proxmox/mct-linux-client01.md
