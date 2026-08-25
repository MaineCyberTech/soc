# Phase 37-38: Post-Restart Error Verification

**Status:** COMPLETE  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Summary

| Metric | Value |
|---|---|
| Post-restart error rate | ~100/min |
| Post-restart errors (18 min) | 1,830 |
| Pre-restart error rate | ~100/min (similar) |

## Conclusion

decoder_order_size=512 did **NOT** resolve the "Too many fields" issue.

The Suricata stats events have more than 512 parseable fields as seen by the decoder. Remaining failures are **active and accumulating**.

## Next Steps

See Phase 37-39 (stats minimization) and Phase 37-41 (field limit increase plan).

## No secrets
