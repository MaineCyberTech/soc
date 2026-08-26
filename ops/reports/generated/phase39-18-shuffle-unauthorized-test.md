# Phase 39 Shuffle Unauthorized Access Validation — DENY-39-01

**Report ID:** phase39-18-shuffle-unauthorized-test
**Phase:** 39
**Title:** DENY-39-01 — Unauthorized-Path Blocking Validation (Interface-Level Scope)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:57:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (scope-limited pass)
**Record ID:** DENY-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-18-shuffle-unauthorized-test.md`

---

## 1. Objective

Demonstrate that connection attempts to :3001 arriving via non-approved local
interfaces are refused after the bind-address hardening, and state precisely
what the evidence does and does not prove.

## 2. Contexts Tested

| # | Source context | Target | Expected | Observed | Result |
|---|---|---|---|---|---|
| D1 | Loopback (`127.0.0.1`) | `http://127.0.0.1:3001/` | refused | **curl rc=7** (connection refused), http_code 000 | BLOCKED |
| D2 | Docker bridge gateway (`docker0`) | `http://172.17.0.1:3001/` | refused | **curl rc=7** (connection refused), http_code 000 | BLOCKED |
| D3 | External-interface semantics | `192.168.222.149:3001` accepts; all other local addresses have no listener | only .149 answers | `ss` shows single LISTEN pinned to `192.168.222.149:3001`; wildcard absent | BLOCKED-by-binding-semantics |
| D4 | Approved control probe | `http://192.168.222.149:3001/` | 200 | HTTP 200 rc=0 | OPEN (expected) |

## 3. Verbatim Evidence

```
$ for u in http://127.0.0.1:3001/ http://172.17.0.1:3001/; do \
    curl -s -o /dev/null -w '%{http_code}' --max-time 4 "$u"; echo " rc=$?"; done
000 rc=7
000 rc=7

$ ss -tlnp | grep ':3001'
LISTEN 0      4096   192.168.222.149:3001       0.0.0.0:*
```

rc=7 = CURLE_COULDNT_CONNECT: TCP SYN rejected — nothing is listening on those
addresses. This is refusal at the socket layer, stronger than an HTTP error
(which would prove the service answered).

## 4. Honest Limitation Statement (mandatory reading)

These tests were executed **from inside the LXC guest**. They conclusively
prove host-interface-level blocking:

- loopback cannot reach the service;
- container bridge gateways cannot reach it;
- only the ens18 address carries a listener.

They do **NOT** constitute a true public-internet reachability test. Proving
that an arbitrary internet host cannot connect would require probing from
outside the LXC boundary (second host, or router/firewall visibility), which
was unavailable in this window. The claim certified here is therefore scoped:
**"no listener exists on any non-mgmt interface of this host"** — a structural
guarantee of the bind itself. Residual exposure equals whatever the upstream
network (mgmt VLAN 192.168.222.0/24 and anything the router forwards toward
.149) permits; router-side posture is out of this host's evidence scope and
logged as such in SHUFFLE-SEC-39-01 residual risks.

## 5. Verdict

**PASS-WITH-SCOPE.** All testable unauthorized interface paths are blocked at
TCP-refusal level; approved path remains open; public-internet claim explicitly
out of evidence scope per §4.
