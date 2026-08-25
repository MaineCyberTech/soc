# Phase 32 Production Routing (SID-specific)

Date: 2026-08-25
- Production routing enables only curated, volume-gated SIDs (e.g., 2027967-class malware/C2)
  via a dedicated Wazuh rule set; dedup + rate-limit via guardrail; reversible.
- Gate: observe + canary + FP review PASS before production. Current: observe-only (no
  production routing yet - per safety).

## No secrets
