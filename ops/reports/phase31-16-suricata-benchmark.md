# Phase 31 Suricata Benchmark

Date: 2026-08-24
Tooling: p31-sensor-benchmark.sh (systemd sampling) + eve.json stats.

## Measured results (real, not estimated)

| Metric | Value | Ceiling | PASS |
|---|---|---|---|
| MemoryCurrent (cgroup) | 30.5 - 30.8 MB | < 2 GiB | **PASS** |
| MemoryPeak (cgroup) | 31 MB | < 2 GiB | **PASS** |
| CPU (avg) | ~1.1% (1.7s->3.4s over 150s) | < 50% | **PASS** |
| Kernel packets captured | 102,233 | - | - |
| Kernel drops | **0** | no sustained drops | **PASS** |
| Decoder invalid | 0 | - | PASS |
| Flow memcap drops | 0 | - | PASS |
| Alerts generated | 70 | bounded | PASS |
| eve.json size | 1.3 MB / ~102K pkts | bounded | PASS |
| Host PSI | 0.00 (target) | no pressure | PASS |

## Profile

- Traffic: target's own outbound HTTP/DNS/ping + LAN light profile (~102K packets/150s).
- **Caveat (honest)**: this is a real measurement under a light profile - NOT a
  production-grade client LAN mirror. Production capacity remains UNPROVEN until an approved
  SPAN mirror provides full-volume traffic (no simulated production PASS).

## Verdict

- **PASS vs sub-2GiB ceiling** at the measured profile; production-volume proof gated on SPAN.

## No secrets