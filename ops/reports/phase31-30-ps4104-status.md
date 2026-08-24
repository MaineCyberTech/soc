# Phase 31 PowerShell 4104 Pilot - Approval

Date: 2026-08-24
Status: **APPROVAL PENDING** (C5). No enablement performed.

## Pilot design

- Endpoint: **012 MCT-WIN11PILOT** only (pilot; not client fleet).
- Privacy: 4104 contains script blocks; collection restricted to event fields, no content
  exfiltration; access limited to SOC admins; data retention bounded (alerts policy).
- Rules: existing 4104-related detection rules reviewed; no new fleet-wide rule.
- Retention: collected events fall under standard alerts retention (30d).
- Rollback: disable the 4104 collection policy on 012; verify no collection within 1h.

## Approval checklist (operator)

- [ ] Pilot endpoint confirmed
- [ ] Privacy/access/retention accepted
- [ ] Rollback understood

## No secrets