# Phase 8 Lab Target Scan Plan

## Target

- VM 205 mct-vuln-target01 (Proxmox .222) - deliberately vulnerable Debian 13 lab host
- IP: 192.168.222.x (assign static at build)

## Profile

- safe discovery (non-invasive) FIRST
- No authenticated scan without approval
- Internet-facing: none (LAN lab only)

## Steps

1. Build VM 205 (Proxmox access).
2. GSA: target + config + task.
3. Run scan (safe).
4. Export report -> phase8-vulnerability-review.md.
5. Confirm scanner IP suppression (192.168.222.154) in Wazuh.

## Safety

- Lab host only; no production targets without authorization.
