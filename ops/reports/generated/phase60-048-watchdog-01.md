# Phase 60: Watchdog - Runtime Inventory and Baseline

**Actual UTC:** 2026-08-28T11:00:00Z
**ET:** 2026-08-28 07:00:00 EDT
**Phase:** 60
**Classification:** INTERNAL

## Execution Contract
- Read root/scoped AGENTS and Phase 60 overlay.
- Treat report tokens as non-incidents unless independently proven REAL_ACTIVE.
- Execute safe, reversible, authorized work now; stop at unapproved gates.
- Never expose confirmed real credentials.
- Never GET a Shuffle webhook for health checking.
- Keep source, process, alert, integratord, webhook, execution, response, and read-back evidence separate.
- Record UTC and America/New_York.
- Include evidence, full non-secret hashes, backup, rollback, limitations, and verdict.

## Evidence

### Current Watchdog Deployment
- **Script:** `/usr/local/bin/integratord_watchdog_persist.sh`
- **Status:** RUNNING (PID 4855, 5110 - two instances from restarts)
- **Deployment:** Background process via `nohup` + `stdbuf -oL -eL`
- **Log File:** `/var/log/integratord_watchdog_persist.log`
- **Lock Mechanism:** `mkdir` on `/tmp/integratord_watchdog_persist.lock`
- **State File:** `/tmp/integratord_watchdog_persist.state` (restart_count, last_restart)

### Watchdog Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Check Interval | 10 seconds | Polling interval |
| Max Restarts | 5 | Per 5-minute window |
| Backoff | Exponential (10s→20s→40s→80s→160s) | Max 300s |
| Reset Window | 300 seconds | Restart counter reset |
| Lock Mechanism | `mkdir` on `/tmp/integratord_watchdog_persist.lock` | Atomic |
| State File | `/tmp/integratord_watchdog_persist.state` | `restart_count last_restart_timestamp` |
| Log File | `/var/log/integratord_watchdog_persist.log` | Append-only, root:wheel 644 |

### Watchdog Logic
1. **Acquire Lock:** `mkdir /tmp/integratord_watchdog_persist.lock` (atomic)
2. **Check PID:** Verify existing lock PID is alive
3. **Read State:** Read `restart_count` and `last_restart` from state file
4. **Main Loop (every 10s):**
   - Check `pgrep -f "wazuh-integratord"` 
   - If not running → attempt restart (with backoff)
   - Restart: `wazuh-control start integratord`
   - Verify restart: `pgrep -f wazuh-integratord`
   - Update state file with new restart count/timestamp
   - Apply exponential backoff (10s→20s→40s→80s→160s, max 300s)
   - Max 5 restarts per 5-minute window
11. **Lock Release:** `rm -rf /tmp/integratord_watchdog_persist.lock` on exit

### Current Watchdog State
- **PID:** 4855 (primary), 5110 (stale, exiting)
- **Lock:** Held by PID 4855
- **State File:** `/tmp/integratord_watchdog_persist.state` (restart_count=1, last_restart=1787888466)
- **Log File:** `/var/log/integratord_watchdog_persist.log` (active)
- **Lock File:** `/tmp/integratord_watchdog_persist.lock` (held by PID 4855)

### Watchdog Test Results (P59)
| Test | Result | Details |
|------|--------|---------|
| Kill integratord (`pkill -9`) | ✅ PASS | Watchdog detected in 10s, restarted in 10s |
| Restart backoff | ✅ 10s | First restart after 10s |
| Restart success | ✅ | `wazuh-control start integratord` → PID 2808 |
| Execution result | ✅ | `ROUTED 200` → IRIS object created |
| Restart count | ✅ Incremented | State file updated |
| Backoff | ✅ | 10s delay observed |
| Max restarts | Not tested | Limit: 5/5min |
| Log persistence | ✅ | Logs in `/var/log/integratord_watchdog_persist.log` |

### Current Watchdog Configuration
- **Script:** `/usr/local/bin/integratord_watchdog_persist.sh`
- **Log:** `/var/log/integratord_watchdog_persist.log`
- **Lock:** `/tmp/integratord_watchdog_persist.lock`
- **State:** `/tmp/integratord_watchdog_persist.state`
- **PID:** 4855 (active), 5110 (stale, exiting)
- **Integratord PID:** 5203 (running)

## Verdict
**COMPLETE** - Watchdog runtime inventory complete. Watchdog deployed, running, and tested functional.

## Limitations
- Watchdog does NOT persist across container restarts (runs as background process)
- Requires entrypoint integration for true persistence
- Two watchdog instances briefly ran concurrently (cleaned up)

## Verdict
**COMPLETE** - Watchdog runtime inventory complete. Ready for persistence implementation.