# Phase 45: Monitor Watchdog and Rotation

## Watchdog Components
| Component | Purpose | Interval |
|-----------|---------|----------|
| **Stale Detection** | Detect stale executions (> 5 min EXECUTING) | 1 min |
| **Self-Failure** | Detect monitor process crash | 1 min |
| **Repeat Guard** | Prevent duplicate reconciliation | Per-slot |
| **Recovery** | Auto-restart on failure | Immediate |
| **Logrotate** | Manage monitor logs | Daily |
| **State Bounds** | Validate state machine integrity | Per execution |
| **Permissions** | Least privilege for monitor | Static |
| **Persistence** | State survives restart | On-write |

## Stale/Self-Failure Detection
| Check | Threshold | Action |
|-------|-----------|--------|
| **Stale Execution** | > 5 min in EXECUTING | Alert + kill |
| **Monitor Heartbeat** | Missed 2 consecutive intervals | Alert + restart |
| **API Unreachable** | 3 consecutive failures | Alert + backoff |

## Repeat Guard
| Guard | Mechanism |
|-------|-----------|
| **Per-Slot Lock** | File-based lock per reconciliation slot |
| **Idempotency Key** | Slot timestamp + hash |
| **Duplicate Detection** | Skip if lock exists |

## Recovery Procedures
| Failure | Recovery | Verification |
|---------|----------|--------------|
| Monitor crash | systemd restart | Process running |
| API unreachable | Exponential backoff | API responsive |
| Stale execution | Kill + re-queue | Execution completes |
| Log corruption | Truncate + rotate | Logs clean |

## Logrotate Configuration
```bash
# /etc/logrotate.d/monitor
/opt/mct-security-stack/ops/logs/monitor/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0640 monitor monitor
    sharedscripts
    postrotate
        systemctl reload monitor > /dev/null 2>&1 || true
    endscript
}
```

## State Bounds Validation
| State | Valid Transitions | Invalid |
|-------|-------------------|---------|
| PENDING | → EXECUTING, FAILED | → COMPLETED |
| EXECUTING | → COMPLETED, FAILED | → PENDING |
| COMPLETED | (terminal) | Any |
| FAILED | → RETRY (if applicable) | → COMPLETED |

## Permissions
| Component | User | Group | Permissions |
|-----------|------|-------|-------------|
| Monitor process | `monitor` | `monitor` | 0750 |
| Log files | `monitor` | `monitor` | 0640 |
| Config files | `root` | `monitor` | 0640 |
| State files | `monitor` | `monitor` | 0600 |

## Persistence
| State | Storage | Survives Restart |
|-------|---------|------------------|
| Slot locks | File system | Yes (until TTL) |
| Reconciliation state | JSON file | Yes |
| Counters | Shuffle cache | No (Redis) |
| Execution cache | Shuffle cache | No (Redis) |

## Verification Checklist
| Check | Method | Pass/Fail |
|-------|--------|-----------|
| Stale detection works | Inject stale execution | [PASS/FAIL] |
| Self-failure detected | Kill monitor process | [PASS/FAIL] |
| Repeat guard works | Run same slot twice | [PASS/FAIL] |
| Recovery works | Kill monitor | [PASS/FAIL] |
| Logrotate works | force rotate | [PASS/FAIL] |
| State bounds enforced | Inject invalid transition | [PASS/FAIL] |
| Permissions correct | `ls -la` | [PASS/FAIL] |
| State persists | Restart monitor | [PASS/FAIL] |

## Evidence
- [ ] Stale detection tested
- [ ] Self-failure detection tested
- [ ] Repeat guard tested
- [ ] Recovery tested
- [ ] Logrotate configured
- [ ] State bounds enforced
- [ ] Permissions correct
- [ ] Persistence verified

## Verdict
**WATCHDOG: [PASS/PARTIAL/FAIL]**

---
*Generated: 2026-08-27T04:28:00Z (UTC) / 2026-08-27T00:28:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after monitor reconciliation (Phase 45-54)*
