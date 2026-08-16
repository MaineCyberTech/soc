# Case Template: Flow High Outbound Transfer

## Summary

Elastiflow egress volume threshold exceeded by an internal host (potential
exfiltration).

## Initial severity

- Confirmed exfiltration pattern: Severity 4 (Critical, Class A)
- Otherwise: Severity 3 (High, Class B)

## Triage questions

1. Which host, and destination (external IP, geo, known CDN)?
2. Is the volume anomalous for this host (baseline)?
3. What process/service is generating it?
4. Business justification (backup, video upload)?
5. Did it start recently or follow a security event?

## Evidence to collect

- Elastiflow volume records (bytes out) for the host over the window
- Process/network telemetry from the endpoint (Sysmon Event 3, auditd)
- Firewall/proxy logs for the destination

## Relevant Wazuh dashboards/searches

- ElastiFlow: `dstip`/`bytes` aggregated by src host
- Wazuh archives: process events on the host

## Relevant Velociraptor hunts

- `listening-ports`
- `browser-downloads` (Windows)
- `suspicious-processes`
- `uploaded-files` (recent file changes)

## MISP enrichment steps

- Check destination IP/domain in MISP (C2, exfil service)

## Containment options

- Manual approval only: block destination, restrict host egress, isolate

## Client notification criteria

- Notify client immediately if client data could be leaving network

## Closure criteria

- Verdict: legitimate (backup/CDN) or exfiltration
- If exfil: containment verified, data scope documented, MISP updated

## Detection tuning follow-up

- Baseline per-host egress; tune threshold to reduce false positives
- Review if flow rules should trigger on volume delta rather than absolute
