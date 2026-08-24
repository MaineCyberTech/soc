# Phase 30 Infrastructure Runtime Audit

Date: 2026-08-24
Tooling: p30-infrastructure-audit.sh.

## Host

- Debian (host), 15GiB RAM, root disk 82% (swap stale 8GiB; swappiness lowered to 10).
- Time/DNS: synced (127.0.0.53 local stub; internal names resolve). Uptime stable.
- CPU: idle ~74-86%; no sustained load (vmstat).

## VMs / containers / networks

- VMs: mct-soc-scan (reachable, under-resourced candidate); **Security Onion VM down**
  (agent 008; recovery blocked on PVE auth). MISP/Greenbone VM reachable.
- Containers: ~30 (wazuh multi-node, iris 5, shuffle swarm, elastiflow, tenzir, opencanary,
  syslog-ng bridge, flow-relay, portainer). All pinned images.
- Networks: bridge + overlay (swarm). No failed systemd services (systemctl --failed empty).

## Storage / resources

- Volumes ~40; disk 82%; memory 12/15GiB (2.4 available, stale swap); PSI 0.
- HA/failure domains: 3 indexers (single node loss ok, cluster green); managers master+worker.

## Drift

- Runtime vs compose reconciled (image pins applied); guardrail exec-bit class closed.

## Findings

- SO VM down (external; owner recovery). Memory capacity thin (RAM expansion Phase 31).

## Verdict

- **PASS** (with SO VM + capacity items).

## No secrets