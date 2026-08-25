# Phase 37 — Shuffle Exposure Apply

**Date:** 2026-08-25T19:28Z  
**Status:** ⏸ PENDING — Operator approval required  
**Blocked by:** Operator approval

---

## Objective

Apply iptables rule to restrict Shuffle frontend (port 3001) to localhost-only access.

---

## Current State

| Attribute | Value |
|-----------|-------|
| Frontend bind | 0.0.0.0:3001 |
| Firewall rules on 3001 | None |
| Exposure | All network interfaces |
| Risk | HIGH — plaintext HTTP accessible from any source |

---

## Planned Action

1. Apply iptables rules per plan in phase37-06
2. Persist rules across reboot
3. Validate localhost access works
4. Validate external access is blocked
5. Document operator SSH tunnel procedure

---

## Execution Status

| Step | Status |
|------|--------|
| Plan documented | ✅ phase37-06 |
| Operator approval | ⏸ PENDING |
| iptables rules applied | ⏸ Not yet |
| Rules persisted | ⏸ Not yet |
| Localhost validation | ⏸ Not yet |
| External validation | ⏸ Not yet |

---

## No secrets
