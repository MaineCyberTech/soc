# Phase 30 Dependency and Supply Chain Audit

Date: 2026-08-24

## Inventory

| Class | Locks/identity | Status |
|---|---|---|
| Images | dependency-lock.json + image-pin-set.json (digests); 8 mutable pinned | PASS |
| CI actions | checkout@v4 (major tag) | hardening item |
| Python | stdlib-only core; optional pins (requirements.txt) | PASS |
| OS packages | endpoint installers pin wazuh-agent=$WAZUH_VERSION-1, osquery | PASS |
| Binaries | velociraptor 0.77.2 (sha256 in cache manifest) | PASS |
| Plugins | wazuh-indexer plugin set (2.19.5.0) | PASS |
| Sysmon | 15.21 / schema 4.91 (EULA cache-only) | recorded |
| Cache | repo-artifact-cache-manifest.json (sha256, source, license) | PASS |
| Vulnerabilities | no known-critical in pinned set; review cadence monthly | watch |

## Findings

- Mutable CI action tag (checkout@v4) - pin to SHA (P2).
- Sysmon zip not cached (operator download; EULA) (P2).
- Cache manifest expiry 2026-09-24.

## Verdict

- **PASS** (runtime images pinned; remaining items backlogged).

## No secrets