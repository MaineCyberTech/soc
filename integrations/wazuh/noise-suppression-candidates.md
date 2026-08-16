# Noise Suppression Candidates (Phase 4)

Measured 2026-08-11 (24h window, 520,670 alerts total). Candidates ordered by leverage.

| rank | rule | count/24h | % of total | type | suppression |
|---|---|---|---|---|---|
| 1 | 24010 osquery inventory | 263,490 | 50.6 | expected telemetry | APPLIED (level 0) |
| 2 | 120520 roaming handoff | 54,896 | 10.5 | wifi churn | propose C digest |
| 3 | 120527 unknown device | 51,749 | 9.9 | inventory (MAC list gap) | add MACs to known-devices; then C |
| 4 | 120518 LAN dropped | 19,056 | 3.7 | routine firewall | propose C digest |
| 5 | 120501 WAN blocked | 18,667 | 3.6 | routine drops | propose C digest (flood stays B) |
| 6 | 120531/120532 client kicked | 23,013 | 4.4 | churn | propose C digest |
| 7 | 120521 WPA replay | 15,148 | 2.9 | client misbehavior | propose C digest (storm 120524 stays B) |
| 8 | 120537 mctportal warn/error | 10,281 | 2.0 | app logs | dedupe/digest C |
| 9 | 120509/120510 connect/disconnect | 12,294 | 2.4 | churn | propose C digest |
| 10 | 120535/120559 Sentry init/ACME | ~1k | 0.2 | benign | propose D archive |

## Notes

- Applying 24010 suppression alone removes ~50.6% of alert volume.
- UniFi family total: ~238k (45.7%) - digest routing would remove most of the
  remaining analyst load without losing alert records.
- mctportal security-relevant rules (120556 privilege-drop, 120558 upstream
  failure) are NOT candidates.
- auditd 80710 (3.2k, level 10) intentionally NOT suppressed (Class B).
