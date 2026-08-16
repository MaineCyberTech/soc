# mct-dr-scratch01 (VM 203)

- OS: Debian 13 genericcloud (cloud-init)
- IP: 192.168.222.243 (static)
- Specs: 4GB / 2 vCPU / 20G (cloud image root 2.8G - grow for restore testing)
- Purpose: DR scratch restore host (OpenSearch 19200+, config/dump validation)
- SSH: mct user, key ~/.ssh/mct_lab
- Status: RUNNING
- Note: cloud image root partition is 2.8G; grow partition before large restores.
