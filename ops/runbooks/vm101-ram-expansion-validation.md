# VM101 RAM Expansion Validation

Purpose: reduce swap pressure (5.9G/8G) before first client launch.
Status: **RECOMMENDED but NOT executed** - requires hypervisor memory (operator action).

## Current baseline (2026-08-15)

- Total RAM: 9.3G, used 8.3G, free 395M, available 1.0G
- Swap: 8G configured, 5.9G used (74%)
- Top consumers: 3x wazuh-indexer (~3.7G), shuffle-opensearch 1.36G/1.5G (near cap),
  flowcoll 681M, tenzir 216M, master/worker/dashboard ~470M, netdata 203M, dockerd 135M

## Plan

1. Hypervisor: grow VM101 RAM to **16G** (recommended) or 24G for headroom.
2. After reboot, validate:
   ```bash
   free -h                       # expect used < 60%, swap < 10%
   bash /opt/mct-security-stack/ops/scripts/capacity-threshold-check.sh  # swap PASS
   ```
3. Optionally bump shuffle-opensearch limit 1.5G -> 2G (only if host has room).
4. Re-run full-stack-healthcheck.sh - swap row should flip to OK.

## Validation criteria (PASS)

- [ ] available RAM >= 4G at idle
- [ ] swap used <= 1G (10% of 8G)
- [ ] no OOM-killed containers in dmesg for 7 days
- [ ] all services healthy after reboot

## Client-launch gate

- RAM expansion is a **recommended precondition** for the first external client
  (host runs both production stack and would-be lab workload).
- If hypervisor memory is unavailable: keep client scope Linux-only (agent +
  optional scan), defer Windows workloads to the lab, and re-check swap weekly.

## No secrets

No secret values printed.
