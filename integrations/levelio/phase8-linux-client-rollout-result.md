# Phase 8 Linux Client Rollout Result

Date: 2026-08-15
Device: mct-linux-client01 (VM 204, Proxmox test lab)
OS: Debian 13 (cloud-init)
Agent: wazuh-agent 4.14.7-1, ID 011, **Active**

## Result: PASS

- Installed via endpoint kit with level.io-style vars (public IP + registration password).
- Verify: 4/4 PASS (root).
- Group: linux-clients.

## Rollout learnings to apply

1. DNS: endpoints must resolve packages.wazuh.com + deb.debian.org (hosts entries if gateway DNS unreliable).
2. Apt key: use gpg --dearmor.
3. Group must exist in Wazuh BEFORE enrollment.
4. Min 4GB RAM for cloud-image first boot.
5. Static IP recommended (DHCP range coverage uncertain).
