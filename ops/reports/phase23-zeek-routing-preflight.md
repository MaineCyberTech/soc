# Phase 23 Zeek Class A Routing Preflight

Date: 2026-08-22
Status: **READY TO ENABLE - APPROVAL PENDING** (C3 gate).

## 1. v2.2 clean counts (24h)

- Total Zeek: **316** (122000: 273, 122006: 29, 122005: 13, 122001: 1, 122002/122003: 0).
- Clean-window evidence holds (~316/day since deploy; pre-tuning 417K/24h).

## 2. Class A logtest + live evidence

- logtest (P22): SSH/SMB/RDP all fire at level 8. Live: 122001 fired (1/24h); SMB/RDP 0.
- Guards verified (multicast/broadcast/subnet-broadcast excluded).

## 3. Shuffle / IRIS health

- Shuffle backend+frontend UP (auto-repair cron working). IRIS 8443 listening, containers healthy.

## 4. Duplicate-case protection / rate limits

- **GAP**: no duplicate-case protection or rate-limit control documented in existing routing
  plans. Add to the enable: Shuffle workflow dedup on (rule.id+src+dst+hour) + case-rate
  threshold (stop at 5 cases/day) + alert-to-operator on exceed.

## 5. Rollback

- Disable the webhook filter in Shuffle; IRIS stops receiving Zeek cases. Workflow export
  retained before change.

## 6. Case template / approval

- Template: `integrations/dfir-iris/phase20-zeek-case-template.md` (current). Approval: C3
  pending (approval marker required before enable).

## 7. Preflight verdict

- **READY** with one condition: add duplicate-case + rate-limit controls at enable time.

## No secrets