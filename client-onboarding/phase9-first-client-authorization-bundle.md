# Phase 9 First Client Authorization Bundle

Client-safe. Signed by client before service start.

## 1. Vulnerability scan authorization

- [ ] Scope (mark applicable):
  - [ ] Internal assets (LAN endpoints/servers)
  - [ ] Internet-facing assets (list IPs/domains): ______________
  - [ ] Network appliances - non-invasive only
- [ ] Profile: first scan = safe Discovery (non-invasive); authenticated scans
      only after separate written approval; read-only; off-peak scheduling.
- [ ] Cadence: weekly Discovery for internet-facing; monthly internal (per agreement).
- [ ] Results included in monthly scorecard (client-safe format).

## 2. Canary / deception authorization (optional add-on)

- [ ] OpenCanary honeypot services (fake SSH/HTTP/etc.) on client LAN.
- [ ] Canarytokens (fake credential files / admin URL) - only after MCT T1
      validation completes.
- [ ] No real credentials in any canary artifact; alert-only (no blocking).

## 3. Endpoint monitoring authorization

- [ ] Wazuh agent on approved endpoints (list): ______________
- [ ] Data collected: FIM, syscollector, logs, auth events (no sensitive
      payload capture beyond policy).
- [ ] Alert escalation per matrix; no automated blocking.

## 4. Incident response authorization

- [ ] Manual containment actions require live approval (on-call).
- [ ] Forensic collection (Velociraptor artifacts) per incident runbook.

## Signatures

- Client: ______________  Date: ______________
- MCT SOC: ______________  Date: ______________

## No secrets

No secret values printed.
