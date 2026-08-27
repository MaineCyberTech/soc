# Phase 46: Hook Registration

## Purpose
Document hook registration state, URL, validity, and relationship to trigger.

## Hook State

| Field | Value |
|-------|-------|
| Hook endpoint | `POST /api/v1/hooks/p39-suricata-test` |
| Hook ID | Derived from trigger custom_url `p39-suricata-test` |
| Registered | Yes (exists in Shuffle backend) |
| Active | **NO** — trigger stopped |
| Valid | **NO** — returns "Hook ID not valid" when trigger stopped |

## Registration Chain

```
Trigger (ID: 736b7410…)
  └─ custom_url: p39-suricata-test
       └─ Hook: /api/v1/hooks/p39-suricata-test
            └─ Status: stopped → hook invalid
            └─ Status: started → hook valid
```

## Validity Matrix

| Trigger Status | Hook Valid | Can Receive Events |
|----------------|------------|-------------------|
| stopped | NO | NO |
| started | YES | YES |

## Hook URL Construction
- Base: `https://192.168.222.149:3443`
- Path: `/api/v1/hooks/p39-suricata-test`
- Full: `https://192.168.222.149:3443/api/v1/hooks/p39-suricata-test`

## Registration Verification
| Check | Result |
|-------|--------|
| Hook exists in backend | Yes (returns "Hook ID not valid" not "Not found") |
| Hook accepts POST | Only when trigger started |
| Hook requires auth | No (public webhook) |
| Hook rate limiting | Unknown |

## Status
- Hook is **registered** but **inactive** (trigger stopped)
- Requires trigger start via UI to become active
- No API to register/unregister hooks independently

## Verification
- [ ] Hook endpoint documented
- [ ] Validity matrix accurate
- [ ] Chain from trigger to hook clear
- [ ] No invented endpoints

---
*Generated: 2026-08-27T06:18:00Z (UTC) / 2026-08-27T02:18:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
