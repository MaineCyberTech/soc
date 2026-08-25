# Phase 32 Wazuh Rule Design

Date: 2026-08-25
- Default Wazuh suricata rules (19007-series, "Suricata: Alert") match eve alert events -
  no custom rule needed for base detection.
- Custom rules (if needed for severity/naming) go in local/custom rule files (NOT
  upgrade-managed ruleset files) - per research-notes.

## No secrets
