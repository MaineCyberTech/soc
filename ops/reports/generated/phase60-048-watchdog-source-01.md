# Phase 60: Watchdog - Persistence Proof and Container Restart Test

**Actual UTC:** 2026-08-28T12:00:00Z
**ET:** 2026-08-28 08:00:00 EDT
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

### Persistence Test Plan (Requires Restart Gate)

#### Test Plan
| Step | Action | Expected | Status |
|------|--------|----------|--------|
| 1 | Build new Wazuh image with watchdog entrypoint | Image builds successfully | ⏳ PENDING GATE |
| 2 | Deploy to staging | Service starts, watchdog auto-starts | ⏳ PENDING |
| 3 | Verify watchdog running | `pgrep -f integratord_watchdog_persist` | ⏳ |
| 4 | Verify integratord running | `wazuh-integratord` running | ⏳ |
| 5 | Kill integratord | `pkill -9 wazuh-integratord` | ⏳ |
| 6 | Watchdog detects | Watchdog logs detection | ⏳ |
| 7 | Watchdog restarts | `wazuh-control start integratord` | ⏳ |
| 8 | Verify recovery | `wazuh-integratord` running, webhook works | ⏳ |
| 8 | **Container restart** | `docker restart <container>` | ⏳ |
| 9 | Verify watchdog auto-starts | `pgrep -f integratord_watchdog` | ⏳ |
| 10 | Verify integratord auto-starts | `wazuh-integratord` running | ⏳ |
| 11 | Test webhook | POST to webhook → ROUTED 200 | ⏳ |

#### Entrypoint Integration Design
```dockerfile
# In Wazuh manager Dockerfile
COPY integratord_watchdog_persist.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/integratord_watchdog_persist.sh

# Create entrypoint wrapper
RUN echo '#!/bin/bash\nset -e\n/usr/local/bin/integratord_watchdog_persist.sh &\nWATCHDOG_PID=$!\nexec /original-entrypoint.sh "$@"\ntrap "kill $WATCHDOG_PID 2>/dev/null; exit" EXIT TERM INT\nwait $WATCHDOG_PID' > /entrypoint-with-watchdog.sh
RUN chmod +x /entrypoint-with-watchdog.sh

ENTRYPOINT ["/entrypoint-with-watchdog.sh"]
```

#### Persistence Requirements
| Requirement | Implementation |
|-----------|----------------|
| Lock persistence | `/var/lock/integratord_watchdog.lock` (not `/tmp`) |
| State file | `/var/lib/integratord-watchdog/state` (persistent volume) |
| Log file | `/var/log/integratord_watchdog_persist.log` (already persistent) |
| Lock cleanup | `rm -rf /var/lock/integratord_watchdog.lock` on exit |

#### Volume Mounts Required
```yaml
# In docker-compose.yml or docker service update
volumes:
  - integratord-watchdog-lock:/var/lock/integratord_watchdog
  - integratord-watchdog-state:/var/lib/integratord-watchdog
  - integratord-watchdog-logs:/var/log/integratord-watchdog
```

### Restart Gate Status
- **Status:** NOT APPROVED
- **Required Approval:** Owner sign-off for container image rebuild + service update
- **Risk:** Container rebuild + service update (~30s downtime)
- **Rollback:** `docker service update --image wazuh/wazuh-manager:4.14.7`

### Current Status
- **Watchdog Script:** Ready at `/usr/local/bin/integratord_watchdog_persist.sh`
- **Runtime Deployment:** Working (PID 4855)
- **Persistence:** NOT YET IMPLEMENTED (requires container rebuild)
- **Gate Status:** RESTART GATE - PENDING APPROVAL

## Verdict
**DESIGN COMPLETE - PENDING RESTART GATE** - Persistence design complete. Implementation requires container rebuild and owner approval.

## Limitations
- Requires Wazuh manager image rebuild
- Requires service update (brief downtime)
- Requires persistent volumes for lock/state
- Requires testing in staging before production

## Verdict
**DESIGN COMPLETE - PENDING RESTART GATE** - Persistence design complete. Implementation pending restart gate approval.