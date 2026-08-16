# Case Template: Wazuh Agent Offline / Tamper Concern

## Summary

A Wazuh agent went offline (no keepalive), had its configuration tampered with,
or shows evidence of agent compromise/removal.

## Initial severity

- Agent offline > 24h on a critical host: Severity 3 (High, Class B)
- Tamper indicators (config change, disconnected with AR pending, syscheck on critical dirs): Severity 4 (Critical, Class A)

## Triage questions

1. How long has the agent been offline? Is this a known maintenance window?
2. Does the host show network activity during the offline window (flow records)?
3. Any tamper events: `syscheck` registry/file changes, agent removal, active-response events?
4. Is the offline host internet-facing or a sensitive asset?
5. Did the agent report before disconnecting (last events)?

## Evidence to collect

- Agent status via `agent_control -l` / dashboard
- Last events before disconnect (archives for agent id)
- Flow records for the host IP (elastiflow-*)
- Ossec.log agent disconnect reasons (protocol error, duplicate IP, timeout)

## Relevant Wazuh dashboards/searches

- Agents -> agent status / last-seen
- Alerts: `agent.id: <id> AND (rule.groups: tamper OR rule.id: 550*)`
- ossec.log for disconnect lines

## Relevant Velociraptor hunts

- If host reachable: `Generic.Client.Info`, `suspicious-processes`, persistence collection
- Check if Velociraptor client still checks in as a cross-check

## MISP enrichment steps

- Enrich the host IP in MISP; check for matching campaign IOCs
- Correlate with any MISP matches around the disconnect time

## Containment options

- Manual approval only: block host at firewall, isolate VLAN
- Re-install/re-key agent after host integrity confirmed
- If tamper confirmed: preserve host, collect evidence before remediation

## Client notification criteria

- Notify client if the offline host is a client asset or if tamper is suspected
- Include expected downtime info if maintenance

## Closure criteria

- Root cause: maintenance / network issue / real compromise
- Agent restored with healthy status, last-seen verified
- If compromise: full case with evidence, containment, IOC updates

## Detection tuning follow-up

- Review keepalive thresholds (default 20 min) for critical agents
- Consider custom rule for offline duration > 24h on critical hosts
- Verify tamper rules coverage (agent remove, key change, syscheck critical)
