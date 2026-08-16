# IRIS Case Template Routing Map

Maps alert source/rule/monitor to the correct IRIS case template.

| Alert source | Wazuh rule / monitor | Case template | Escalation class |
|---|---|---|---|
| OpenCanary | 121000-121099 (opencanary group) | opencanary-hit.md | A |
| MISP IOC match | 121100+ (misp-ioc group) | misp-ioc-match.md | A (high) / B (medium) |
| Flow lateral movement | flow lateral-movement rule | flow-lateral-movement.md | A |
| Flow unknown exporter | flow unknown-exporter monitor | unknown-flow-exporter.md | A |
| Flow high outbound | flow high-outbound-transfer rule | flow-high-outbound-transfer.md | B (A if confirmed) |
| Flow unusual port | flow unusual-port rule | flow-unusual-port.md | B (A if beaconing) |
| Greenbone critical | webhook A (gvm critical) | critical-vulnerability.md | A (internet-facing) / B |
| SSH brute force | ssh 5710/5715/5716 + AR | ssh-bruteforce-active-response.md | B (A on repeat) |
| Security Onion Suricata | SO (agent 008) -> Wazuh suricata group | security-onion-suricata-alert.md | B (A on C2/exploit) |
| mct-portal app event | 120537 family (mctportal group) | mct-portal-container-error.md | B (A on compromise) |
| Wazuh agent offline | agent_control / keepalive rules | wazuh-agent-offline.md | B (A on tamper) |
| UniFi WAN drop (malicious) | unifi-cef wan-drop rules | unifi-wan-drop-malicious-ip.md | C (A if C2) |
| Sentry security review | sentry group rules | sentry-security-review.md | C (B on attack strings) |

## How to use

1. Alert fires -> analyst picks template from this map (or Shuffle auto-route).
2. Open IRIS case using the template fields.
3. If no template matches, use the general fields in `ops/runbooks/iris-case-management.md`.
4. Mark template + routing accuracy in the case tags for quarterly review.

## Escalation (Shuffle degraded mode)

Due to current Shuffle variable limitations, if auto-creation fails:

1. Analyst creates the case manually using this routing map.
2. Paste the raw alert payload (from Wazuh alerts index) into the case description.
3. Tag the case `shuffle-templating-degraded`.
4. Re-run the workflow once Shuffle is verified healthy.
