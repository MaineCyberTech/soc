# Phase 37-43: Field Resolution

**Status:** RESOLUTION PENDING  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Options

| Option | Description | Wazuh Change Required |
|---|---|---|
| (a) Suricata stats minimization | Reduce stats fields at source | No |
| (b) Increase decoder_order_size to 1024 | Raise decoder limit | Yes |
| (c) Combined | Minimization + increase | Yes |

## Decision

Try **(a) first**, then **(b)** if needed.

## Proof of Resolution

Zero "Too many fields" errors sustained for 30+ minutes post-change.

## No secrets
