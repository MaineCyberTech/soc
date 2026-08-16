# Case Template: MISP IOC Match

## Summary

A monitored IOC (IP, domain, hash) matched inbound traffic or endpoint telemetry.
Wazuh CDB rule 121100+ fired from the MISP-exported list (confidence: high).

## Initial severity

- confidence high / action:block: Severity 4 (Critical, Class A)
- confidence medium / action:monitor: Severity 3 (High, Class B)

## Triage questions

1. Which IOC value matched, and which attribute type (IP/domain/hash/URL)?
2. Where did the match occur: src IP, dst IP, DNS query, file hash, process?
3. Is the matched host/agent a real asset or a canary/deception node?
4. Did the activity precede or follow the IOC publication date?
5. Is this a confirmed match or a false positive (e.g. CDB collision, shared IP)?

## Evidence to collect

- Wazuh alert payload (rule 1211xx, full log, agent, location)
- The IOC attribute record from MISP (event, tags, reference, TLP)
- Flow records for the IP pair (elastiflow-*)
- Endpoint telemetry from the matched agent (processes, network, files)

## Relevant Wazuh dashboards/searches

- Alerts index: `rule.id: 1211*`
- Agent activity around match time
- ElastiFlow: dstip/srcip of the IOC

## Relevant Velociraptor hunts

- `suspicious-processes` on matched endpoint
- `external-network-connections` / listening ports
- File hash hunt if the IOC is a hash: `Windows.Hunt.FileFinder` (hashes)

## MISP enrichment steps

- Pull the full MISP event for the IOC (related attributes, comments, TLP)
- Look for linked events (same campaign, related IOCs)
- Publish/update attribution notes after investigation

## Containment options

- Manual approval required for: firewall block of IOC, agent quarantine, host isolation
- Wazuh active response on the matched agent (disabled by default; approve per case)
- No automated blocking without operator sign-off

## Client notification criteria

- Notify if the matched asset belongs to a client org or if IOC is C2-related
- Wait for triage confirmation before notifying (avoid false alarm)

## Closure criteria

- Verdict recorded: true positive / false positive
- IOC state updated in MISP (active-monitor / active-block / false-positive)
- If true positive: containment confirmed, scope documented, MISP event updated
- Follow-up: CDB list accuracy verified (no stale collisions)

## Detection tuning follow-up

- False positives from this match: update IOC lifecycle (suppress, expiry)
- Check rule 1211xx hit rate weekly; tune confidence tiers if noisy
