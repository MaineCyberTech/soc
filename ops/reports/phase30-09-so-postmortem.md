# Phase 30 Security Onion Outage - Postmortem

Date: 2026-08-24

## Timeline

- **2026-08-24 ~18:59Z**: agent 008 last keepalive; SO VM unreachable (100% ping loss
  persists to review time 21:57Z). Healthcheck 2 FAIL (SO VM + suricata). CI "action
  required" (agent 008) from this point.
- Detection: full-stack-healthcheck + CI agent check (reported P29 20:22Z, confirmed P30).

## Root cause

- **SO VM offline** (external host). Not caused by stack changes. Recovery path (Proxmox)
  currently blocked: PVE API credentials in creds.env fail authentication and PVE222 API
  token is missing - operator action required to recover the VM.

## Impact

- Packet ingest (Zeek/Suricata) from SO unavailable during the outage.
- No backlog flood: agent 008 down, no queued flood at intake (alerts/archives stable,
  cluster green). No case-routing impact (0 real Class A cases).

## Detection / response gaps

- Healthcheck detects the VM (good) but no active alerting on agent 008 disconnection
  beyond CI (observability SLO item, 74).
- PVE credential/token absent prevented self-service recovery.

## Recovery plan

1. Operator: restore PVE access (password or least-privilege token).
2. Start SO VM via Proxmox (04), validate services (05), agent reconnect (06),
   Zeek/Suricata recovery (07), flood check (08).

## Preventive actions

- Maintain a working PVE token (least-privilege) + document recovery runbook (Phase 31).
- Add agent-008 disconnect alerting beyond CI.

## Owner

- MCT ops (operator) for VM recovery; SOC for validation after.

## No secrets