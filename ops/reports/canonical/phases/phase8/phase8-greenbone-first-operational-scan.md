# Phase 8 Greenbone First Operational Scan - PASS

Date: 2026-08-15
Status: **PASS - first operational scan completed against lab target**

## Scan

- Target: mct-vuln-target01 (192.168.222.242, VM 205 Proxmox lab)
- Config: Discovery (non-invasive, 3328 NVTs)
- Port list: All IANA assigned TCP
- Task: MCT-lab-scan-242 (ID 09045ed4-eeb1-4063-b6eb-fbee21a3e9dc)
- Result: **Done** (100% progress)

## Method (GMP via gvmd socket - no GMP CLI package needed)

- GMP over unix socket /run/gvmd/gvmd.sock inside mct-security-stack-gvmd-1
- python script: authenticate (admin/GREENBONE_ADMIN_PASSWORD) -> create_target
  -> create_task -> start_task -> get_results
- Scripts staged on VM103: /root/gmp-*.py

## Results (10 findings, all severity 0.0 informational)

- Axway SecureTransport MFT Detection (HTTP) x7 - FALSE POSITIVE (lighttpd banner)
- FTP Banner Detection x2
- Hostname Determination x1

## Notes

- No critical/high findings (expected - lab host, discovery config).
- Scan workflow PROVEN end-to-end (GMP scripting path).
- Critical-alert webhook (D5) still pending GSA alert config - can be added via
  same GMP path (create_alert with HTTP method).

## Files

- ops/reports/phase8-greenbone-first-operational-scan.md (this file)
- ops/reports/phase8-vulnerability-review.md
