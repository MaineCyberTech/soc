# mct-canary01 Running Config

## VM

- Name: mct-canary01 (PVE VM 110), Debian 13, 1 vCPU / 1 GiB / 10 GiB
- Network: LAN segment (client-facing VLAN), static IP in 192.168.222.0/24

## OpenCanary

- Container: thinkst/opencanary:latest
- node_id: opencanary-mct-canary01
- Services: SSH 22, Telnet 23, FTP 21, SMB 445, RDP 3389, MySQL 3306,
  MSSQL 1433, HTTP 80, HTTPS 443, tcpbanner 9100/8080
- Syslog: 192.168.222.149:15140 (Wazuh master remote syslog)

## Config file

Full JSON in mct-canary01-final-config.md (logger syslog -> 192.168.222.149:15140,
facility local6).

## Status

- NOT BUILT (PVE access blocked) - config final and ready.
