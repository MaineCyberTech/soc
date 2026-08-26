# Phase 17 Security Onion Zeek/Suricata Ingest Deep Dive

Date: 2026-08-16

## Status: ZEEK INGEST WORKS (NO ALERTS) - SURICATA NOT INGESTED (BROKEN PATH)

## Agent 008 / pipeline state

| Item | Status |
|---|---|
| Agent 008 | ACTIVE (was down 08:27-08:30 - restarted cleanly) |
| zeek-forward service | active, writing ZEEK lines (84MB file, growing) |
| ZEEK lines read | YES - logcollector analyzes /nsm/zeek/zeek-forward.log |
| Zeek docs (24h) | 71,537 in archives |
| Zeek decoder | zeek-conn (extracts zeek.ts, zeek.uid) |
| **Zeek RULES firing** | **ZERO (0 of 71,537 have a rule)** |
| **Suricata eve.json** | **NOT READ - path broken (eve.json missing)** |

## Finding 1: Zeek conn data = detection gap (dropped in alert sense)

- The ruleset's owlh zeek rules (66001-66004) match field `bro_engine`
  (SSH/SSL/DNS/CONN).
- Our custom decoder (local_decoder.xml:544) extracts `zeek.ts`/`zeek.uid` -
  **bro_engine never set** -> no rule matches -> all Zeek conn data stored at
  level 0 (archives only), ZERO alerting.
- Impact: no alerts for new-subnet discovery, unusual connections, or Zeek-
  derived detections. Data preserved (investigatable) but not monitored.

## Finding 2: Suricata eve.json broken path

- ossec.conf localfile: /nsm/suricata/eve.json (log_format json).
- SO writes TIMESTAMPED files (eve-2026-08-16-08:03.json); plain eve.json
  does not exist -> logcollector ERROR (1103) every start.
- Impact: Suricata alerts NOT ingested at all.

## Finding 3 (fixed this phase): agent 008 processes died 08:27

- My earlier wazuh-control restart killed all agent processes on SO and they
  did not restart (wazuh-control restart is unreliable on this agent).
- Fixed: wazuh-control start; agent reconnected (Active), events flowing.

## Recommendations

1. **Zeek rules**: add detection rules matching our decoder fields (zeek.*):
   new-subnet discovery, unusual port/conn patterns, beaconing - NOT rule
   66004 (would fire on every conn).
2. **Suricata**: point localfile at the SO eve.json symlink/real path
   (create symlink /nsm/suricata/eve.json -> current timestamped file, or
   configure SO to write un-rotated eve.json).
3. **Agent lifecycle**: document that wazuh-control restart on SO requires
   verification + wazuh-control start fallback.

## Files

- integrations/security-onion/phase17-zeek-suricata-tuning.md (created)
- integrations/security-onion/phase17-zeek-dns-http-expansion-plan.md (created)

## No secrets

No secret values printed.
