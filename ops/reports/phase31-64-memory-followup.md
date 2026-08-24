# Phase 31 Memory Follow-up

Date: 2026-08-24

- vm.swappiness **10 persists** (sysctl + /etc/sysctl.d/99-mct-memory.conf). PSI 0.00.
- Suricata-minimal benchmark uses ~31MB - fits existing headroom (2.4GiB available) without
  RAM expansion. Sensor on the target host (5.8GiB) measured fine (PSI 0).
- RAM expansion still recommended for the core host (Phase 32) for durable headroom.

## No secrets
