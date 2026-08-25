# Phase 35: Performance and Efficiency Audit

Date: 2026-08-25

## CPU
- Load average: 0.30 / 0.14 / 0.10 (very low)
- 1/489 tasks running

## Memory
- Total: 5,831MB
- Used: 2,563MB (44%)
- Available: 3,268MB (56%)
- Swap: 602MB / 8,192MB (7%)

## PSI (Pressure Stall Information)
- CPU: avg10=0.00, avg60=0.00, avg300=0.00 — no stalls
- Memory: avg10=0.00, avg60=0.00, avg300=0.00 — no stalls
- IO: avg10=0.00, avg60=0.00, avg300=0.00 — no stalls

## Packet/drop counters
- Suricata kernel_drops: 0
- Suricata kernel_ifdrops: 0
- Suricata memory: 74MB (stable)

## EVE/Wazuh rates
- eve.json: ~1,125 lines (stats events every 5s)
- eve-alert.json: 2 lines (1 synthetic + 1 real alert)
- Agent 016 logcollector: eve.json 14 events/109KB, eve-alert.json 1 event/666 bytes

## Queues (analysisd)
- All queues at 0.00% usage
- events_dropped: 0
- "Too many fields" errors from stats records (non-fatal)

## Disk
- 85% (LOW WATERMARK) — performance impact: none currently

## /tmp
- 1.6GB on tmpfs (21%) — RAM-backed, no disk I/O impact

## Timer overlap
- No timer conflicts detected
- core-alert (15min) + shuffle-repair (15min) + zeek-classa (15min) — staggered

## Avoidable work
- Stats records generating "Too many fields" errors — fix by increasing decoder_order_size to 512

## PASS — System performing efficiently
## No secrets
