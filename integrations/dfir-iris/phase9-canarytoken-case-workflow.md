# Canarytoken Case Workflow (DFIR-IRIS) - Phase 9

## Trigger sources

1. **OpenCanary VM (canary01)**: syslog -> Wazuh rule 121000/121007/121014 (lvl 12) -> indexer -> (Shuffle alert) -> IRIS
2. **Hosted canarytokens (T1)**: token hit -> webhook -> Shuffle execution -> IRIS

## Validated paths (Phase 9)

- OpenCanary -> Wazuh -> rule 121007 lvl 12: **VALIDATED 2026-08-15 20:04** (node_id opencanary-mct-canary01)
- Shuffle webhook ingestion: **VALIDATED 2026-08-15 20:43** (success:true, execution b24d020d)
- IRIS case creation: validated in Phase 8 (canary case workflow) - IRIS healthy (8443)

## IRIS case template (from integrations/opencanary/iris-case-template.md)

- Name: Canarytokens / OpenCanary hit - <node_id> - <date>
- Severity: depends on token type (info for T1 doc token; high for credential tokens)
- Tags: deception, canarytoken, opencanary, <source>
- Initial evidence: token memo, src/dst, logtype, webhook payload
- Workflow: triage -> containment (remove artifact) -> root cause -> close

## When T1 is deployed (post-account)

1. Touch token -> Shuffle executes -> verify execution log + IRIS case.
2. Save execution_id + case id in this doc.
3. Mark phase9-canarytoken-t1-validation.md validated.

## No secrets

No secret values printed.
