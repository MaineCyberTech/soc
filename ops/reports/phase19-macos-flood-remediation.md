# Phase 19 macOS Flood Remediation Plan

Date: 2026-08-18
Target: agent 015 `Julians-Air` (192.168.111.77, darwin)
Status: **PLAN READY - ACTION BLOCKED ON MAC ACCESS** (operator must run local commands on the Mac)

## 1. Current flood symptoms (measured, live)

| Metric | Phase 18 (08-16) | Preflight (08-17) | Preflight (08-18) |
|---|---|---|---|
| Archive docs/day | 1,387,891 | 1,195,709 | 308,130 (until 09:04 disconnect) |
| Peak hourly | ~90K-127K | - | **127,504 @ 01:00 UTC** |
| Agent status | disconnected | disconnected | **disconnected since 09:04 UTC** |
| Matched alerts/day | 383 | 271 | 82 (mostly rule 203/204/533/5407 = standard macOS/OSX events) |

- The default Wazuh macOS agent `ossec.conf` includes a `<localfile>` streaming the **full unified logging database** (`log <maslog>`/`log_format json`), which emits tens of thousands of process/network/event docs per hour. Almost all of it only matches level 0-2 generic rules and lands in **archives** (~1.4M/day), overwhelming agent 015's queue and causing disconnects.
- Measured tradeoff: useful macOS telemetry (login/logout, sudo, launch agents, TCC) is a tiny fraction of the flood. The shared/manager-managed ossec.conf **cannot** scope it per-agent, so the fix must be applied locally on the Mac.

## 2. Exact local `ossec.conf` entries to edit on Julians-Air

File: `/Library/Ossec/etc/ossec.conf` (standard Wazuh macOS install).

Find the default macOS unified-log localfile block (do **NOT** touch `<localfile>` entries for `ossec.conf`/`auth.log`/`secure.log` or the `syscheck`/`rootcheck`/`sca` blocks):

```xml
<!-- Unified logging: streams the entire macOS unified log database -->
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
  ...
</localfile>
```

### Recommended change (2-step, keep meaningful telemetry)

1. **Comment out** the blanket unified-log localfile (the `location>log</location>` block). This stops the ~1.4M docs/day flood.
2. **Add** a bounded replacement that keeps high-value macOS telemetry via targeted predicates (optional but recommended to retain SOC value):

```xml
<!-- Phase 19: bounded macOS unified log - security-relevant subsystems only -->
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
  <query>subsystem == "com.apple.Authorization" OR subsystem == "com.apple.SystemConfiguration" OR eventMessage CONTAINS "sudo" OR (process == "loginwindow") OR (process == "securityd")</query>
</localfile>
```

Security tradeoff (documented): suppressing blanket unified logging removes deep process/network forensics for this endpoint. Mitigation: bounded subsystem predicate retains auth (Authorization/SystemConfiguration), sudo, loginwindow, and securityd events; full logs remain available locally on the Mac via the unified log store (`log show`), and fleet-wide this returns expected macOS monitoring to parity with other clients.

## 3. Before/after measurement windows

| Window | What to capture | Where |
|---|---|---|
| BEFORE (already captured) | 7d archive count by day, hourly peak, agent keepalive | this preflight (phase19-preflight) |
| T0 = config applied + `wazuh-control restart` | agent reconnect time, `lastKeepAlive` | Wazuh API |
| +15 min | alert + archive doc count for agent 015 | indexer |
| +1 h | hourly archive volume; queue-full count | indexer (rule 501/502/503, full_log) |
| +24 h | daily archive count (target: < 25K docs/day, i.e. 98% reduction), queue-full = 0, agent stays connected | indexer + API |

Success target: **>=95% archive-volume reduction, 0 queue-full, agent 015 active >= 24h continuous.**

## 4. Rollback steps (documented for the operator)

1. On the Mac, restore the backup: `sudo cp /Library/Ossec/etc/ossec.conf.phase19.bak /Library/Ossec/etc/ossec.conf`
2. `sudo /Library/Ossec/bin/wazuh-control restart`
3. Verify: `sudo /Library/Ossec/bin/wazuh-control status` -> all processes running; agent shows active in Wazuh within 2 min.
4. If volume does not drop after 24h, restore backup (do not iterate on the shared config).

Full operator command block (no secrets): see `integrations/macos/phase19-macos-local-ossec-config.md` and `phase19-agent015-operator-steps.md`.

## 5. Owner / approval

- Action owner: **operator with access to Julians-Air** (agent 015 endpoint). SOC OpenCode session does not have Mac access -> marked **blocked by endpoint access** until operator runs the command block.
- No stack-side change required; manager config left untouched.

## No secrets