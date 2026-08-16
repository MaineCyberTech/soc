# Windows Evidence to IRIS (Phase 9)

## Trigger

- Velociraptor hunt on MCT-WIN11PILOT (or any enrolled client) completes with
  findings requiring triage.

## Evidence export

```text
# via API (velociraptor CLI with api_config):
# 1) get flow_id for the client
SELECT * FROM flows(client_id='C.d0d09f675bd30e12')
# 2) retrieve results
SELECT * FROM flow_results(client_id='C.d0d09f675bd30e12', flow_id='F.DA0DKGEQGT4GS', artifact='Generic.Client.Info/BasicInformation')
# 3) export a collection zip (when needed for IRIS attachment):
SELECT * FROM create_flow_download(client_id='C.d0d09f675bd30e12', flow_id='F.DA0DKGEQGT4GS', wait=True)
```

## IRIS case workflow

1. Create IRIS case (template: integrations/dfir-iris/canary-case-template.md or
   DFIR-IRIS standard).
2. Add evidence: hunt results CSV/JSON, flow zip, client info snapshot.
3. Tag: velociraptor, windows, <artifact-name>.
4. Triage notes: what the hunt found (users, network, processes), correlation
   with Wazuh alerts (agent 012) and Sysmon events.
5. Containment/actions per incident-triage runbook.
6. Close with evidence references.

## Reusable

- The Generic.Client.Info flow result format is stable - reuse for routine
  endpoint evidence capture on client onboarding.

## No secrets

No secret values printed.
