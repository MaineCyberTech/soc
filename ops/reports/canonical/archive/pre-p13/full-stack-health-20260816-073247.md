# Full Stack Health - 20260816-073247

| Component | Status | Evidence | Action Needed |
|---|---|---|---|
| Wazuh master | OK | container running | none |
| Wazuh worker | OK | container running | none |
| Wazuh indexer cluster | OK | green 3 | none |
| Wazuh dashboard | OK | container running | none |
| nginx agent LB | OK | container running | none |
| Cloudflare tunnel | OK | container running | none |
| ElastiFlow | OK | container running | none |
| flow-relay | OK | container running | none |
| Security Onion VM | OK | ping ok | none |
| SO suricata | OK | container running | none |
| OpenCanary | OK | container running | none |
| Shuffle | OK | backend+frontend up | none |
| DFIR-IRIS | OK | port 8443 listening | none |
| IRIS nginx | OK | container healthy | none |
| Velociraptor | OK | service active | none |
| MISP/Greenbone VM | OK | reachable (tcp 8443) | verify |
| Local snapshot | OK | snap file < 24h | none |
| S3/DR bundle | OK | dr-s3 log < 48h | none |
| Phase2 config backup | OK | bundle < 48h | none |
| Root disk | OK | 63% used | none |
| Swap | OK | 3091M/8191M used | none |
| Memory | OK | 72% used | none |
| Cron (snapshot) | OK | entries present | none |
| Cron.d wazuh-backups | OK | file present | none |
