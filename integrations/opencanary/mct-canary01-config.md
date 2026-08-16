# mct-canary01 OpenCanary Config

Target: mct-canary01 VM (Debian 13, dockerized OpenCanary).
Base: Wazuh-host config (data/opencanary/opencanary.conf) with changes below.

## Config (draft)

```json
{
  "device.node_id": "opencanary-mct-canary01",
  "ip.ignorelist": [],
  "logtype.ignorelist": [],
  "logger": {
    "class": "PyLogger",
    "kwargs": {
      "formatters": {
        "syslog_rfc": {
          "format": "opencanaryd[%(process)-5s:%(thread)d]: %(name)s %(levelname)-5s %(message)s"
        }
      },
      "handlers": {
        "syslog": {
          "class": "logging.handlers.SysLogHandler",
          "address": ["192.168.222.149", 15140],
          "facility": "local6"
        },
        "console": {
          "class": "logging.StreamHandler",
          "stream": "ext://sys.stdout"
        }
      }
    }
  },
  "ssh.enabled": true,
  "ssh.port": 22,
  "telnet.enabled": true,
  "telnet.port": 23,
  "ftp.enabled": true,
  "ftp.port": 21,
  "smb.enabled": true,
  "smb.port": 445,
  "rdp.enabled": true,
  "rdp.port": 3389,
  "mysql.enabled": true,
  "mysql.port": 3306,
  "mssql.enabled": true,
  "mssql.port": 1433,
  "http.enabled": true,
  "http.port": 80,
  "https.port": 443,
  "tcpbanner_1.port": 9100,
  "tcpbanner_2.port": 8080
}
```

## Ports published (VM firewall)

| Port | Service | Note |
|---|---|---|
| 22 | fake SSH | logs on banner/login attempt |
| 23 | fake telnet | logs on negotiation |
| 445 | fake SMB | high value for internal movement |
| 3389 | fake RDP | |
| 3306 | fake MySQL | |
| 1433 | fake MSSQL | |
| 8080/9100 | tcpbanner | instant CONNECTION_MADE logs (best test trigger) |

## Syslog forward

- Target: 192.168.222.149:15140/udp (Wazuh master remote syslog).
- Wazuh remote allowed-ips covers 192.168.222.0/24 - VM IP in that range = no config change.
- node_id `opencanary-mct-canary01` distinguishes hits from local canary `opencanary-mct-01`.

## Validation

1. From canary VM: `timeout 3 bash -c "</dev/tcp/127.0.0.1/9100"` -> CONNECTION_MADE logs.
2. On Wazuh host: archives grep opencanary-mct-canary01; rule 121012 alert.
3. IRIS case via Shuffle (or manual) - template opencanary-hit.

## Safety

- No real service accounts/credentials on the canary.
- Do not run on management subnet.
- Keep the VM offline from PVE admin traffic.
