# Phase 45: Canonical Workflow Artifact Layout

## Repository Structure
```
integrations/shuffle/workflows/suricata-packet-routing/
├── workflow.json                 # Exported workflow (sanitized, no secrets)
├── manifest.json                 # Version, dependencies, compatibility
├── README.md                     # Purpose, usage, configuration
├── tests/
│   ├── test_normal_event.json    # Normal event (SID 2027967)
│   ├── test_repeat_event.json    # Repeat event (same 5-tuple)
│   ├── test_nonallowlisted.json  # Non-allowlisted SID (999999)
│   ├── test_synthetic.json       # Synthetic event (MCT_SYNTHETIC=true)
│   ├── test_malformed.json       # Malformed event (missing fields)
│   └── test_hook_probe.json      # Live hook input probe
├── expected/
│   ├── routed.json               # Expected routed result
│   ├── duplicate.json            # Expected duplicate result
│   ├── not_allowed.json          # Expected not_allowed result
│   ├── synthetic.json            # Expected synthetic result
│   ├── malformed.json            # Expected malformed result
│   └── target_fail.json          # Expected target_fail result
├── rollback/
│   └── previous_version.json     # Previous workflow version for rollback
├── changelog/
│   └── CHANGELOG.md              # Version history
└── hashes/
    └── SHA256SUMS                # File integrity verification
```

## File Specifications

### workflow.json
- **Source:** Exported from Shuffle API (sanitized)
- **Secrets:** ALL secrets replaced with `[SECRET_REF]` placeholders
- **Auth References:** IRIS token → `{{IRIS_API_TOKEN}}` (Shuffle auth object reference)
- **Hash:** SHA256 recorded in `hashes/SHA256SUMS`

### manifest.json
```json
{
  "name": "suricata-packet-routing",
  "version": "1.0.0",
  "description": "Suricata EVE JSON packet routing to DFIR-IRIS with dedup, allowlist, synthetic isolation",
  "shuffle_version": ">= 1.0.0",
  "dependencies": [
    "shuffle-tools:1.2.0",
    "http:1.4.0"
  ],
  "auth_references": {
    "iris_api_token": {
      "type": "shuffle_auth_object",
      "name": "IRIS_API_TOKEN",
      "description": "DFIR-IRIS API token for alert creation"
    }
  },
  "trigger": {
    "type": "webhook",
    "custom_url": "p39-suricata-test",
    "description": "Suricata EVE JSON webhook endpoint"
  },
  "actions": {
    "parse-eve-json": "execute_python - parse webhook payload",
    "route-logic": "inline logic - validate, synthetic, allowlist, dedup, counter, IRIS"
  },
  "states": [
    "routed",
    "duplicate",
    "not_allowed",
    "synthetic",
    "malformed",
    "target_fail"
  ]
}
```

### README.md
- Purpose and architecture
- Configuration (IRIS auth object, webhook URL)
- Deployment steps (import workflow, create auth object, start trigger)
- Test procedures
- Troubleshooting

### Tests
Each test file contains the exact webhook payload for execute API or live hook.

### Expected Results
Each expected file contains the JSON result structure for verification.

### Rollback
Previous workflow version for immediate rollback capability.

### Changelog
Version history with dates, changes, and hashes.

### Hashes
SHA256SUMS for all files in the directory.

## Deployment Process
1. Create Shuffle auth object `IRIS_API_TOKEN` with IRIS API token
2. Import `workflow.json` via Shuffle UI or API
3. Update workflow auth reference to `{{IRIS_API_TOKEN}}`
4. Start trigger via Shuffle UI
5. Run test suite via execute API
6. Validate live hook with test_hook_probe.json
7. Record results

## Hash Verification
```bash
cd integrations/shuffle/workflows/suricata-packet-routing
sha256sum -c hashes/SHA256SUMS
```

---
*Generated: 2026-08-27T03:38:00Z (UTC) / 2026-08-26T23:38:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
