# mct-vuln-target01 (VM 205)

- OS: Debian 13 genericcloud (cloud-init)
- IP: 192.168.222.242 (static, gw 192.168.222.1)
- Specs: 2GB / 1 vCPU / 10G
- Services: ssh (22, PermitRootLogin yes - lab), vsftpd (21), lighttpd (80)
- Purpose: Greenbone lab scan target (safe discovery)
- SSH: mct user, key ~/.ssh/mct_lab
- Status: RUNNING, scan-ready
