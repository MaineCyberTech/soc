# Phase 41 Security Audit

**Report ID:** phase41-87-security-audit
**Phase:** 41
**Title:** AUDIT-SEC-41 — Rotation Posture Verified Mode-600, Single XFO Header Re-Confirmed Live (XCTO Duplicate Remains), Shuffle api_key = Literal PLACEHOLDER On BOTH ossec.conf Nodes While Master virustotal Integration Flags REAL Inline Key (Value-Blind Probe), Corpus Secret-Scan Zero On New Files, Digest Pins Tabulated, Residuals Ranked With execute_python Fail-Open Bounded By Test-Only Disabled Lane
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:49:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-87-security-audit.md`

---

## 1. Rotation posture & credential modes

```
$ stat -c '%a %n' config/shuffle-api-key                    → 600
$ stat -c '%a %n' /opt/wazuh-docker/multi-node/ops/creds.env → 600 (outside repo)
```
Both credential stores hold the mandated mode 600; values never entered any report or
catalog this phase. Rotation cadence unchanged since the P39 remediation; no rotation
event due this cycle (next scheduled review with v1.3.1 cut, OW-41-04).

## 2. Listener / TLS re-verification

```
$ curl -sk -D - https://192.168.222.149:3443/   → HTTP 200
     X-Frame-Options: DENY                ← count = 1   (dedup DONE, phase41-66 holds)
     X-Content-Type-Options: nosniff      ← count = 2   (STILL duplicated — OW-41-01)
     Strict-Transport-Security: max-age=31536000
$ openssl s_client … | x509 → subject=issuer CN=shuffle.mgmt (self-signed TOFU)
     notBefore=Aug 26 00:51:52 2026 GMT · notAfter=Aug 23 2036 (10 y)
```

## 3. ossec.conf api_key checks — both nodes (value-blind probe)

```
$ awk masked probe, master:
  integration #1 name=virustotal  len=64  placeholder=NO    ← REAL KEY INLINE (flagged)
  integration #2 name=shuffle     len=27 placeholder=YES ✓
$ awk masked probe, worker:
  integration #1 name=shuffle     len=27 placeholder=YES ✓
```

The literal `SHUFFLE_API_KEY_PLACEHOLDER` remains in place on BOTH nodes — the
credential-by-reference pattern holds where P39 put it. FLAG: master carries a real
64-char VirusTotal key inline under `<integration><name>virustotal</name>` — value
never printed here; logged as **R-VTOSSEC** (pre-existing config lineage, owner:
Wazuh config owner; remediation = move to creds-env reference at next config window).

## 4. Corpus secret-scan on new files

Phase-38 CI Gate 4 re-run this phase covers the corpus; new phase41-81…92 content
adds zero secret-pattern lines beyond documented regex-literals (see phase41-84 for
embedded gate output). Manual sweep of scripts corpus: 0 hardcoded-cred files.

## 5. Image digest pins (condensed from live docker images --digests)

| Family | State |
|---|---|
| wazuh manager/indexer/dashboard 4.14.7 | digest-pinned ✓ |
| nginx:stable / nginx:1.27-alpine | pinned ✓ |
| opensearch 3.2.0 / 2.19.5, elastiflow 7.26.2 | pinned ✓ |
| shuffle app-sdk family | version tags; several by-ID (`<none>` digests) |
| opencanary/cloudflared/portainer/alpine/curl | `:latest` family — accepted policy exceptions (gate PASS, 20 exceptions) |

## 6. Synthetic markers honored

No synthetic/marked test traffic was allowed into production counters this session:
monitor fresh run reads-only; no IRIS case/billing mutations performed; compact-stats
lane is telemetry-neutral (stats_compact isolated to archives index, excluded from
scorecard queries). Canary discipline across three eras remains intact (phase41-89).

## 7. Residual risks ranked

| # | Risk | Bounding condition |
|---|---|---|
| 1 | hooks-unauth-LAN (Shuffle webhook endpoints reachable unauthenticated on LAN segment) + portainer 0.0.0.0 mgmt ports | LAN-trusted segment; exposure posture change is approval-gated |
| 2 | TOFU self-signed TLS cert CN=shuffle.mgmt (regenerated today 00:51Z during proxy work — trust event noted) | 10-y validity; pinning/rotation decision deferred to owner |
| 3 | execute_python param-injection platform defect (R-PKT-PLATFORM) | FAIL-OPEN bounded: packet lane TEST-ONLY and DISABLED; no production data path touches the defective node type |
| 4 | R-VTOSSEC real VT key inline in master ossec.conf | file mode/container-internal only; reference-pattern migration pending |
| 5 | XCTO duplicate header (compat/cosmetic) | OW-41-01 P4 |
