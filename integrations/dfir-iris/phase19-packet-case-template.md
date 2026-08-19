# Phase 19 IRIS Packet Case Template

Date: 2026-08-18
Status: TEMPLATE (routing gated - NO-ROUTE decision this phase). Replaces/supersedes the Phase 18 stub template.

## Case creation trigger (once enabled)

- Zeek Class A: 122001 (SSH), 122002 (SMB), 122003 (RDP) - level 8, groups mct,zeek,{ssh,smb,rdp}.
- Suricata (future): sev 1-2 via rules 122011/122012.

## IRIS case fields

| Field | Value |
|---|---|
| Title | `Packet <family>: <signature/desc> from <src> to <dst>:<port>` |
| Severity | High (Class A); Critical if Suricata sev 1 |
| Status | OPEN |
| Source | MCT SOC - automated (Shuffle webhook) |
| Tags | `mct-packet`, `<family>` (zeek-ssh/zeek-smb/zeek-rdp/suricata), `source-agent-008` (or agent id) |
| Client | map src/dst to client (192.168.111.0/24) if present |

## Evidence block (from Wazuh alert)

```
rule.id: <122001|122002|122003|122011|122012>
rule.level: <8|10>
agent.name: <008 securityonion | 015 ...>
timestamp: <ISO>
full_log: <ZEEK JSON or eve.json JSON - original event>
```

## Correlation (investigator steps)

1. ElastiFlow: flows involving src/dst in prior 4h (source.ip / destination.ip), note
   volume/locality and whether internal-external.
2. Check both endpoints for agent coverage; pull Sysmon (014/012) or macOS (015) context if client.
3. Search prior 7d for the same src/dst pair (repeat = escalation).
4. Determine intent: scan sweep (many dst) vs targeted (single dst).

## Closure rules

- Benign/known-service -> CLOSED as "Not a Threat" with reasoning.
- Malicious/unexplained -> escalate to incident, note in case, follow incident-triage runbook.
- Class A only in IRIS; Class B/C stay in Wazuh.

## No secrets