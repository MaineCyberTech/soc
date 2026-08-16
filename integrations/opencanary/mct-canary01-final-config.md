# mct-canary01 Final Config

Target: mct-canary01 VM (Debian 13, dockerized OpenCanary). Build blocked on
PVE access (see mct-canary01-final-build.md) - config is final and ready.

## Config (final)

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
  "ssh.enabled": true, "ssh.port": 22,
  "telnet.enabled": true, "telnet.port": 23,
  "ftp.enabled": true, "ftp.port": 21,
  "smb.enabled": true, "smb.port": 445,
  "rdp.enabled": true, "rdp.port": 3389,
  "mysql.enabled": true, "mysql.port": 3306,
  "mssql.enabled": true, "mssql.port": 1433,
  "http.enabled": true, "http.port": 80,
  "https.port": 443,
  "tcpbanner_1.port": 9100,
  "tcpbanner_2.port": 8080
}
```

## Deploy (after VM build)

```bash
# on mct-canary01
apt-get update && apt-get install -y docker.io docker-compose-v2
mkdir -p /opt/canary
# write config above to /opt/canary/opencanary.conf
docker run -d --name opencanary --restart unless-stopped \
  -v /opt/canary/opencanary.conf:/root/.opencanary.conf:ro \
  -p 22:22 -p 23:23 -p 445:445 -p 3389:3389 -p 3306:3306 -p 1433:1433 \
  -p 8080:8080 -p 9100:9100 thinkst/opencanary:latest
```

## Wazuh side

- VM IP in 192.168.222.0/24: remote syslog allowed (no config change).
- Add VM MAC to known-devices (avoid 120527 unknown-device noise).
- Rule family 121000+ already deployed.

## Validation

1. From canary: `timeout 3 bash -c "</dev/tcp/127.0.0.1/9100"`
2. On Wazuh host: soc-smoke-test.sh --opencanary (expect rule 121012 level 12)
3. IRIS case via Shuffle or manual (opencanary-hit template)

## Safety

- No real credentials on canary; placeholder artifacts only.
- Not on management subnet.
