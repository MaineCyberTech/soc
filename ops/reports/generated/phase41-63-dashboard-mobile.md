# Phase 41 Dashboard Mobile Assessment — Static Analysis Only

**Report ID:** phase41-63-dashboard-mobile
**Phase:** 41
**Title:** MOB-41-01 — Mobile Suitability Assessed Statically From ndjson Panel Definitions: Both Dashboards Use The 12-Column Grid With A Full-Width (w=12) Metric Row Above Two Half-Width (w=6+6) Panels — Narrow-Viewport Collapse Is Framework Behavior, NOT Verified; Runtime Device Testing PENDING-OWNER-DEVICE; Contrast/Tab-Order Explicitly UNKNOWN (Not Verifiable Statically)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:33:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (static layout analysis COMPLETE; runtime device testing DEFERRED to owner device)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-63-dashboard-mobile.md`

---

## 1. What was analyzed

Panel grid definitions extracted from the import-receipt source ndjson
(`ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson`), both dashboards:

```
p39-w1-windows-endpoints            panels:3
    x=0 y=0 w=12 h=3     ← full-width metric strip
    x=0 y=3 w=6  h=4     ← half-width lower-left
    x=6 y=3 w=6  h=4     ← half-width lower-right
p39-w2-windows-telemetry-quality    panels:3
    identical geometry (12 / 6+6)
```

## 2. Static mobile claims (and their limits)

| Property | Static finding | Claim strength |
|----------|----------------|----------------|
| Grid system | OpenSearch Dashboards 12-column responsive grid | VERIFIED (definitions) |
| Widest element | w=12 (single column on phone-width ⇒ stacks naturally) | VERIFIED statically |
| Half-width pair | w=6+6 side-by-side on desktop; framework collapses to stacked below breakpoint | FRAMEWORK BEHAVIOR — not verified here |
| Table scroll | h=4 viewports with table vis ⇒ internal scroll on small screens | EXPECTED, unverified |
| Touch targets | default OSD chrome | UNVERIFIED |

Honest boundary: static analysis supports "no layout element wider than one mobile
column" and "standard responsive framework". It cannot prove rendering.

## 3. Explicit unknowns (listed, not buried)

1. **Runtime device rendering** — PENDING-OWNER-DEVICE: needs a real phone/tablet
   session over the tunnel/loopback path; cannot be synthesized honestly.
2. **Contrast ratios** — theme colors vs WCAG contrast thresholds: not derivable
   from ndjson (theme applied at runtime).
3. **Tab order / keyboard navigation** — DOM order and focus behavior: not present
   in saved objects; requires live session audit.
4. **Touch interactions on tables/tagcloud** — unverified.

## 4. Recommendation

When the owner performs the pending login-based render check (phase41-62 §4), do it
once on a narrow viewport; that single session closes items 1–4 above or produces
concrete defects. Until then, mobile suitability is "statically plausible,
dynamically unproven".
