# Phase 31v2 Packet Objectives

Date: 2026-08-24

## Objectives

- Production packet inspection via a standalone sub-2GiB Suricata sensor; EVE JSON (alert-only)
  collected by a Wazuh agent; bounded routing (no firehose); no PCAP/file extraction.
- Monitored: SPAN mirror of client/multi-VLAN (192.168.111.0/24 + others) at mct-soc-scan.

## Constraints

- < 2 GiB measured memory; 0 sustained drops; CPU bounded; detection quality gate;
  privacy (no payload); storage bounded (EVE rotation).

## Acceptance

- Production benchmark (20), Wazuh ingest (18), freshness/failure/rollback (22/45), and a
  detection gate (ruleset that actually fires on the observed profile) all PASS before
  production claim. No simulated PASS.

## No secrets