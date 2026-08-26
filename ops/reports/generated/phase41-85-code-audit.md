# Phase 41 Code Audit

**Report ID:** phase41-85-code-audit
**Phase:** 41
**Title:** AUDIT-CODE-41 — Scripts Inventory 108 Files All Syntax-Clean (bash -n ×92 = 0 Failures, py_compile Clean) With 92/92 Exec Bits, Secret-Pattern Sweep Zero Non-Literal Hits, Four Compose Configs VALID Against Root .env, CI Workflow Listing Pinned, Dead-Code Refresh Yields 3 Containment-Superseded Candidates, Sensor Emitter Quality Reviewed Line-by-Line
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:45:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-85-code-audit.md`

---

## 1. Host scripts inventory & syntax

```
$ ls ops/scripts/*.sh ops/scripts/*.py | wc -l   → 108   (.sh=92)
$ for f in ops/scripts/*.sh; do bash -n "$f"; …  → bash-n-failures=0
$ python3 -m py_compile ops/scripts/*.py (non-example) → no failures
$ find ops/scripts -maxdepth 1 -name '*.sh' -executable | wc -l → 92 / 92
```

## 2. Secret-pattern sweep (counts; regex-literals only verified)

```
$ grep -rlE '(password|token|api_key)\s*=\s*["'\'']?[A-Za-z0-9]{16,}|stCG-…|Bearer …'
      ops/scripts/                      → 0 files
$ stCG- token-literal hits excluding pattern/regex definition lines → 0
```

Zero hardcoded credentials in the script corpus; every credential reference is a
path or environment-variable read (`${WAZUH_ADMIN_PASSWORD}` pattern per AGENTS.md).

## 3. Compose config validations (config -q)

```
$ docker compose --env-file /opt/mct-security-stack/.env -f <file> --profile shuffle config -q
docker-compose.shuffle.yml     → VALID
docker-compose.dfir-iris.yml   → VALID
docker-compose.phase2.yml      → VALID
docker-compose.opencanary.yml  → VALID
```

NOTE (drift D-41-PATH): AGENTS.md Credential Handling names `compose/.env`, but the
actual env file lives at repo root `.env` (`compose/.env` does not exist). Carried to
the next CHG window rather than re-editing AGENTS.md after CHG-41-AGENTS-01 sealed
its hash chain.

## 4. CI workflows listing

```
$ ls .github/workflows/ → verify.yml
```
`verify.yml`: bash -n over all *.sh, py_compile over all *.py, shellcheck
(installed-on-runner), checkout action pinned by full SHA (`actions/checkout@11d5…`
# v4 pinned). Triggers: pull_request + push→main.

## 5. Dead-code refresh (heuristic: referenced nowhere in scripts/canonical/workflows/crontab)

```
UNREFERENCED: p31v2-eve-rate.py
UNREFERENCED: p32-eve-analysis.py
UNREFERENCED: p32-suricata-stats-gate.py
```
All three are eve-stats analysis utilities superseded by the P41 source-side
containment (stats no longer enter eve.json at scale). Disposition: archive
candidates; deletion stays approval-gated (AGENTS.md safety rules).

## 6. Pin status table (docker images --digests, live)

| Image | Tag | Digest pinned |
|---|---|---|
| wazuh/wazuh-manager | 4.14.7 | sha256:c364ef10… ✓ |
| wazuh/wazuh-indexer | 4.14.7 | sha256:fba7f2a0… ✓ |
| wazuh/wazuh-dashboard | 4.14.7 | sha256:b175a395… ✓ |
| nginx:stable (proxy/multi-node) | stable | sha256:46ccc48f… ✓ |
| nginx:1.27-alpine (shuffle-tls-proxy) | 1.27-alpine | via compose pin ✓ |
| opensearchproject/opensearch | 3.2.0 / 2.19.5 | digest visible ✓ |
| elastiflow/flow-collector | 7.26.2 | sha256:c668429f… ✓ |
| frikky/shuffle app images (http/tools/email/ai/subflow) | version tags | partial — several `<none>` (pulled-by-ID); registry.hub mirrors unpinned |
| thinkst/opencanary, cloudflared, portainer-ce:sts, alpine, curlimages/curl | latest/sts | **unpinned :latest family** |

Gate: `check-unpinned-docker-images.sh` → **PASS (exceptions allowed per policy: 20)**.
Residual: the `:latest` decoy/utility family remains the known accepted exception set.

## 7. Sensor-side `suricata-compact-stats.py` quality review (read via `ssh -o BatchMode=yes mct-soc-scan`)

| Aspect | Verdict |
|---|---|
| Design | GOOD — whitelist of exactly 16 counters → flat JSON line `event_type:stats_compact`; bounded field count is THE containment mechanism |
| Correctness | GOOD — recursive flatten fallback; list-take-first handles multi-thread counter arrays; `suricatasc -c dump-counters` with timeout=20 |
| Failure mode | FAIL-SILENT (`except Exception: sys.exit(0)`) — acceptable for a stats-only lane (cannot corrupt ingest) BUT failures are invisible except via doc-count monitoring; watchdog covers the monitor lane, not this one. Watchlist item. |
| Portability | MINOR — `datetime.utcnow()` deprecated on Python ≥3.12 (works today on sensor's runtime) |
| Housekeeping | MINOR — output file `/var/log/suricata/eve-stats-compact.json` grows ~1.4 MB/day append-only; no logrotate rule seen on sensor; trivial volume, non-urgent |
| Cadence | timer OnUnitActiveSec=60; service starts since 00:00Z today = 136 (journal boundary 03:56Z); docs indexed to 08.26 archives = 129 — consistent within agent batch lag |

## 8. Findings ranked

1. LOW — emitter fail-silent (add future heartbeat/doc-count guardrail).
2. LOW — AGENTS.md env-path drift (`compose/.env` vs root `.env`) — doc fix next CHG.
3. INFO — 3 dead-code candidates (archive).
4. INFO — sensor logrotate absent for compact out-file.
5. PASS — everything else clean.
