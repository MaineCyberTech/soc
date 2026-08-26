# Phase 36: Field Cardinality Fix Applied

Date: 2026-08-25

## Action taken
- Created /var/ossec/etc/local_internal_options.conf on manager
- Added: analysisd.decoder_order_size=512
- Requires Wazuh manager restart to take effect

## File content
```
analysisd.decoder_order_size=512
```

## Verification
- File exists at correct path
- Content correct
- Awaiting restart

## Safety
- local_internal_options.conf is not overwritten by upgrades
- Revert: remove file or set back to 256

## No secrets
