# Phase 35: Monthly Operations

Date: 2026-08-25

## Monthly cycle

### Endpoints
- 7 active, 3 disconnected (1 retired)
- Agent 014 certified
- Agents 013/015: operator-RMM pending

### Packet capture
- Suricata: 9M+ packets, 0 drops, 74MB
- ET Open rules: 529 active
- SPAN: ens19 live

### Detection
- Canary E2E: PROVEN
- Real SPAN alert: detected (SID 2210038)
- Rule 86601: working

### Routing
- Observe-only (Phase 36 for production)

### Alerts
- 41,775 today (all agents)
- 1,062 agent 016
- 2 rule 86601 (Suricata)

### Backup
- Automated cron: health, snapshot, config, workflow export
- Core alert freshness: HEALTHY

### Retention
- ISM 14d policy active
- Wave expected ~08-29

### Capacity
- Disk: 85% (LOW WATERMARK)
- /tmp: 21%
- Memory: 44%

### Blockers
1. Disk at low watermark (awaiting wave)
2. Agent 013/015 disconnected
3. Shuffle-native routing UI-gated

### Billing
- PARTIAL (routing not integrated)

### Retrospective
- P35 successfully proved canary E2E
- Bonus: real SPAN alert detected
- All detection pipeline layers proven

## No secrets
