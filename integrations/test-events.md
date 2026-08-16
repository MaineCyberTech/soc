# Integration Test Events

Test payloads and expected outcomes for every integration route. Run after each deployment and after any major change.

## 1. Wazuh/OpenSearch -> Shuffle -> IRIS (wazuh-high-severity.json)

```bash
curl -sk -X POST http://127.0.0.1:3001/api/v1/webhooks/<REDACTED_WEBHOOK_ID> \
  -H 'Content-Type: application/json' \
  -d @integrations/shuffle/webhook-contracts/wazuh-high-severity.json
```

Expected: workflow completes; IRIS alert created; log line in Shuffle.

## 2. OpenCanary -> Wazuh (syslog)

```bash
timeout 3 bash -c "</dev/tcp/127.0.0.1/<fake_ssh_port>" || true
docker compose exec wazuh.master grep -c opencanary /var/ossec/logs/archives/archives.log
```

Expected: archive log count increases; rule 121000 fires.

## 3. OpenCanary -> Shuffle -> IRIS (opencanary-hit.json)

POST `integrations/shuffle/webhook-contracts/opencanary-hit.json` to the opencanary webhook. Expected: Class A IRIS alert (severity 4), template opencanary-hit.

## 4. Greenbone -> Shuffle -> IRIS (greenbone-critical.json)

POST `integrations/shuffle/webhook-contracts/greenbone-critical.json` (internet_facing: true). Expected: Class A IRIS case (template critical-vulnerability).

## 5. MISP -> CDB

- Add test IOC in MISP (tag action:block, confidence:high, type:scanner).
- Run `ops/scripts/misp-to-wazuh-cdb.example.py --output /tmp/test.cdb`.
- Expected: entry present; `wazuh-logtest` with the IOC matches the CDB rule.

## 6. Velociraptor -> IRIS evidence

- Run `Generic.Client.Info` hunt on pilot client; download zip.
- Attach to test IRIS case manually.
- Expected: evidence visible in case; hash recorded.

## 7. Security Onion -> Wazuh -> Shuffle -> IRIS (agent 008 intake)

Verify agent 008 zeek-forward events arrive (indexer wazuh-archives-* location=/nsm/zeek/zeek-forward.log). Suricata eve.json alerts flow once signatures fire. Expected: IRIS alert severity 4, tag source:security-onion.

## 8. Canarytokens

Trigger a test token (file/DNS/URL). Expected: webhook fires; IRIS alert severity 4.

## 9. Reporting

```bash
python3 ops/scripts/generate-scorecard.example.py --client "Client Generic MSP"
```

Expected: `reporting/output/scorecard-client-generic-msp-<date>.md` generated.

## 10. Wazuh -> MISP candidate

Create a test event via MISP API (ip-src attribute). Expected: event visible in MISP GUI with tags source:wazuh, confidence:medium.

## Recording results

Each test run records: date, route, payload, outcome, anomalies in `ops/reports/acceptance-test-template.md` style.
