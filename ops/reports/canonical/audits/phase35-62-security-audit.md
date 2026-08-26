# Phase 35: Security and Supply-Chain Audit

Date: 2026-08-25

## Identities/privileges
- Wazuh admin: scoped to indexer cluster (no escalation)
- Wazuh-wui: read-only dashboard user
- SSH: key-based auth only (no password)
- Docker: socket access restricted to operator user

## Secrets
- creds.env: not committed, not printed
- wazuh.yml: internal to container, not exposed
- No secrets in any report file

## Ports (host)
| Port | Service | Binding |
|---|---|---|
| 22 | sshd | 0.0.0.0 |
| 443 | nginx (dashboard) | 127.0.0.1 |
| 5355 | systemd-resolve | 0.0.0.0 |
| 8443 | docker-proxy | 192.168.222.154 |
| 9392 | docker-proxy (GVM) | 127.0.0.1 |

## TLS
- Wazuh indexer: TLS via CA-signed certs
- Dashboard: TLS via nginx
- No plaintext internal communication

## Rules/licenses
- Wazuh rules: standard + custom local rules
- ET Open rules: 549 active (OISF license)
- No license violations

## State-file permissions
- /var/lib/mct-alert-state: 755 (root:root)
- State files: 644 (readable, not writable by non-root)

## Synthetic data isolation
- Canary records marked MCT_SYNTHETIC=true, MCT_TEST_ONLY=true
- Located in /var/log/suricata/eve-alert.json (dedicated test file)

## Sensor confinement
- Suricata: read-only SPAN capture on ens19
- No packet injection capability

## PASS — No security issues found
## No secrets
