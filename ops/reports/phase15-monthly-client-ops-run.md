# Phase 15 Monthly Client Ops Run

Date: 2026-08-16
Type: CLIENT-AWARE (2 client endpoints)

## 1. Health

- full-stack-healthcheck: PASS (0 FAIL)

## 2. Capacity

- Thin pool: 87.84% (stable). Host RAM: 4.4Gi available.

## 3. Backups

- Config: valid 146KB (06:31). S3: 37 snapshots (05:47). vm103 dumps in policy.

## 4. Endpoint counts (client-aware)

- Total agents: 8 (6 internal + 2 client)
- **Client 013 SAMSUNG** (Windows 11, .166): ACTIVE but device offline at check
  (disconnected - workstation powered off)
- **Client 014 DESKTOP-MI54LFT** (Windows 11, .162): ACTIVE, new 07:03 UTC,
  Sysmon flowing (508 events/30m)
- Billable: 2 | Internal: 6

## 5. Alert quality

- 013: 1,301/24h, no threats. 014: new, 508/30m, 0 threats.
- Suppressed-rule alerts (92153/92900): 0 from both - validation window open.

## 6. Vulnerability

- Greenbone lab: proven (a2020145). Client scan: not authorized.

## 7. Scorecard

- Cycle running (013: to 09-15). 014 baseline to add.

## 8. Billing

- Billable: 2 (013 since 08-16; 014 since 08-16 07:03).

## 9. Communication

- Templates ready. First scorecard at 09-15.

## 10. Retrospective

- 2 client endpoints operational; Level.io deployment scaling.
- Suppression validation getting live test events via 014.
- Watch: 013 device power cycles, ES snapshot cleanup approval, scan auth.

## No secrets
