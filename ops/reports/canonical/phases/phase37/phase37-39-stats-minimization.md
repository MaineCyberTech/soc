# Phase 37-39: Suricata Stats Minimization Design

**Status:** DESIGN  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Objective

Reduce the field count of Suricata stats events to below 512, eliminating "Too many fields" decoder errors without increasing the decoder_order_size limit.

## Approach

Modify `/etc/suricata/suricata.yaml` on the sensor (agent 016) to configure `outputs.eve-log.types`:

### Option A: Exclude Stats Entirely

Remove `stats` from the eve-log types list. Stats events will no longer be emitted.

### Option B: Minimize Stats Fields (Preferred)

Configure Suricata to emit only summary stats instead of the full stats dump. Target categories:

- Drop counters (tcp, udp, other)
- Alert counters (total, denied, accepted)
- Packet counters (received, processed, bytes)
- Flow counters (active, new, closed)
- Uptime

Estimated field count: **20–30 fields** (well below 512).

## Recommendation

Option B preferred — retains visibility into key operational metrics while eliminating the field count problem.

## No secrets
