# Phase 42 Dashboard Accessibility Assessment

**Report ID:** phase42-71-dashboard-accessibility
**Phase:** 42
**Title:** A11Y-42 — Contrast/Tab-Order/ARIA Are NOT Statically Verifiable In Saved-Object JSON (Explicit Unknown List); Color-Only Encoding Scan: ZERO `color` Params Across All visStates (Tagcloud Size-Encoding Only); Keyboard-Navigability Notes From OSD Product Knowledge; Verdict ACCESSIBILITY-REVIEW-REQUIRED-BROWSER
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (static scans COMPLETE; browser review REQUIRED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-71-dashboard-accessibility.md`

---

## 1. Explicit unknown list (cannot be certified from artifacts)

1. **Contrast ratios** — text/background colors come from the runtime theme; WCAG
   2.1 AA (4.5:1 body, 3:1 large) cannot be computed from saved objects.
2. **Tab order / focus management** — DOM order and focus rings exist only in the
   rendered app; panelsJSON carries no ordering semantics beyond visual grid coords.
3. **ARIA roles/labels** — generated at render time by the visualization plugins
   (metrics, table, histogram, tagcloud); absent from visState.
4. **Screen-reader announcements** for dynamic data refresh — runtime only.
5. **Touch/keyboard interactivity of table pagination** — runtime only.

## 2. Color-only encoding scan (run, real result)

```
grep -c 'color' w1-w2-windows-endpoints.ndjson        → 0
grep -c 'color' w1-w2-windows-endpoints-v2.ndjson     → 0
```
No custom color params exist in any visState; the tagcloud encodes magnitude by
SIZE (count → tag size), not hue alone — favorable for color-blind users, pending
runtime confirmation that default palettes aren't the sole differentiator elsewhere.

## 3. Keyboard-navigability notes (OSD product knowledge)

OpenSearch Dashboards provides global keyboard shortcuts and a logical tab flow
through dashboard → panel → panel actions; tables support arrow-key cell navigation.
Saved-object definitions cannot confirm these behaviors are intact for specific vis
types; they are inherited from the platform and expected to hold.

## 4. Verdict

**ACCESSIBILITY-REVIEW-REQUIRED-BROWSER.** Fold steps into the prepared session kit
(phase42-68 step 7): keyboard-only pass over W1/W2[v2], OS-level screen-reader spot
check optional, contrast measured via dev-tools on the rendered theme. Until then no
accessibility claim is issued — none was possible honestly.
