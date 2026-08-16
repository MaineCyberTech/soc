# mct-linux-client01 (VM 204)

- OS: Debian 13 genericcloud (cloud-init)
- IP: 192.168.222.240 (static, gw 192.168.222.1)
- Specs: 4GB / 2 vCPU / 20G
- Agent: wazuh-agent 4.14.7-1, ID 011, group linux-clients, Active
- SSH: mct user, key ~/.ssh/mct_lab
- Purpose: endpoint deployment validation - **DONE (PASS)**
- Notes: DNS via /etc/hosts (13.225.47.70 packages.wazuh.com, 151.101.130.132 deb.debian.org); apt key dearmored
