# Phase 37-41: Field Limit Increase Plan

**Status:** CONTINGENCY PLAN  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Trigger

If Suricata stats minimization (Phase 37-39) is insufficient to resolve "Too many fields" errors.

## Plan

Increase `decoder_order_size` from 512 to **1024**.

### Steps

1. Update `/var/ossec/etc/local_internal_options.conf`
2. Restart analysisd (PID 66961)
3. Verify zero "Too many fields" errors

### Risks

- Higher memory per event on analysis daemon

### Backup

- Current value: 512 (documented in Phase 37-35)

### Validation

- Run logtest with full stats event
- Monitor error rate for 30 minutes post-change

### Rollback

- Restore `decoder_order_size=512` in local_internal_options.conf
- Restart analysisd

## No secrets
