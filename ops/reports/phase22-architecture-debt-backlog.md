# Phase 22 Architecture Debt Backlog

Date: 2026-08-22

## Operational debt
| Item | Detail | Priority |
|---|---|---|
| 014 Sysmon EID7 flood | endpoint tuning blocked (access) | HIGH |
| 015 macOS flood | repair bundle ready; Mac access blocked | HIGH |
| NetFlow scope | 13 subnets unconfirmed, ~423K/24h | HIGH |
| pve222 API token | missing/401 | MED |
| Rule 120537 Redis loop | owner-blocked | MED |

## Engineering debt
| Item | Detail | Priority |
|---|---|---|
| Root disk 86% | trending; retention now enforced, review needed | HIGH |
| Swap 64% | sustained increase | MED |
| Duplicate backup crons | user crontab + cron.d | MED |
| wazuh_manager.conf canonical copy | repo has only stale backup artifact (7 vs 9 IPs) | MED |
| Cache manifest placeholders | sysmon/misp/greenbone | LOW |
| Rule file naming | phase18-zeek-rules.xml vs phase19-zeek-custom-rules-v2.xml | LOW |
| render-branded-template path | scripts/reporting vs reporting/generators | LOW |
| Evidence banners | 0/122 applied (claim in v1.0.0 notes) | LOW (addendum) |
| Client-dir hygiene | 33/42 files lack classification headers; internal artifacts present | MED |

## Architecture notes
- Zeek/Suricata signal now clean -> Class A routing is the next architectural step (approval-gated).
- Env-abstraction for wazuh-docker reduces skip-worktree reliance (documented).
- Single-manager cluster adequate; retention now enforced at all layers.

## No secrets