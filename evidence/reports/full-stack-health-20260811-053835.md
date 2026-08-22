> **HISTORICAL EVIDENCE (2026-08-11).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Full Stack Health - 20260811-053835

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
| SO syslog sidecar | OK | container healthy | none |
| Security Onion VM | OK | ping ok | none |
| OpenCanary | OK | container running | none |
| Shuffle | OK | backend+frontend up | none |
| DFIR-IRIS | OK | port 8443 listening | none |
| IRIS nginx | OK | container healthy | none |
| Velociraptor | OK | service active | none |
| MISP/Greenbone VM | OK | reachable (tcp 8443) | verify |
| Local snapshot | OK | snap file < 24h | none |
| S3/DR bundle | OK | dr-s3 log < 48h | none |
| Phase2 config backup | OK | bundle < 48h | none |
| Root disk | OK | 74% used | none |
| Swap | **WARN** | 4352M/8191M used | high |
| Memory | OK | 89% used | none |
| Cron (snapshot) | OK | entries present | none |
| Cron.d wazuh-backups | OK | file present | none |
