# Phase 37-35: Field Baseline

**Status:** COMPLETE  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Configuration

- **Parameter:** decoder_order_size=512
- **Active since:** 19:10Z
- **Analysisd PID:** 66961
- **Restart time:** 19:10Z

## Error Counts

| Period | Error Count |
|---|---|
| Before restart (hour 18) | 10,980 |
| After restart (19:10–19:28) | 1,830 |
| **Total** | **18,849** |

## Rate

~100 errors/min (post-restart window: 1,830 in 18 min)

## Resource Usage

- CPU: 0.3%
- Memory: 85MB
- Queue: 0%
- Indexing: active

## Conclusion

decoder_order_size=512 is **NOT sufficient** for Suricata stats events. The "Too many fields" errors continue to accumulate at ~100/min.

## No secrets
