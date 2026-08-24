
## Approval resolution (2026-08-24, operator "approve all")

- **GRANTED + EXECUTED**: image pinning apply (05) - all 8 mutable refs pinned; v1.3.0
  release (67) - tag + release id 375979989 + asset.
- **GRANTED + ATTEMPTED/ROLLED BACK**: indexer rotation (50) - hash step no-op; rolled back
  cleanly; deferred to maintenance window.
- **GRANTED but BLOCKED on non-approval prerequisites** (not approval): endpoint markers
  (11/13 - operator RMM on endpoints), PS4104 pilot (18 - endpoint action), Shuffle UI
  (22-26 - API cannot add nodes; browser action), NetFlow alerts (54 - needs scope
  classification 53), Greenbone (56 - signed auth doc), VT key (49)/PVE token (51 -
  replacement), Redis (55 - owner).
- **ACCEPTED**: Security Onion VM off (healthcheck/CI show the environmental check until SO returns).

## No secrets
