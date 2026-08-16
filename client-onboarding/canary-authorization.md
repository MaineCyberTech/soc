# Canary Authorization

Required before deploying deception (canaries/Canarytokens) at a client site.

## What is a canary

A fake service/file/credential that looks like a real target. If an attacker
(or curious user) touches it, MCT is alerted immediately. Canaries never contain
real data or real credentials.

## Purpose

- Early detection of unauthorized network access.
- Credential-reuse detection (fake credentials).
- Evidence for incident response.

## Placement (with authorization)

- [ ] Canary VM/host on the client LAN segment (services: fake SSH/SMB/RDP/DB/web admin)
- [ ] Canarytokens (fake credentials files, fake admin URL, fake VPN config)
- [ ] Tokens placed where attackers plausibly look; recorded in inventory

## Client acknowledgment

- [ ] I understand canaries generate alerts when touched.
- [ ] I understand canaries contain no real data/credentials.
- [ ] I agree to tell staff not to open/use canary files.
- [ ] I authorize placement per the documented inventory.

## Safety

- Canaries do NOT block, quarantine, or disrupt any traffic - alert only.
- Canary artifacts never contain real passwords/keys.
- Canaries are monitored 24/7 with Class A alerting.

## Signatures

Client: __________________  Date: __________
MCT: __________________  Date: __________
