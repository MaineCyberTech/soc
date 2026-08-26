# Phase 37-42: Field Limit Apply

**Status:** NOT YET APPLIED  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Current

decoder_order_size = **512**

## Proposed

decoder_order_size = **1024** (contingency if stats minimization insufficient)

## Approval

Approval-gated. Not applied pending:
1. Stats minimization attempt (Phase 37-39)
2. Owner approval

## Apply Procedure

1. Update `/var/ossec/etc/local_internal_options.conf`
2. Restart analysisd: `systemctl restart wazuh-analysisd`
3. Verify PID change and zero errors

## No secrets
