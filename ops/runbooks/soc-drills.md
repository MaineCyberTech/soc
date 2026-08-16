# SOC Validation Drills

Purpose: prove each detection path from source to IRIS with safe, non-destructive triggers.
Run after deployments, after Shuffle restarts, and monthly.

## Drill matrix

| # | Drill | Owner | Trigger (safe) | Expected path | Validation query | Pass/Fail |
|---|---|---|---|---|---|---|
| D1 | OpenCanary hit | SOC | `soc-smoke-test.sh --opencanary` (TCP to canary tcpbanner 9100) | OpenCanary -> syslog 15140 -> Wazuh rule 121012 -> Shuffle -> IRIS | `grep 121012 /var/ossec/logs/alerts/alerts.log`; IRIS case exists | - |
| D2 | MISP IOC match | SOC | Inject test IOC via MISP UI (tag test), run CDB export | MISP -> CDB -> Wazuh rule 121100+ -> Class A -> Shuffle -> IRIS | `wazuh-logtest` with IOC; alerts index; IRIS case | - |
| D3 | Flow unusual port | SOC | Generate local netcat to high port 4444; check ElastiFlow capture | flow -> ElastiFlow -> relay -> Wazuh flow rule -> Shuffle -> IRIS | flow index in OpenSearch `elastiflow-*` | - |
| D4 | Unknown flow exporter | SOC | Temporarily add dummy exporter IP to ElastiFlow config | flow -> monitor unknown exporter -> Shuffle -> IRIS | monitor alert in OpenSearch; IRIS case | - |
| D5 | Greenbone critical | SOC | Use Greenbone gvm-cli to create synthetic critical result (or wait for real finding) | Greenbone -> webhook A -> Shuffle -> IRIS | webhook log; IRIS case severity critical | - |
| D6 | Active response audit | SOC | SSH brute force sim on canary SSH (safe), observe AR | Wazuh AR -> active-responses.log -> audit workflow/report | `active-response-audit.sh`; weekly report | - |
| D7 | Velociraptor evidence | IR | Run `Generic.Client.Info` hunt on pilot; export zip | Velociraptor -> manual export -> IRIS evidence note | IRIS case evidence attached; hashes recorded | - |
| D8 | SO packet ingest -> Wazuh | SOC | Verify Suricata capture count grows on SO VM (`so-status` + `grep capture.kernel_packets stats.log`); check agent 008 zeek-forward events in indexer | SO Zeek/Suricata -> agent 008 -> Wazuh -> (Shuffle) -> IRIS | IRIS case tagged source:security-onion | - |

## Safe trigger rules

- Use RFC5737 test IPs (203.0.113.0/24) in payloads; never attack real infrastructure.
- `soc-smoke-test.sh --dry-run` is always safe to run.
- Do not generate real scanning, brute force, or malware artifacts.
- The OpenCanary tcpbanner port (9100) is the safest canary trigger - it logs immediately on connect.

## Shuffle webhook test

```bash
SHUFFLE_WEBHOOK_URL=http://127.0.0.1:3001/api/v1/webhooks/<ID> \
  soc-smoke-test.sh --shuffle-webhook
```

Confirm workflow run in Shuffle UI (Runs -> FINISHED) and downstream IRIS case.

## Reporting

Every drill run appends to `ops/reports/soc-validation-matrix.md` and writes a timestamped report.
Update the Pass/Fail column after each run. If Shuffle variable substitution fails, mark the
drill `PASS (degraded - raw payload)` and follow the workflow fallback pattern.
