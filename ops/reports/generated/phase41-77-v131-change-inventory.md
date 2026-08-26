# Phase 41 v1.3.1 Change Inventory — D-1..D-10

**Report ID:** phase41-77-v131-change-inventory
**Phase:** 41
**Title:** CHANGE-INV-41-01 — Full v1.3.1 Change Inventory Table D-1..D-10: Eight Staged Deltas Carried From P40 phase40-96 Plus Two P41 Additions (Compact-Stats Containment Chain; Manager/Worker Network Attachment Migration), Each With Security-Impact / Compat / Migration / Docs / Tests / Rollback / Client-Impact Columns; P41 Adjacent Records Mapped To Existing Rows
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:54:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-77-v131-change-inventory.md`

---

## 1. Scope

Complete delta inventory for the tabled v1.3.1 tag. D-1…D-8 carry forward from
the P40 candidate manifest (`phase40-96-release-assurance.md` §3); D-9 and D-10
are Phase-41 additions. Every item is labeled, none silent.

## 2. Inventory table

| # | Delta | Security impact | Compat | Migration needed | Docs | Tests | Rollback | Client impact |
|---|---|---|---|---|---|---|---|---|
| D-1 | Index template `wazuh-archives-fieldlimit` (total_fields.limit 2000 + ISM carried, priority 320) folded into repo config | HIGH — reproduces rejection-flatline posture on rebuild; prevents field-explosion rejection storms | Template API only; additive priority-scoped | None at runtime (template already live); repo-side capture only | REPO-MAP/config notes in tag | Field-fix VERIFIED (P38→P39 arc); ISM-ready checks phase41-53 series | Remove template definition from repo (runtime template persists) | None |
| D-2 | Shuffle publish binding hardening in `compose/docker-compose.shuffle.yml` (working tree) | HIGH — closes plaintext LAN publish exposure | Compose-file change; no data-format impact | Recreate Shuffle stack on deploy | SECURITY.md exposure posture section | TLS :3443 proven P40 (phase40-32) | Revert compose line; re-exposes old binding (known-bad) | None (LAN users use TLS URL) |
| D-3 | **TLS reverse-proxy service**: compose service + `config/shuffle-tls/nginx-shuffle-proxy.conf` (:3443, TLSv1.2/1.3, HSTS/XFO/nosniff); cert fingerprint pinned; XFO dedup fix folded (phase41-65/-66) | HIGH — encrypted admin path; header hygiene deduplicated to single config source | New service + network member; nginx pinned `1.27-alpine` | Cert config referenced by path; renewal runbook cites repo conf | PORTS.md :3443; renewal procedure | Runtime-stable under v1.3.0 operation; header audit phase41-65 | Stop/remove proxy service; plaintext binding remains hardened per D-2 | Browser trust prompt for self-signed cert (known, disclosed) |
| D-4 | **Webhook integrator blocks** in manager ossec.conf, config-of-record BOTH nodes | MEDIUM — enables automated routing lane as configuration-of-record rather than runtime-only drift | ossec.conf blocks both master+worker; no schema change | None (blocks already live) | Integration docs reference blocks | Wazuh→Shuffle trigger WIRED+PROVEN end-to-end (phase40-37/-40) | Comment out blocks; routing lanes stop (documented dependency) | None |
| D-5 | Shared-config ownership fix procedure (merged.mg / agent.conf chown wazuh:wazuh), incl. windows-clients sweep record | MEDIUM — prevents 83k-error permission-denied defect class on fresh deploys | Filesystem ownership convention; no format change | SOP content only; fresh deploys get it by construction | AGENTS.md SOP note (phase41-68 §5) | BAK-41-01 regression PASS (phase41-68 §4) | N/A (ownership normalization is strictly corrective) | None |
| D-6 | ISM policy correction procedure (archives-14d remove→add) + archives-fieldlimit template | MEDIUM — retention drift becomes correctable without force-delete temptation | ISM API; sanctioned-tooling compatible | Runbook content | Retention closeout phase41-60 | ISM wave observed + restore spot-check (phase41-54/-57) | Re-apply prior policy via same scripted path | None |
| D-7 | **Delivery-monitor cron entry + hardened script** (`p39-iris-delivery-check.sh` flock-hardened; */15 crontab line) with watchdog behavior | LOW/MEDIUM — SLA-visible delivery monitoring becomes part of service definition | Cron + script; no stack dependency | Crontab entry documented for fresh hosts | Script header comments | Monitor scheduled and observed (phase40-66/-67) | Remove cron line; monitoring goes dark (acceptable) | None |
| D-8 | **Dashboard NDJSON saved objects** (8 objects, global tenant import receipts) shipped as artifact + re-import step | LOW — visibility layer versioned with code | OpenSearch Dashboards import format | Import step in deploy docs | Dashboard docs + import receipts (phase40-62) | Imported 8/8 global tenant; runtime baseline phase41-61 | Delete saved objects via UI/API; dashboards vanish (no data loss) | Visual login pending owner (BCK-40-010) |
| **D-9** *(P41)* | **Compact-stats containment chain**: sensor `suricata.yaml` compact-stats settings + emitter + timer + agent localfile stanza | MEDIUM — bounds stats telemetry volume/disk growth at source; keeps sensor observable without log flooding | Sensor config + Wazuh localfile chain; additive fields | Fresh sensors get it via config-of-record; existing sensor needs one config sync | Sensor config notes in tag | Runtime-stable now under v1.3.0 operation (documented-delta model) | Revert yaml stanza + disable timer/localfile | None |
| **D-10** *(P41)* | **Network attachment migration**: wazuh manager/worker compose services attached to `mct-security` network | MEDIUM — consistent segmentation posture; services reachable through the stack's governed network | Compose network membership; no exposed-port change | Deploy-time recreate of the two services | PORTS.md/compose annotations | Runtime-stable now (documented-delta model working) | Revert attachments to prior networks | Brief container recreate during apply |

## 3. P41 adjacent records mapped into existing rows

| Record | Folded into |
|---|---|
| XFO header audit + dedup fix (phase41-65/-66) | D-3 |
| Windows `.bak` audit + fix verification (phase41-67/-68) | D-5 |
| Delivery-monitor watchdog behavior | D-7 |
| Custody closure CUSTODY-41-01 (phase41-75/-76) | Non-code: ops-process record; not a tree delta, informs release plan step 6 |

## 4. Disposition

All ten items are **runtime-stable NOW under v1.3.0 operation** and ride the
documented-delta model until the v1.3.1 tag lands. Cut decision:
phase41-78-v131-release-decision.md.
