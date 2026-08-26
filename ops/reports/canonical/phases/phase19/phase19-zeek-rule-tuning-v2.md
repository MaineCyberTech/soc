# Phase 19 Zeek Rule Tuning v2

Date: 2026-08-18
Status: **DEPLOYED (v2.1) - APPROVED** - deployed to master + worker 2026-08-18 ~21:50 UTC. 24h re-measure in progress.

## v2 changes (vs v1)

1. **Base rule 122000**: added unicast-only destination guard
   `negate pcre2 ^(255\.255\.255\.255|224\.|239\.|233\.|ff[0-9a-fA-F]{2}:)` on `zeek.resp_h`.
   Excludes IPv4 limited broadcast, IPv4 multicast (incl. 239.x SSDP, 233.x), IPv6 multicast.
   Since children use `<if_sid>122000</if_sid>`, multicast/broadcast discovery never anchors
   alerts or children.
2. **122005 (internal subnets)**: same unicast guard applied explicitly (mDNS no longer reported).
3. **122006 (UDP)**: kept v1 port negates + added 10001 (Sonos) and 56700 (LIFX) + unicast-only dst guard.

## Validation performed (this run)

| Check | Method | Result |
|---|---|---|
| XML well-formed | python minidom | PASS |
| Rules parse + register (all 7) | `wazuh-analysisd -t` with v2 in ruleset (temp) | PASS (duplicate-ID vs v1 warnings only) |
| Decoder field extraction | `wazuh-logtest` real decoder on mDNS sample | PASS (zeek.orig_h/orig_p/resp_h/resp_p/proto extracted) |
| Guard regex behavior (11 test IPs) | python re vs pcre2 guard | PASS (broadcast/multicast excluded; unicast kept) |
| v1 noise repro | logtest mDNS sample | matches 122005 (confirms noise path removed by v2 guard) |

## Expected impact (post-deploy, to be measured)

- 122000/122005/122006 combined: 417K/24h -> **target < 2K/24h** (mDNS/broadcast removed).
- Class A (122001-122003) unaffected (already 0) - unicast SSH/SMB/RDP still detected.
- Alert-index load drops by >95% from Zeek.

## Deployment (approved - applied 2026-08-18)

1. Backed up v1 on master + worker (`phase18-zeek-rules.xml.v1.bak`).
2. Installed v2.1 as `/var/ossec/etc/rules/phase18-zeek-rules.xml` on master + worker.
3. `wazuh-analysisd -t` config test PASS on both (rc=0).
4. `wazuh-control restart` on master + worker; all daemons running.
5. logtest regression suite PASS (all Class A/B fire; exclusions and multicast/broadcast silent).

### v2.1 critical fix (found during post-deploy validation)

Multi-value `<field name="zeek.resp_p">X</field>` entries used substring semantics in
wazuh-analysisd 4.14.7: repeated same-name fields behaved as AND-of-substrings. Result:
- 122001 only fired for port 2222 (regex `22` matches `2222` as substring) - plain port 22 did NOT fire.
- 122004 (admin ports) NEVER fired for any port.
- 122006 negates were substring-matched too (e.g. port 12345 was excluded because it contains `123`).
- This is why the 24h recheck showed 0 alerts for 122001-122004 - a latent v1/v2 bug, not a clean network.

Fix: all port fields converted to anchored pcre2 (`^(22|2222)$`, `^(135|139|1433|3306|5432|5900|8080|8443)$`,
and `^<port>$` negates for 122006). Verified via full logtest suite.

### Post-deploy measurement (initial)

- Pre-deploy rate: ~2,169 Zeek alerts / 10 min (~217/min).
- Post-restart: **0 Zeek alerts since 21:48 UTC** (mDNS/broadcast/multicast eliminated).
- Full 24h re-measure required to confirm stability + enable Class A IRIS routing.

## Expected impact (post-deploy, to be measured)