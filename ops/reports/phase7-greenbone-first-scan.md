# Phase 7 Greenbone First Scan

Date: 2026-08-12
Status: **READY - scan scheduling is an operator action via GSA (documented procedure)**

## State

- gvmd: healthy (42h)
- GSA: up, bound 127.0.0.1:443 on VM103 (SSH tunnel access documented)
- Admin credential: GREENBONE_ADMIN_PASSWORD in .env (not printed)
- GMP CLI: not installed (GSA UI is the path)
- Schedule config: MCT-core-infra-monthly defined (Phase 6)

## Blocker

- Schedule creation + first scan launch requires GSA login (operator action).
- Critical alert -> Shuffle webhook config also via GSA.

## Next action

Operator follows gsa-ui-procedure.md steps 1-7; then export report + fill
vulnerability review.
