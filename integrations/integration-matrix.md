# Integration Matrix

| # | Source | Trigger | Destination | Method | Mode | Approval required | Payload contract | Runbook |
|---|---|---|---|---|---|---|---|---|
| 1 | Wazuh/OpenSearch | Alert class A/B | Shuffle | Webhook | Notify + enrich | No | wazuh-high-severity.json | alert-routing.md |
| 2 | Shuffle | Enriched high severity alert | DFIR-IRIS | API | Create alert/case | No (alert), YES (response) | wazuh-high-severity.json | dfir-iris.md |
| 3 | MISP | High-confidence IOC (action:block) | Wazuh CDB | Export script | Detect list | Yes initially | misp-event.json | misp-to-wazuh-cdb.md |
| 4 | OpenCanary | Canary hit | Wazuh syslog | Syslog 15140 | Alert | No | opencanary-hit.json | opencanary.md |
| 5 | Wazuh | Canary rule hit (121000+) | DFIR-IRIS | Shuffle | Case | No | opencanary-hit.json | incident-triage.md |
| 6 | Greenbone | Critical finding | DFIR-IRIS | Webhook -> Shuffle | Case | No | greenbone-critical.json | critical-finding-to-iris.md |
| 7 | Velociraptor | Evidence collected | DFIR-IRIS | Manual/API | Attach evidence | No | velociraptor-evidence.json | dfir-iris-evidence-workflow.md |
| 8 | Security Onion | NSM packet ingest (Zeek/Suricata) | Wazuh -> Shuffle -> DFIR-IRIS | agent 008 (zeek-forward.log) -> Wazuh -> Shuffle | Alert/case | Yes (2026-08-15) | zeek conn.log (ZEEK-tagged) | wazuh-high-severity-to-iris |
| 9 | OpenSearch | Scheduled report | Reporting output | Script/API | Scorecard | No | n/a | client-reporting.md |
| 10 | Wazuh | Candidate IOC confirmed | MISP | API | Enrich/feed | Analyst approval | wazuh-to-misp.json | wazuh-to-misp-candidate-ioc.md |
| 11 | Canarytokens | Token fired | Shuffle | Webhook | Case | No | canarytokens-hit.json | canarytokens.md |

## Principles

- Wazuh remains the primary alert plane; Security Onion the NSM plane.
- Every route has a payload contract, failure mode, test event, and owner runbook (see the linked docs).
- No route requires a plaintext secret in docs.
