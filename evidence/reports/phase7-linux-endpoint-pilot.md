> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Linux Endpoint Pilot

Date: 2026-08-12
Status: **PASS**

## Pilot target

- Host: this host (docker-host, Wazuh agent ID 006)
- Agent: wazuh-agent 4.14.7-1 (native install)
- Manager: 142.105.190.25 (public IP, verified reachable)
- Enrollment: via registration password (use_password enforced)
- State: **Active** in Wazuh

## Verification (verify-endpoint-linux-macos.sh as root - level.io runtime)

| Check | Result |
|---|---|
| wazuh-agent process running | PASS |
| wazuh daemons running (5) | PASS |
| agent enrolled (client.keys) | PASS |
| ossec.conf manager address set | PASS |
| velociraptor client present | PASS |
| osquery running | PASS |
| **Overall** | **PASS** |

## Notes

- Verify script must run as root (level.io Linux default) - client.keys and
  ossec.conf are root-readable only.
- This host doubles as the Linux pilot (server + local agent is a supported setup).
- No broad rollout performed.

## Files

- ops/reports/phase7-linux-endpoint-pilot.md (this file)
- integrations/levelio/linux-device-rollout-result.md
