# Workflow: misp-ioc-enrichment

- Mode: notify-only
- Trigger: called from other workflows (sub-flow) or manual run per case
- Payload: observable (ip/domain/hash)

## Steps

1. GET MISP `/attributes/restSearch` for the observable (tags source:wazuh etc. optional).
2. Map result to confidence + action tags.
3. Return: `{matched: true/false, confidence, action, event_id, tags[]}` to caller.
4. Caller updates IRIS case tags.

## Failure modes

- MISP timeout -> return `matched:false, error:"misp-unavailable"`; case marked unverified.

## Acceptance

- Enrichment of a known test IOC returns matched:true with expected tags.
