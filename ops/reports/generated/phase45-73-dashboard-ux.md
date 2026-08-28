# Phase 45: Dashboard Mobile and Accessibility

## Narrow Viewport (Mobile)
| Breakpoint | Width | Tested | Pass/Fail |
|------------|-------|--------|-----------|
| **Mobile** | 375px | [Y/N] | [PASS/FAIL] |
| **Tablet** | 768px | [Y/N] | [PASS/FAIL] |
| **Desktop** | 1440px | [Y/N] | [PASS/FAIL] |

### Mobile Checks
| Check | Pass/Fail |
|-------|-----------|
| **No Horizontal Scroll** | [PASS/FAIL] |
| **Touch Targets ≥ 44px** | [PASS/FAIL] |
| **Readable Text** | [PASS/FAIL] |
| **No Overlapping** | [PASS/FAIL] |

## Keyboard Navigation
| Check | Pass/Fail |
|-------|-----------|
| **Tab Order Logical** | [PASS/FAIL] |
| **Focus Visible** | [PASS/FAIL] |
| **Skip Links** | [PASS/FAIL] |
| **Escape Closes Modals** | [PASS/FAIL] |
| **No Keyboard Trap** | [PASS/FAIL] |

## Focus Indicators
| Element | Focus Visible | Contrast ≥ 3:1 | Pass/Fail |
|---------|---------------|----------------|-----------|
| **Links** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Buttons** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Form Fields** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Tabs** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Dropdowns** | [Y/N] | [Y/N] | [PASS/FAIL] |

## Contrast
| Element | Ratio | Threshold | Pass/Fail |
|---------|-------|-----------|-----------|
| **Text (Normal)** | [Ratio] | ≥ 4.5:1 | [PASS/FAIL] |
| **Text (Large)** | [Ratio] | ≥ 3:1 | [PASS/FAIL] |
| **UI Components** | [Ratio] | ≥ 3:1 | [PASS/FAIL] |
| **Graphics** | [Ratio] | ≥ 3:1 | [PASS/FAIL] |

## Labels
| Element | Label Present | Descriptive | Pass/Fail |
|---------|---------------|-------------|-----------|
| **Form Inputs** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Buttons** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Icons** | [Y/N] (aria-label) | [Y/N] | [PASS/FAIL] |
| **Links** | [Y/N] | [Y/N] | [PASS/FAIL] |

## Non-Color States
| State | Color Only? | Alternative | Pass/Fail |
|-------|-------------|-------------|-----------|
| **Error** | [Y/N] | Icon + Text | [PASS/FAIL] |
| **Success** | [Y/N] | Icon + Text | [PASS/FAIL] |
| **Warning** | [Y/N] | Icon + Text | [PASS/FAIL] |
| **Active/Selected** | [Y/N] | Border/Icon | [PASS/FAIL] |
| **Disabled** | [Y/N] | Opacity + Text | [PASS/FAIL] |

## Empty/Error States
| State | Message Present | Actionable | Pass/Fail |
|-------|-----------------|------------|-----------|
| **Empty Data** | [Y/N] | [Y/N] | [PASS/FAIL] |
| **Error** | [Y/N] | [Y/N] (Retry/Help) | [PASS/FAIL] |
| **Loading** | [Y/N] | [Y/N] (Progress) | [PASS/FAIL] |
| **No Permissions** | [Y/N] | [Y/N] (Contact) | [PASS/FAIL] |

## Links
| Check | Pass/Fail |
|-------|-----------|
| **Descriptive Text** | [PASS/FAIL] |
| **External Link Indicator** | [PASS/FAIL] |
| **New Tab Warning** | [PASS/FAIL] |
| **No Broken Links** | [PASS/FAIL] |

## Timestamps
| Element | Format | Timezone | Pass/Fail |
|---------|--------|----------|-----------|
| **Event Times** | ISO 8601 | EDT/UTC | [PASS/FAIL] |
| **Relative Times** | "5 min ago" | EDT | [PASS/FAIL] |
| **Last Updated** | Visible | EDT/UTC | [PASS/FAIL] |

## Automated Testing
```bash
# axe-core accessibility audit
npm install -g @axe-core/cli
axe https://grafana/dashboard/<uid> --save

# Lighthouse accessibility
lighthouse https://grafana/dashboard/<uid> --only-categories=accessibility
```

## Evidence
- [ ] Mobile viewport tested
- [ ] Keyboard navigation works
- [ ] Focus visible everywhere
- [ ] Contrast ratios met
- [ ] Labels present
- [ ] Non-color states work
- [ ] Empty/error states present
- [ ] Links accessible
- [ ] Timestamps correct

## Verdict
**UX/ACCESSIBILITY: [PASS/FAIL]**

## If FAIL
**Blocking Issues:**
1. [Issue 1]
2. [Issue 2]

**Remediation:** [Plan]
**Re-evaluation:** [Date]

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:46:00Z (UTC) / 2026-08-27T00:46:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after dashboard activate (Phase 45-71)*
