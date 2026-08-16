# Wazuh -> MISP Candidate IOC Workflow

Purpose: turn high-confidence Wazuh alert artifacts into candidate MISP indicators.

## Pipeline

```text
Wazuh alert (class A/B, rule group ssh/flow/suricata/opencanary/...)
  -> analyst confirms IOC (srcip, dstip, domain, hash) in the alert
  -> create MISP event via API (placeholder script pattern)
  -> tag: source:wazuh, confidence:<low|medium|high>, type:<scanner|bruteforce|c2|...>
  -> assign organization: Maine Cyber Tech Internal (internal), or client org for client-sourced IOCs
  -> optionally set expiry
```

## Candidate selection criteria

- Source IP of confirmed bruteforce/scanning (confidence medium).
- C2 domain/IP from flow or Suricata alerts (confidence high).
- File hashes from Sysmon/Suricata malware alerts (confidence high).
- OpenCanary hit sources (confidence high).
- Do not auto-publish anything; analyst approval required before adding to shared feeds.

## API pattern (placeholder)

```text
POST {MISP_BASE}/events
Authorization: <REDACTED_MISP_API_KEY>
{
  "Event": {
    "orgc_id": 1,
    "info": "Wazuh alert <rule_id> candidate IOC",
    "threat_level_id": 2,
    "distribution": 0,
    "Attribute": [{
      "type": "ip-src|ip-dst",
      "value": "<REDACTED_HOST_IP>",
      "category": "Network activity",
      "to_ids": true
    }]
  }
}
```

## Failure modes

- MISP API down: collect candidates in a local queue file; retry on next sync.
- Duplicate event: MISP correlation finds existing event; merge attributes.
- Wrong tag: analyst fixes tag before feed export.

## Expiry and false positives

- Events get an expiry date at creation (default 90 days; scanners 30).
- FP handling: analyst tags event `action:monitor`, removes from CDB export, notes in event description.
