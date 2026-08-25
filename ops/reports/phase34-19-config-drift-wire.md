# Phase 34 Sensor Configuration Drift Alert

Date: 2026-08-25

## Implementation
- Compare canonical (repo) vs runtime (sensor) config hashes
- Check: suricata.yaml, suricata-update config, systemd unit, Wazuh localfile, rotation
- Alert on unauthorized changes

## Current state
- Canonical: /opt/mct-security-stack/integrations/suricata-minimal/suricata.yaml
- Runtime: /etc/suricata/suricata.yaml on mct-soc-scan
- Hash comparison: canonical vs runtime (verified P32)

## Evidence
- No drift detected (config reconciled P32)
- Canonical source map maintained

## Runbook
- Reconcile config drift
- Verify canonical source is authoritative

## No secrets
