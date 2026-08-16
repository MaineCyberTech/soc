# Linux Device Rollout Result

Date: 2026-08-12
Device: docker-host (MCT pilot)
OS: Debian 13
Agent: wazuh-agent 4.14.7-1, Active (ID 006)

## Result: PASS

- Install: already deployed (idempotent skip verified)
- Enroll: via public IP 142.105.190.25 + registration password
- Verify: 6/6 PASS (as root)
- Velociraptor: present
- osquery: running

## level.io takeaway

- Installer idempotent (re-run safe).
- Verify script requires root (level.io default for Linux).
- Group: linux-clients (next device uses group assignment).
