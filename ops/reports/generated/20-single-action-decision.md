# Phase 46: Single Action Decision Record

## Purpose
Document why a single `execute_python` action was chosen over a multi-node workflow design.

## Findings

### Original Design (Multi-node)
- Used Shuffle native nodes (HTTP, Transform, etc.)
- Template variables (`$hook.data`, `$exec`) do not resolve for `execute_python` params
- Failed to pass data between nodes reliably

### Current Design (Single execute_python)
- All logic consolidated in one `execute_python` action
- Inline processing: parsing, IRIS API call, logging
- Bypasses variable interpolation issues entirely

### Root Cause: R-PKT-PLATFORM Defect
- `execute_python` cannot receive workflow variables via standard Shuffle interpolation
- Only the **HTTP app node** type properly interpolates `${}` references
- No other node type reliably passes dynamic data into `execute_python` parameters

### Decision Rationale
- **Single action is the only viable path** given current platform limitations
- Multi-node design would require working variable interpolation, which is broken for `execute_python`
- HTTP app node is not suitable for the full logic chain needed

### Trade-off
| Aspect | Multi-node | Single execute_python |
|---|---|---|
| Readability | Native node UI, visual flow | All logic in one code block |
| Debugging | Per-node logs | Single node output |
| Maintainability | Granular steps | Monolithic but functional |
| Variable passing | Broken for execute_python | Direct Python access |

**Decision:** Single action — only viable path given platform constraints.

## Verification
- [x] Multi-node variable interpolation failure documented
- [x] R-PKT-PLATFORM defect identified (`execute_python` param injection)
- [x] HTTP app node limitation noted (only type with `${}` interpolation)
- [x] Single action design confirmed functional
- [x] Trade-off analysis completed

---
*Generated: 2026-08-27T06:20:00Z (UTC) / 2026-08-27T02:20:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
