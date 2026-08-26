# Phase 40-29: TLS Blocked-Path Test (DENY-40-02)

**Report ID:** phase40-29-tls-blocked-test
**Phase:** 40
**Title:** Phase 40-29: Shuffle Plaintext Closure — Negative Tests and Scope Statement
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-29-tls-blocked-test.md`

---

Test ID DENY-40-02, executed 2026-08-26T01:59Z.

## 1. Blocked-Path Results

**1a. LAN plaintext to frontend — REFUSED**

```
$ curl -s -o /dev/null -w 'rc=%{http_code}\n' --connect-timeout 3 http://192.168.222.149:3001/
rc=000
curl_exit=7
```
(curl exit 7 = connection refused; publish is now `127.0.0.1:3001:80` only.)

**1b. Docker-bridge source to TLS listener — REFUSED**

```
$ curl -sk -o /dev/null -w 'rc=%{http_code}\n' --connect-timeout 3 https://172.17.0.1:3443/
rc=000
curl_exit=7
```
The proxy binds the management IP only; the bridge gateway cannot reach it.

**1c. Listener-state corroboration (ss)**

```
LISTEN 0 4096  192.168.222.149:3443  0.0.0.0:*
LISTEN 0 4096  127.0.0.1:3001        0.0.0.0:*
LISTEN 0 4096  127.0.0.1:5001        0.0.0.0:*
```
No `0.0.0.0` or wildcard management-plane listener remains.

## 2. Recovery Lane (not a finding)

`http://127.0.0.1:3001/` → `http=200` from the host itself only — intentional
SSH-tunnel emergency path, verified intact post-change.

## 3. Scope Statement (explicit non-overstatement)

These tests prove **host-interface binding semantics reachable from this environment**:
the plaintext port refuses connections on the LAN-facing interface, and the TLS
listener accepts only on the management IP. **Public-internet reachability is NOT
claimable from inside this LXC** — the upstream router/firewall posture is outside
this environment's visibility and out of scope for this arc. Claims herein are bounded
to LAN/host-interface behavior; no broader exposure claim is made.

## 4. Verdict

**PASS-with-scope.** All in-scope negative tests deny as designed; recovery lane intact.
