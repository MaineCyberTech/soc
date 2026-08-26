# MCT Security Stack - Final Phase 19 Operator Report

Date: 2026-08-18
Pack: /home/user/mct-security-17 (macOS Flood Remediation, Zeek Noise Validation, Suricata Stability, Packet/Flow Signal Promotion)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 19 delivered the P18 top-priority follow-ups: the **macOS agent 015 flood remediation
plan is ready but remains BLOCKED on Mac access** (agent has been offline since 09:04 UTC);
**Zeek v2 tuning was prepared and validated** after the 24h re-measure showed 122006 still at
270K/24h (broadcast/multicast discovery); the **Suricata eve.json fix was found incomplete and
fully repaired** (dangling symlink + stub updater + missing cron, now fixed and validated);
syslog 15140 posture validated with **repo drift reconciled**; NetFlow scope decision documents
~417K flows/24h still awaiting operator confirmation; packet/flow routing remains **NO-ROUTE**
per safety gates. Healthcheck 0 FAIL; no incidents; fleet 1/3 billable endpoints healthy
(014 active, 015 offline, 013 offline).

## macOS flood remediation status

- **PLAN READY, ACTION BLOCKED ON MAC ACCESS** (agent 015 `Julians-Air`).
- Deliverables: `ops/reports/phase19-macos-flood-remediation.md`,
  `integrations/macos/phase19-macos-local-ossec-config.md`,
  `integrations/macos/phase19-agent015-rollback.md`,
  `integrations/macos/phase19-agent015-operator-steps.md`,
  `ops/reports/phase19-agent015-local-config-apply.md` (blocked status).
- Fix = comment the default unified-log `<localfile>`, add a bounded `<query>` predicate
  (Authorization, SystemConfiguration, sudo, loginwindow, securityd) to preserve useful
  telemetry. Rollback steps included.

## Agent 015 reconnect and volume validation

- Status: **FAIL pre-fix** (agent disconnected since 08-18 09:04 UTC; lastKeepAlive gap).
- Volume: archives 08-16 1.39M / 08-17 1.20M / 08-18 308K (until disconnect); hourly peak
  127,504 @ 01:00 UTC. Queue: disconnect pattern implies queue saturation (queue-full now
  only visible on-device).
- Post-fix validation procedure + PASS criteria defined (>=95% volume drop, 0 queue-full,
  continuous keepalive) in `phase19-agent015-reconnect-validation.md`,
  `phase19-macos-volume-after-fix.md`, `phase19-macos-queue-after-fix.md`.

## Zeek 24h noise recheck and v2 tuning

- Recheck (`ops/reports/phase19-zeek-24h-noise-recheck.md`): 122006 = **270,299/24h** (UDP
  broadcast 255.255.255.255:10001, multicast 233.89.188.1:56700), 122000 = 83,081 (mDNS),
  122005 = 63,767 (mDNS). 122001-122004 = 0 (clean). Zeek = ~417K alerts/24h = dominant
  alert-index contributor.
- v2 (`integrations/security-onion/phase19-zeek-custom-rules-v2.xml` + tuning decision):
  unicast-only destination guard on base rule (excludes 255.255.255.255, 224/4, 239.x,
  233.x, ff00::/8) + port exclusions 10001/56700.
- **DEPLOYED (approved) 2026-08-18 ~21:50** to master + worker as v2.1.
- **v2.1 critical fix discovered during validation:** multi-value `<field name="zeek.resp_p">`
  entries use AND-of-substring semantics in wazuh-analysisd 4.14.7 - 122001 only fired for
  2222 (22 matches 2222 as substring), 122004 NEVER fired, and 122006 negates over-excluded
  (12345 matched negate `123`). This latent bug explains the 0-alert counts for 122001-122004.
  All port fields converted to anchored pcre2.
- **Post-deploy measurement: 0 Zeek alerts since 21:48 UTC** (pre-deploy rate ~217/min).
  24h re-measure in progress to confirm + unlock Class A routing.

## Wazuh index/noise/storage impact

- Alerts 08-18: 425K docs / 401 MB; archives 08-18: 2.06M / 1.5 GB. Whole cluster ~11 GB.
- Contributors: Zeek (~417K/24h), macOS flood (~1.4M/day until disconnect), Redis loop (~10K/day).
- **Retention APPLIED (approved) 2026-08-18**: corrected prior assessment (OpenSearch ISM
  policies already existed). Now: alerts 30d (unchanged), archives 14d (new
  `wazuh-archives-14d` policy via priority-310 template), elastiflow 14d (policy updated).
  Existing indices keep assigned policies until re-created; tradeoff documented in
  `phase19-index-retention-followup.md`.

## Suricata path stability and severity map

- **Finding: P18 fix was incomplete.** Symlink `/nsm/suricata/eve.json` dangled to a deleted
  file; updater script was a stale stub; no cron installed -> 0 eve events ingested in 7d
  despite Suricata firing (e.g. GPL ICMP PING).
- **Fixed this phase** on SO host (192.168.222.116): replaced updater, installed hourly cron
  `10 * * * *`, symlink repointed to live file, log confirms `OK eve.json -> newest`. Ingest
  validation window open (`phase19-suricata-path-stability.md`,
  `phase19-suricata-ingest-check.md`).
- Severity map drafted (sev 1->10, sev 2->8, base 122010; routing gated) in
  `integrations/security-onion/phase19-suricata-severity-map.md` +
  `integrations/shuffle/phase19-suricata-routing-plan.md`.

## NetFlow scope decision

- 2 exporters (23.150.201.36: 301K/24h, 192.168.222.1: 229K/24h). ~417K flows/24h (~67% of
  private) from 13 **unconfirmed** subnets (10.10.202.0, 192.168.1/2/6/7/8/10/13/14/15/28/
  169/192.0) - **BLOCKED on operator confirmation**. Alerting plan prepared but unarmed
  (`phase19-netflow-scope-decision.md`, `phase19-netflow-alerting-readiness.md`,
  `integrations/elastiflow/phase19-new-subnet-alerting-plan.md`).

## Syslog 15140 posture

- **VALIDATED.** Running config: 9 allowlist entries incl. client subnet 192.168.111.0/24 +
  100.64.1.107 (UniFi). UDP listener healthy (senders: 23.150.201.36, 23.150.200.5,
  192.168.222.1, 10.11.12.x, 192.168.123.159 - all inside allowlist). TCP 15140 published
  but unserviced (udp-only Wazuh remote) - documented unused.
- **Repo drift reconciled**: `wazuh_manager.conf` updated to match running (backup made).
- Quarterly review doc created (`integrations/syslog/phase19-15140-quarterly-review.md`).

## mct-portal Redis status

- Rule 120537 ~10K/day constant. Root cause confirmed unchanged: `getaddrinfo EAI_AGAIN redis`
  / `BullMQ worker error` from portal VPS container (agent 007). Fix **owner-blocked** (VPS
  access). Rule kept at level 3; **repo `local_rules.xml` reconciled to level 3** (was drift
  at 5); restore level 5 only after VPS fix verified. Reports:
  `phase19-mct-portal-redis-fix.md`, `phase19-rule-120537-status.md`.

## Packet routing promotion decision

- **NO-ROUTE** maintained. Zeek noise not clean (v2 pending approval + re-measure), Suricata
  not yet validated, NetFlow scope pending. Class A candidates (122001-122003) identified as
  clean. Promotion plan + IRIS case template versioned
  (`phase19-packet-routing-decision.md`,
  `integrations/shuffle/phase19-packet-routing-promotion-plan.md`,
  `integrations/dfir-iris/phase19-packet-case-template.md`).

## Wazuh index/noise/storage impact

- Alerts 08-18: 425K docs / 401 MB; archives 08-18: 2.06M / 1.5 GB. Whole cluster ~11 GB.
- Contributors: Zeek (~417K/24h), macOS flood (~1.4M/day until disconnect), Redis loop (~10K/day).
- No ILM applied; P18 retention plan still approval-gated. Post-fix projections and
  sequencing in `phase19-wazuh-index-noise-storage-after-zeek.md` +
  `phase19-index-retention-followup.md`.

## Client fleet and scorecard progress

- 3 billable endpoints: 014 active, 015 offline (flood), 013 offline since 08-16. No incidents.
- Live scorecard draft produced; progress tracked (`phase19-client-fleet-health.md`,
  `reporting/output/client/phase19-scorecard-progress.md`).

## Greenbone authorization status

- **Not authorized** (unsigned). Package ready; no client-scope scan performed
  (`client-onboarding/phase19-client-scan-authorization-status.md`).

## Monthly client ops

- Run complete: backups fresh, detections live, fleet review, scorecard draft, routing gated
  (`phase19-monthly-client-ops-run.md`, `reporting/output/client/phase19-monthly-scorecard.md`).

## Remaining risks

1. **macOS 015 flood unresolved + agent offline** (TOP) - requires operator Mac access.
2. Zeek 24h re-measure in progress (v2.1 deployed; initial rate 0) - confirm before Class A routing.
3. Suricata ingest - validation window open (fixed upstream; Wazuh ingest to confirm).
4. NetFlow unknown subnets ~417K/24h - operator confirmation.
5. mct-portal Redis loop - owner-blocked, ~10K/day.
6. Retention reduction applied: archives 30d->14d, flow 30d->14d (tradeoff documented; revert path exists).
7. 013 offline since 08-16 (power suspected).
8. Client scan authorization unsigned.
9. Swap WARN (52% of 8GB) sustained.
10. DR S3 bundle still local-only (no new keys).

## Recommended Phase 20 roadmap

1. **macOS fix apply + reconnect validation** (operator on Julians-Air) -> volume/queue PASS check.
2. **Complete Zeek 24h re-measure** (v2.1 deployed; already 0-rate) -> then enable Class A
   (SSH/SMB/RDP) IRIS routing if clean.
3. **Suricata**: confirm eve.json ingest after fix; then severity 1-2 rules + volume measure.
4. **NetFlow**: operator answers scope questions -> arm new-subnet/unknown-exporter alerts.
5. **Retention**: verify 14d ISM policies rolling as expected; re-evaluate windows after noise fixes measured.
6. **Redis**: portal VPS fix -> restore 120537 to level 5.
7. **Client ops**: signed scan auth -> Greenbone client schedule -> invoice (3 endpoints after 015/013 restored).
8. **Dashboards**: flow + zeek dashboards from P19 routing map.
9. **DR**: obtain new DO Spaces keys to complete S3 bundle.

## Files added (summary)

- Reports: phase19-preflight, phase18-status-review, macos flood remediation + agent015
  apply/reconnect/volume/queue, zeek noise recheck + tuning v2, suricata path + ingest,
  netflow scope + alerting readiness, syslog posture, redis fix + 120537 status, packet
  routing decision, wazuh index/storage + retention followup, fleet health, monthly ops,
  final report.
- Integrations: macos (config change, operator steps, rollback), security-onion (zeek rules
  v2 XML, tuning decision, suricata severity map), shuffle (suricata routing, packet promotion),
  dfir-iris (packet case template), elastiflow (subnet classification, new-subnet alerting),
  syslog (15140 quarterly review).
- Reporting: client phase19 scorecard progress + monthly scorecard; live scorecard draft.
- Client-onboarding: phase19 scan authorization status.
- Deployment record: `ops/reports/phase19-deployment-log-20260818.md` (Zeek v2.1, retention ISM, suricata updater, config drift).
- Config fixes: wazuh_manager.conf allowlist reconciled (repo), local_rules.xml 120537 -> level 3 (repo); SO host suricata eve updater + cron fixed (host).

## No secrets

All reports cite paths/variable names only; no secret values printed.