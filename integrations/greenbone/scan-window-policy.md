# Greenbone Scan Window Policy

## Profiles

| Profile | Use | When |
|---|---|---|
| safe discovery | first scan of any new target; port/service inventory | initial |
| authenticated server scan | Linux/Windows servers with svc-openvas-scan credentials | monthly, core-infrastructure |
| external exposed services check | internet-facing targets (mct-portal, SKK, LBM-Dock) | monthly off-peak |
| post-remediation verification | re-scan after patch/fix | within 5 days of remediation |
| monthly recurring scan | standard cadence for all groups | 1st week of month |

## Windows

| Group | Profile | Window | Frequency |
|---|---|---|---|
| core-infrastructure | safe discovery + authenticated | 02:00-04:00 UTC 1st week | monthly |
| cloud | external exposed services check | 02:00-05:00 UTC, client-agreed date | monthly |
| network-appliances | safe discovery only | 02:00-04:00 UTC, quarter | quarterly |
| client-like | safe discovery | after provisioning | on-boarding only |

## Rules

- No scan of internet-facing targets without client authorization on record.
- No authenticated scans until the svc account is provisioned and tested on a staging host.
- If a scan degrades a target (gateway drop, appliance reboot), stop scanning that group and investigate first.
- Record every scan start/end in `ops/reports` (script or manual entry).
- OpenCanary/UniFi/other alert noise from scanner IP 192.168.222.154 is expected - suppression rules already deployed (121099 and UniFi equivalents).

## Scheduling

- Greenbone schedule objects should reference these windows; the monthly recurring scan profile is the default task config.
- Post-remediation scans are manual (operator-triggered), not scheduled.
