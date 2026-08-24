# Phase 28 Licensing and Third-Party Audit

Date: 2026-08-24

## Third-party inventory (in scope of the stack + endpoints)

| Component | License | Notes |
|---|---|---|
| Wazuh (manager/indexer/dashboard/agent) | GPL-2.0 | source-available; endpoint redistribution OK |
| DFIR-IRIS | GPL-3.0 | docker images |
| Shuffle | AGPL-3.0 | workflow platform |
| Velociraptor | AGPL-3.0 | cache manifest |
| ElastiFlow | proprietary (free community core) | flow collector - check redistribution |
| Tenzir | proprietary/community | pin + review terms |
| OpenCanary | BSD-3 | deception |
| syslog-ng | LGPL-2.1/GPL-2.0 | bridge |
| RabbitMQ | MPL-2.0 | iris queue |
| OpenSearch (wazuh-indexer distro) | Apache-2.0 | plugins covered by Apache-2.0 |
| Sysmon | **Sysinternals EULA** | **cache-only; do NOT vendor into client bundle** |
| osquery | Apache-2.0 | endpoint |
| Python wheels (requests/pyyaml/pymisp) | OSI (MIT/Apache) | optional tooling |

## Client-delivery constraints

- Bundle must NOT vendor Sysmon binary (EULA). Cache-only for internal deployment.
- Wazuh/Velociraptor AGPL/GPL redistribution: provide source offer per license terms.
- ElastiFlow/Tenzir proprietary: confirm scope with vendor before client redistribution.

## Findings

- No LICENSES/THIRD-PARTY file at repo root - add consolidated notice (P2, 48).

## No secrets