# Phase 20 Zeek Case Template (DFIR-IRIS)

Date: 2026-08-19
Status: TEMPLATE (routing manual-only this phase).

## Create on (when enabled)

- Zeek Class A: 122001 (SSH), 122002 (SMB), 122003 (RDP) - level 8, groups mct,zeek,{ssh,smb,rdp}.

## IRIS case fields

| Field | Value |
|---|---|
| Title | `Zeek <SSH|SMB|RDP>: <src> -> <dst>:<port>` |
| Severity | High |
| Source | MCT SOC (Shuffle webhook when enabled; manual otherwise) |
| Tags | `mct-packet`, `zeek-<ssh|smb|rdp>`, `source-agent-008` |
| Client | map src/dst to client subnet (192.168.111.0/24) if present |

## Evidence block

```
rule.id: <122001|122002|122003>
rule.level: 8
agent.name: 008 securityonion
timestamp: <ISO>
full_log: <ZEEK JSON - raw event>
```

## Correlation (investigator)

1. ElastiFlow flows involving src/dst prior 4h.
2. Repeat src/dst in 7d history (repeat = escalation).
3. Client context via Sysmon (014/012) or macOS (015) if client IP.
4. Scan sweep vs targeted: distinct dst count.

## Closure

- Benign/known-service -> Not a Threat (reasoning).
- Malicious/unexplained -> escalate, follow incident-triage runbook.
- Class A only; Class B/C stay in Wazuh.

## No secrets