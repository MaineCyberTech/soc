# Phase 22 Agent 015 macOS Repair Apply

Date: 2026-08-22
Status: **BLOCKED - MAC ACCESS REQUIRED** (no remote path to Julians-Air; agent offline since 08-18 09:04). No apply performed; no success claimed.

## 1. Access check

- No SSH/remote path to 192.168.111.77 from the stack host. Agent 015 disconnected.
- **Apply NOT performed.**

## 2. Handoff bundle (packaged, ready)

Location: `integrations/macos/remediation-bundle/`

```bash
# Copy bundle to the Mac, then:
sudo ./repair-agent015-unified-log.sh --check     # review what will change
sudo ./repair-agent015-unified-log.sh --apply     # backup + bounded config + restart
sudo ./verify-agent015.sh                          # local verification
# Rollback if needed:
sudo ./rollback-agent015.sh --list
sudo ./rollback-agent015.sh --apply <backup>
# Diagnostics (offline):
./collect-agent015-diagnostics.sh /tmp
```

## 3. Expected outcomes (to validate post-apply)

- Backup written to `/Library/Ossec/etc/mct-backups/ossec.conf.<TS>.bak`.
- Unbounded macOS localfile replaced by bounded query (MCT-PHASE22 marker).
- Agent reconnects within ~2 min; volume drops >=95% vs ~1.4M/day flood baseline.
- Useful events (auth/sudo/loginwindow/securityd) continue.

## 4. Verification after operator applies

- Phase 22.08 reconnect/volume/queue validation (keepalive, mac-clients group, 15m/1h/24h
  volume, queue-full, bounded telemetry presence, >=95% reduction).

## 5. Decision

- **BLOCKED** (Mac access). Handoff packaged + documented. No success marked.

## No secrets