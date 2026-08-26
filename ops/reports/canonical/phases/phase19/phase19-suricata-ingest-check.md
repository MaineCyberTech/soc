# Phase 19 Suricata Ingest Check

Date: 2026-08-18

## Pre-fix ingest state (measured)

- Wazuh agent 008 location histogram (7d, alerts + archives): **no `/nsm/suricata/eve.json`**
  in either index. Suricata events were NOT reaching Wazuh.
- Root cause: dangling symlink + dead updater (see `phase19-suricata-path-stability.md`).

## Suricata output is present (on the SO host)

- `/nsm/suricata/eve-2026-08-18-21:29.json` contains a real alert:
  - signature: **GPL ICMP PING *NIX** (sid 2100366, severity 3, "Misc activity")
  - src 192.168.222.149 -> dst 192.168.222.154, ICMP type 8
  - vlan 42, action allowed.
- Suricata is otherwise quiet (1 alert in the current rotation) - matches P18 finding.

## Post-fix ingest validation

- Symlink repointed to the live file at 21:34 UTC. Wazuh logcollector (agent 008) picks the
  eve.json via logcollector's regular file scan (json format).
- **Validation window open**: expect the first `/nsm/suricata/eve.json` location event in the
  Wazuh archives/alerts within minutes-to-hours of the symlink fix. Status: PENDING confirmation.

## What to confirm at next check

1. `location == "/nsm/suricata/eve.json"` appears for agent 008 (archives) with the ICMP alert
   decoded (alert.signature, alert.severity fields).
2. logcollector reports no file-read errors on the SO agent.
3. Event volume per rotation is sane (quiet network -> low volume expected, not zero).

## Documented if Suricata stays quiet

If no eve events appear within 24h despite the fix, possible causes in order:
1. logcollector cached the dangling target and needs a scan cycle/agent restart.
2. eve.json JSON schema fields don't map to the json decoder (validate with logtest).
3. Suricata genuinely generates no alerts on this quiet network (confirm via `so-suricata` logs).

## Decision

- Path stability: **FIXED this run** (validated symlink + cron + updater script).
- Ingest: **PENDING 24h validation** (window opened 21:34 UTC 08-18).

## No secrets