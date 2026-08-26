# Phase 31v2 Capture Offloads (ens19)

Date: 2026-08-24
- rx-checksumming on [fixed]; **GRO off**; LRO off [fixed]; rx-gro-hw on; rx-gro-list off.
- GRO/LRO off is appropriate for capture (avoids merged-fragment checksum artifacts).
- No checksum validation errors observed (decoder invalid 0). Leave offloads as-is; no change.

## No secrets
