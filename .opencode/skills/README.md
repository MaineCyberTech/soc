# Agent skills

Curated infrastructure profile from
[`MaineCyberTech/albatross`](https://github.com/MaineCyberTech/albatross).
Update via the canonical source:

```sh
scripts/sync-skills.sh /path/to/soc infra-lite
```

Installed profile: `infra-lite` (mct-ops, systematic-debugging,
verification-before-completion, secrets-management,
auth-implementation-patterns, deployment-pipeline-design).

This repository also carries the security/compliance skills
`security-audit-example`, `sast-configuration` and
`compliance-architecture` from the same source. After the profile sync, copy
those three directories into `.opencode/skills/` as well.

Do not edit these copies directly. Never put secrets, credentials, service
keys, tokens or customer data in a skill; runtime secrets belong in Vault or
root-only files under `/etc/kestrel/`.
