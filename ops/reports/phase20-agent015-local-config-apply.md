# Phase 20 Agent 015 Local Config Apply and Rollback

Date: 2026-08-19
Status: **BLOCKED BY ENDPOINT ACCESS** - no remote path to Julians-Air (192.168.111.77, macOS). Agent still disconnected since 08-18 09:04 UTC.

## 1. Local access confirmation

- Wazuh API: agent 015 `disconnected` (lastKeepAlive 08-18 09:04). No SSH/remote route to
  the Mac from the stack host (client network 192.168.111.0/24 not routable; no jump host).
- No agent-local access. Same blocker as Phase 19.

## 2. Operator handoff (unchanged, still valid)

Exact steps are in Phase 19 deliverables (still current):
- `integrations/macos/phase19-macos-local-ossec-config.md` - config change
- `integrations/macos/phase19-agent015-operator-steps.md` - command block
- `integrations/macos/phase19-agent015-rollback.md` - rollback
- `ops/reports/phase19-macos-flood-remediation.md` - before/after windows

Phase 20 final config + rollback documents (this pack) consolidate these:
- `integrations/macos/phase20-agent015-final-config.md`
- `integrations/macos/phase20-agent015-rollback.md`

## 3. What SOC can confirm remotely (done)

- Flood baseline unchanged: archives ~1.2-1.4M/day while online; peak 127K/hr.
- Agent offline since 08-18 09:04 (24h+). No volume change possible until operator applies fix.

## 4. Rollback contract

Restore `/Library/Ossec/etc/ossec.conf.phase19.bak`, restart agent. See phase20 rollback doc.

## Owner / next action

- Owner: operator with Mac access. On apply, agent reconnects within ~2 min; SOC runs
  Phase 20.03/20.04 validation.

## No secrets