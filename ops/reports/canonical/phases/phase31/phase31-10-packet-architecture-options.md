# Phase 31 Packet Architecture Options

Date: 2026-08-24
Status: **COMPARED (facts vs hypotheses separated)**.

| Option | Memory estimate | Facts/evidence | Verdict |
|---|---|---|---|
| **Suricata-minimal** | ~31MB measured (cgroup) | **BENCHMARKED this phase** (16): 102K pkts, 0 drops, ~1.1% CPU, 70 alerts | **PROVEN feasible < 2GiB** (light profile) |
| Zeek-minimal | higher (multi-worker guidance) | NOT benchmarked; published guidance suggests higher memory | CANDIDATE (needs benchmark) |
| Network-device IDS/flow logs | low (no local capture) | NetFlow (flowcoll) running; device syslog/IDS unverified | COMPLEMENT |
| Endpoint-local sensing | low | endpoint agents existing | COMPLEMENT |
| Scheduled PCAP | storage-heavy | contravenes no-PCAP rule | REJECTED |
| No packet sensor | n/a | visibility gap documented (21) | fallback |

## Facts vs hypotheses

- FACT: Suricata 7.0.10 minimal measured 31MB/0-drops under the lab profile (this phase).
- HYPOTHESIS: production LAN (192.168.111.0/24) performance at full volume - UNPROVEN
  (requires approved SPAN mirror).

## No secrets