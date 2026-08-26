# Phase 31 Suricata Resource Profile

Date: 2026-08-24
Status: **VALIDATED (config gate PASS + benchmark)**.

## Profile (integrations/suricata-minimal/suricata.yaml)

| Control | Value |
|---|---|
| max-pending-packets | 1024 (low memory trade-off) |
| runmode | autofp; detect-thread-ratio 1.0 |
| detect-engine profile | low |
| flow.memcap | 64MiB; prealloc 10000 |
| stream.memcap | 32MiB; defrag 32MiB |
| app-layer | http/dns/tls/ssh only (others disabled) |
| ring-size/buffer | 250 / 24KiB |
| systemd MemoryMax | 1536M (sub-2GiB) |

## Gate + measurement

- `suricata -T -c` config gate: **PASS** ("Configuration successfully loaded"; 4 rules).
- Benchmark (16): **31MB cgroup** (MemoryPeak 31MB), CPU ~1.1%, **0 drops** over ~102K pkts.

## No secrets