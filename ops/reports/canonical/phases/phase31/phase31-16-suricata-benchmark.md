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
## PRODUCTION SPAN BENCHMARK (2026-08-24, SPAN added to soc-scan by operator)

- Capture: ens19 (SPAN mirror) - real multi-VLAN traffic (192.168.111.0/24 client LAN,
  192.168.123/222, 10.10.202; SSDP/mDNS/ARP/STP/broadcasts). Sustained ~90 pps.
- **MemoryCurrent min/avg/max: 31.77 / 31.94 / 32.06 MB; MemoryPeak 32.45 MB** (< 2 GiB PASS)
- **CPU: 0.79% avg** (312s)
- **Kernel packets captured: 16,523; drops: 0**; decoder invalid 0
- **Alerts: 0 on real SPAN traffic** (focused ruleset does not fire on this profile - zero
  false positives; detection coverage limited - see 17)
- eve.json 0.02MB (bounded); target PSI 0
- **Verdict: sub-2-GiB ceiling PROVEN under real production-mirrored traffic** (was lab-profile
  only; now SPAN-backed). No simulated PASS - real measurement.

## No secrets
