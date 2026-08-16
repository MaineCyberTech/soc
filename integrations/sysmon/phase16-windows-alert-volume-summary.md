# Phase 16 Windows Alert Volume Summary

Date: 2026-08-16

## Per-agent (24h, current)

| Agent | Events/24h | Sysmon | level>=9 | Threats |
|---|---|---|---|---|
| 012 (pilot) | - | ~450 | historical FPs | none |
| 013 (client) | 1,301 | 213 | 128 (pre-deploy) | none |
| 014 (client) | 515 | 24 | 3 (1 real signal) | none |

## Post-suppression (06:15+)

- 92153/92900: 1 alert total (explorer.exe - non-listed, validated).
- Target: < 10 level>=9/day - trending correctly.

## No secrets
