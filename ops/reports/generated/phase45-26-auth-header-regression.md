# Phase 45: Authorization Header Regression Test

## Objective
Prove runtime Authorization header is structurally valid with no placeholder/newline/CR artifacts.

## Test Method
Use Shuffle's execution logging or add debug print to capture rendered header (without printing value).

## Test Cases

### 1. Header Structure Validation
```python
# In execute_python (temporary debug)
import re
headers = self.action.get('parameters', {}).find(lambda p: p['name'] == 'headers')['value']
print(f"HEADER_STRUCTURE: {{
    'has_bearer': 'Bearer' in headers,
    'has_newline': '\\n' in headers,
    'has_cr': '\\r' in headers,
    'has_placeholder': '[REDACTED' in headers,
    'line_count': len(headers.split('\\n')),
    'starts_with_bearer': headers.strip().startswith('Bearer'),
    'template_syntax': '{{IRIS_API_TOKEN}}' in headers
}}")
```

### 2. Expected Results
| Check | Valid | Invalid |
|-------|-------|---------|
| Contains `Bearer` | ✅ | ❌ |
| No newline (`\n`) | ✅ | ❌ |
| No carriage return (`\r`) | ✅ | ❌ |
| No `[REDACTED` placeholder | ✅ | ❌ |
| Single line | ✅ | ❌ |
| Uses `{{IRIS_API_TOKEN}}` template | ✅ | ❌ |

### 3. Runtime Verification
```bash
# Execute workflow and check logs
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execute" \
  -H "Authorization: Bearer $NT" \
  -H "Content-Type: application/json" \
  -d '{"data": "{\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.1\",\"dest_ip\":\"192.168.1.10\",\"dest_port\":443,\"proto\":\"TCP\"}}"}'

# Check execution logs for HEADER_STRUCTURE print
```

### 3. IRIS Request Validation
```bash
# On IRIS side (if accessible)
# Check nginx access log for Authorization header format
# Should see: "Authorization: Bearer <valid-token>" (single line, no artifacts)
```

## Regression Test Matrix

| Scenario | Header Rendered | Expected |
|----------|-----------------|----------|
| Auth object exists | `Authorization: Bearer <token>` | PASS |
| Auth object missing | `Authorization: Bearer ` (empty) | FAIL (but no placeholder) |
| Template syntax error | `Authorization: Bearer {{IRIS_API_TOKEN}}` (literal) | FAIL |
| Old placeholder | `Authorization: Bearer [REDACTED-IRIS-TOKEN]` | FAIL |

## Automated Regression Check
```python
def validate_auth_header(headers_str):
    errors = []
    if '\n' in headers_str:
        errors.append("NEWLINE_IN_HEADER")
    if '\r' in headers_str:
        errors.append("CARRIAGE_RETURN_IN_HEADER")
    if '[REDACTED' in headers_str:
        errors.append("PLACEHOLDER_IN_HEADER")
    if '{{IRIS_API_TOKEN}}' not in headers_str and 'Bearer' in headers_str:
        errors.append("NO_TEMPLATE_SYNTAX")
    if headers_str.count('\n') > 1:
        errors.append("MULTILINE_HEADER")
    return errors

# Run on every workflow execution
assert validate_auth_header(rendered_headers) == []
```

## Evidence Collection
- [ ] Header structure test executed
- [ ] No newline/CR artifacts
- [ ] No placeholder artifacts
- [ ] Template syntax present
- [ ] Single line header
- [ ] IRIS request succeeds (HTTP 200/201)

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Engineer | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T03:51:00Z (UTC) / 2026-08-26T23:51:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after auth object creation (Phase 45-25)*
