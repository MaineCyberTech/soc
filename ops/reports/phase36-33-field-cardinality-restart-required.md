# Phase 36: Field Cardinality Restart Required

Date: 2026-08-25

## Restart required
- Wazuh manager needs restart for decoder_order_size to take effect
- Restart scope: /var/ossec/bin/wazuh-analysisd only (not full manager)

## Impact
- Brief analysisd pause (~2-5 seconds)
- Events during restart: buffered by agents, no loss
- Analysisd queue: may briefly spike but recovers

## Status: APPLIED
- Config applied via `docker cp` to master container
- analysisd restarted (PID 66961)
- decoder_order_size=512 active

## No secrets
