# Phase 42 Dashboard Client-Safe Separation Audit

**Report ID:** phase42-72-dashboard-client-safe
**Phase:** 42
**Title:** SAFE-42 — Classification Audit Of All 8 Objects (Value-Blind Title/Description Scan): Zero Objects Marked CLIENT-SAFE; Sensitive-Term Hits = Agent IDs 012/013/014, Group windows-clients, Hostname MCT-WIN11PILOT, Billing Concept; All Patterns Internal ⇒ Any CLIENT-SAFE Export Requires A Redacted Clone Set — Decision DEFERRED-OWNER; Boundary Statement Issued
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (audit; separation decision DEFERRED to owner)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-72-dashboard-client-safe.md`

---

## 1. Method

Value-blind scan of titles + descriptions across all imported objects (original ndjson
+ server-side read-back), plus index-pattern inventory. No metric VALUES were needed
or inspected for this classification — only object metadata.

## 2. Audit table

| Object | Type | Sensitive-term findings |
|---|---|---|
| p39-w1-windows-endpoints | dashboard | desc: agent IDs **012/013/014**, group **windows-clients** |
| p39-w2-windows-telemetry-quality | dashboard | desc: agent IDs 012/013/014; **billing eligibility** concept in title/desc |
| p39-w1-agent-status-metric | visualization | neutral title; parent context internal |
| p39-w1-lastkeepalive-freshness | visualization | neutral title |
| p39-w1-throttle-events | visualization | neutral title |
| p39-w2-eid-top-table | visualization | desc references Windows Eventchannel internals |
| p39-w2-telemetry-quality-metric | visualization | desc: alerts-vs-archives ratio concept (infra metadata) |
| p39-w2-billing-eligible-tagcloud | visualization | **billing** concept explicit |

(The four `-v2` clones inherit the same content with a `[v2]` suffix and remediation
note — same classification.)

## 3. Findings

- **CLIENT-SAFE-marked objects: none.** Every object is INTERNAL by content.
- Index patterns in play are internal only (`wazuh-alerts-*`, `wazuh-archives-*`
  runtime patterns; the saved objects carry zero `index-pattern` references — a
  static fact also relevant to render behavior).
- Exposure posture unchanged: global tenant, loopback/TLS-gated, auth required.

## 4. Decision request (deferred — owner)

A CLIENT-SAFE export would require a redacted clone set: generic titles (no billing,
no agent IDs), scrubbed descriptions, no infrastructure metadata, dedicated tenant.
Nothing client-facing is owed today; build ONLY on signed client-reporting demand.

## 5. Boundary statement

Current dashboards are authorized for INTERNAL analyst use exclusively. No object,
export, screenshot, or derived value from these dashboards is cleared for client
delivery in any form until the owner-approved CLIENT-SAFE clone set exists.
