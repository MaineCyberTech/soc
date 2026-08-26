# Phase 30 Remediation Backlog (P0/P1/P2/P3)

Date: 2026-08-24

## P0 (must-fix / urgent)

| # | Item | Owner | Evidence |
|---|---|---|---|
| 1 | **SO VM recovery** (agent 008, Zeek/Suricata ingest) | operator | PVE creds FAIL auth - provide PVE token/password (81) |
| 2 | RAM expansion (memory headroom; stale-swap root cause) | operator/host | P30 10-17 |

## P1 (high)

| # | Item | Owner |
|---|---|---|
| 3 | Wire p29-image-ci-gate + exec-mode audit into GitHub workflow (61) | SOC |
| 4 | Agent-008 disconnect alerting beyond CI (74) | SOC |
| 5 | Indexer container memory limits + explicit -Xmx at next restart (67/12) | SOC |
| 6 | Endpoint markers (013/014) -> cert -> retire throttles (22-27) | operator (RMM) |

## P2 (medium)

| # | Item | Owner |
|---|---|---|
| 7 | Pin CI actions (checkout@v4) to SHA (61/62) | SOC |
| 8 | Sysmon zip cache refresh + manifest (08) | operator |
| 9 | Offline image registry mirror (72) | SOC |
| 10 | Compose-manage tenzir-node (67) | SOC |
| 11 | wazuh.yml password -> env abstraction (63) | SOC |
| 12 | Consolidate runbooks into golden-path + maintenance (75) | SOC |

## P3 (backlog)

- Formalize SLOs + incident-response doc (74/75); Shuffle UI native controls when approved
  (32-37); credential replacements (VT/PVE/indexer); NetFlow scope + alerts; Redis owner;
  Greenbone signed auth; canarytokens; full-cluster drill (target).

## Release gate

- v1.3.0 released; no new release gated on P0 items (Phase 31).

## No secrets