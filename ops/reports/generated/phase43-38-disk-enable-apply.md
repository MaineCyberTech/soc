# Phase 43: Disk Threshold Apply

**Report ID:** phase43-38-disk-enable-apply.md
**Phase:** 43
**Title:** Phase 43 Disk Threshold Enable Apply
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T17:30:00Z
**Classification:** INTERNAL
**Status:** PENDING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-38-disk-enable-apply.md`

---

## 1. Purpose

Document the application of the disk threshold decision (if owner chooses to enable).

---

## 1. Pre-Apply Checklist

| Check | Status |
|-------|--------|
| Owner approval obtained | [ ] YES / [ ] NO |
| Backup current settings | [ ] DONE |
| Rollback plan documented | [ ] YES |
| Maintenance window scheduled | [ ] YES / NO |

---

## 2. Apply Commands (If Approved)

```bash
# Enable thresholds
curl -sk -u admin:[REDACTED-PW] -X PUT "https://127.0.0.1:9200/_cluster/settings" \
  -H 'Content-Type: application/json' \
  -d '{"persistent":{"cluster.routing.allocation.disk.threshold_enabled":true}}'

# Verify
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cluster/settings?include_defaults=true" | grep threshold_enabled
```

---

## 3. Rollback Plan

```bash
# Disable if issues arise
curl -sk -u admin:[REDACTED-PW] -X PUT "https://127.0.0.1:9200/_cluster/settings" \
  -H 'Content-Type: application/json' \
  -d '{"persistent":{"cluster.routing.allocation.disk.threshold_enabled":false}}'
```

---

## 3. Status

**PENDING-OWNER** — Awaiting owner decision (G43-14 / G43-25). Current recommendation: **Accept Advisory** (Option B).