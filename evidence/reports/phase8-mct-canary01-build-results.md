> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 mct-canary01 Build Results - PASS

Date: 2026-08-15
Status: **BUILT AND VALIDATED on Proxmox 192.168.222.222 (VM 202)**

## VM

- VM 202 mct-canary01: Debian 13 cloud-init, 2GB/1c/10G, IP 192.168.222.241
- Docker 26.1.5 + OpenCanary (thinkst/opencanary:latest)

## OpenCanary services (running)

FTP 21, HTTP 80, MySQL 3306, RDP 3389, SSH 22 (published 2222), MSSQL 1433,
Telnet 23. node_id: opencanary-mct-canary01.

## Alert path VALIDATED

- Canary events -> syslog UDP -> Wazuh master 514 -> rules:
  - **121014 level 12 (Class A)** "OpenCanary: other deception event" - FIRED
  - sshd rules 5710/5762 (canary host sshd activity)
- 10 alerts in first 15 min from canary01.

## Notes

- tcpbanner (9100/8080) module did not start (config key variant) - all other
  services running; tcpbanner not required for Class A path.
- SSH published on 2222 (VM's own sshd holds 22).

## Files

- ops/reports/phase8-mct-canary01-build-results.md (this file)
- integrations/proxmox/mct-canary01-vm.md (updated)
- integrations/opencanary/mct-canary01-alert-path-phase8.md (updated)
