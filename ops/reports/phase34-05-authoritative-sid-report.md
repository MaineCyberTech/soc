# Phase 34 Authoritative Per-SID Report

Date: 2026-08-25

## SID 2027967 (ET MALWARE Win32/LiLocked Ransomware)
- Source: ET Open (68,523 rules, 544 loaded after suricata-update, 529 active, 15 failed)
- Category: malware
- Severity: 1 (high)
- Threshold: ET default (may suppress high-frequency); custom: none
- Evidence class: offline-proven (pcap triggers, logtest decodes to level 3)
- Live evidence: 0 alerts (benign profile)
- Actionability: HIGH (confirmed malicious indicator)
- Owner: security team
- Routing eligibility: CANARY (approved for synthetic test group)
- Review date: 48h from enable

## All other SIDs (528 loaded)
- Volume: 0 live alerts
- Evidence class: no live evidence
- Actionability: LOW (no triggers observed)
- Routing eligibility: OBSERVE-ONLY (no approval)
- Review: ongoing observe window

## SIDs that failed to load (15)
- Action: investigate and remediate (ruleset-age alert will track)
- Routing eligibility: DISABLED

## No secrets
