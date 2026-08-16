# MCT Security Stack - Release Notes

## Release 20260816-014828 (Phase 12)

### Contents

- Portable repo docs: README, REPO-MAP, ARCHITECTURE, PORTS, PORTABILITY, SECURITY
- Config: .env.example, .gitignore, .gitignore.example, config/examples (incl. secrets.example.env - placeholders only)
- Scripts: bootstrap (3), verify (6), CI (run-local-ci, build-release-bundle), endpoint-deploy (no client.config.yaml - excluded)
- Compose: dfir-iris, greenbone, misp, opencanary, shuffle, velociraptor, phase2 (archived)
- Integrations: dfir-iris, greenbone, misp, opencanary, shuffle, velociraptor, wazuh, flow, payload-contracts
- Ops: runbooks, scripts, checklists, cron, reports (full history, no backups)
- Reporting: generators, output, queries, templates
- Client-onboarding: intake, authorization, templates, communication playbook
- Service-packaging: offers, billing review
- Evidence: historical reports archive (122 reports, banners)

### Excluded (safety)

- .git, ops/backups (2.6G), data/ (77M)
- .env, creds.env, client.config.yaml (live Velociraptor keys)
- *.key, *.pem, *.sql.gz, *.tar.gz, *.zip, *.pcap, *.evtx
- shuffle-periodic-repair.log (operational log)

### Verification

- sha256: 8d4dc40291a6d1906540bf774da4b44f8380a3050050273bda10a89c2b45ca7d
- Sensitive-file scan: 0 leaks
- Local CI: PASS (61 sh bash -n, 245 py compile, 4 verify scripts)

### Usage

```bash
tar xzf mct-security-stack-release-20260816-014828.tar.gz
cd mct-security-stack-release-20260816-014828  # or git checkout from mainecybertech/soc
# See README.md and PORTABILITY.md for deployment guidance
```

### Upstream

- Repository: git@github.com:mainecybertech/soc.git (pending operator approval for first push)
