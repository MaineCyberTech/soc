# Phase 37 — Shuffle Exposure Validate

**Date:** 2026-08-25T19:28Z  
**Status:** ⏸ PENDING — Blocked on phase37-07  
**Blocked by:** phase37-07 (exposure apply not yet executed)

---

## Objective

Validate that iptables lockdown of Shuffle frontend (port 3001) is effective.

---

## Planned Validation Steps

| Step | Check | Expected |
|------|-------|----------|
| 1 | `iptables -L INPUT -n \| grep 3001` | Rules present |
| 2 | `curl http://127.0.0.1:3001/` | HTTP 200 (login page) |
| 3 | `curl http://<external-ip>:3001/` | Timeout / connection refused |
| 4 | SSH tunnel test | Accessible via `ssh -L 3001:127.0.0.1:3001` |
| 5 | Persistence check after reboot | Rules survive restart |

---

## Current Status

| Step | Status |
|------|--------|
| All validation | ⏸ Blocked — phase37-07 not executed |

---

## No secrets
