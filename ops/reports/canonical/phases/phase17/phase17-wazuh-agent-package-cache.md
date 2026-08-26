# Phase 17 Wazuh Agent Package Cache

Date: 2026-08-16

## Status: CACHED (deb + rpm, 4.14.7)

| Package | Size | sha256 |
|---|---|---|
| wazuh-agent_4.14.7-1_amd64.deb | 13.2MB | 5276281b62e887065ecc14d4463cea529cf418529538c8edd6769c9ec550213f |
| wazuh-agent-4.14.7-1.x86_64.rpm | 11.1MB | a5ef96376782262220df4b8aaa0e024925b07e303fbc6915d42f6a438aba56d7 |

## Location

- /opt/mct-cache/wazuh-agents/ + checksums/ (sha256 files + manifest).

## Usage (offline deploy)

- apt: dpkg -i wazuh-agent_4.14.7-1_amd64.deb (or apt offline repo).
- rpm: rpm -ivh wazuh-agent-4.14.7-1.x86_64.rpm.

## No secrets
