# Phase 45: Dashboard Client Safety

## Excluded Content (Client Views)
| Category | Excluded | Verification |
|----------|----------|--------------|
| **Topology** | Network diagrams, internal IPs | [PASS/FAIL] |
| **Secrets** | API keys, tokens, passwords | [PASS/FAIL] |
| **Internal IDs** | Database IDs, UUIDs, correlation IDs | [PASS/FAIL] |
| **Raw Evidence** | Full packet captures, PCAPs | [PASS/FAIL] |
| **Owner Actions** | Delete, config, admin buttons | [PASS/FAIL] |
| **PII** | User emails, names, IPs (if sensitive) | [PASS/FAIL] |

## Client View Verification
| Check | Method | Pass/Fail |
|-------|--------|-----------|
| **Viewer Role Access** | Login as Viewer role | [PASS/FAIL] |
| **No Topology Panel** | Check panel list | [PASS/FAIL] |
| **No Secret Variables** | Inspect panel JSON | [PASS/FAIL] |
| **No Internal IDs** | Inspect panel JSON | [PASS/FAIL] |
| **No Raw Evidence** | Check panel data sources | [PASS/FAIL] |
| **No Owner Buttons** | Check panel actions | [PASS/FAIL] |

## Permissions Matrix
| Role | Can View | Can Edit | Can Admin | Can Delete |
|------|----------|----------|-----------|------------|
| **Viewer** | ✅ | ❌ | ❌ | ❌ |
| **Editor** | ✅ | ✅ | ❌ | ❌ |
| **Admin** | ✅ | ✅ | ✅ | ✅ |

## Data Filtering
| Panel | Sensitive Data | Filtered | Method |
|-------|----------------|----------|--------|
| **Alert Table** | Internal IPs | [Y/N] | [Transform] |
| **Event Details** | Correlation IDs | [Y/N] | [Transform] |
| **Network Map** | Internal Topology | [Y/N] | [Hidden] |
| **Raw Logs** | Full Payload | [Y/N] | [Hidden] |

## API Permissions
| Endpoint | Viewer | Editor | Admin |
|----------|--------|--------|-------|
| `/api/dashboards/uid/*` | Read | Read/Write | All |
| `/api/datasources/proxy/*` | Restricted | Limited | Full |
| `/api/alerts` | Read | Read | Full |

## Automated Check
```bash
# Test viewer access
curl -H "Authorization: Bearer $VIEWER_TOKEN" \
  "https://grafana/api/dashboards/uid/<uid>" | jq '.meta.isFolder, .dashboard.panels[] | select(.type=="table") | .columns[] | select(.text | test("secret|password|token|internal|uuid|topology";"i"))'

# Expected: No matches (empty array)
```

## Evidence
- [ ] Viewer role tested
- [ ] No topology in client view
- [ ] No secrets exposed
- [ ] No internal IDs exposed
- [ ] No raw evidence accessible
- [ ] No owner actions visible
- [ ] Permissions matrix correct

## Verdict
**CLIENT SAFETY: [PASS/FAIL]**

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
*Generated: 2026-08-27T04:47:00Z (UTC) / 2026-08-27T00:47:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after dashboard activate (Phase 45-71)*
