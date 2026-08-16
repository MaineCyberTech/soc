# Client Group Naming Standard (level.io + Wazuh)

## Convention

- Wazuh agent group: `client-<slug>` (e.g. client-north-parish)
- level.io device group: `<slug>-clients` (e.g. north-parish-clients)
- OS split inside client: append -win / -mac / -linux if needed

## Mapping

| Client | Wazuh group | level.io group | Scorecard |
|---|---|---|---|
| <client> | client-<slug> | <slug>-clients | <slug>-scorecard |

## Rules

- Groups created BEFORE first agent deploy.
- Sysmon collection config only on -win groups.
- Escalation + reporting vars per client.

## Note (2026-08-15)

- client-pilot group reserved for first external client.
