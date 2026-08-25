# Phase 37 — Shuffle Threat Model

**Date:** 2026-08-25T19:28Z  
**Component:** Shuffle SOAR (frontend + backend)

---

## Identified Risks

### R1: Plaintext HTTP on All Interfaces

| Attribute | Value |
|-----------|-------|
| Severity | HIGH |
| Vector | Frontend binds 0.0.0.0:3001 over plain HTTP |
| Impact | Credentials, session tokens, and alert data transmitted in cleartext |
| Likelihood | High (network sniffing, man-in-the-middle) |

### R2: Admin Access from Any Source

| Attribute | Value |
|-----------|-------|
| Severity | HIGH |
| Vector | No IP restrictions, no firewall rules on port 3001 |
| Impact | Any host with network access can reach login page and attempt authentication |
| Likelihood | High (broad attack surface) |

### R3: No TLS

| Attribute | Value |
|-----------|-------|
| Severity | HIGH |
| Vector | No TLS certificate, no HTTPS |
| Impact | All traffic (including auth) interceptable |
| Likelihood | High |

### R4: No Brute Force Protection

| Attribute | Value |
|-----------|-------|
| Severity | MEDIUM |
| Vector | No rate limiting, no account lockout, no CAPTCHA |
| Impact | Automated password attacks possible |
| Likelihood | Medium |

### R5: Session Token in Cookie

| Attribute | Value |
|-----------|-------|
| Severity | MEDIUM |
| Vector | Session token stored in HTTP cookie without Secure/HttpOnly flags guaranteed |
| Impact | Session hijacking via XSS or network interception |
| Likelihood | Medium |

### R6: Lateral Movement to IRIS via Workflow

| Attribute | Value |
|-----------|-------|
| Severity | MEDIUM |
| Vector | Workflow actions include HTTP POST to IRIS API |
| Impact | Compromised Shuffle can relay actions to IRIS (case management) |
| Likelihood | Low-Medium (requires Shuffle compromise first) |

---

## Ranked Mitigations

| Rank | Mitigation | Addresses | Effort |
|------|-----------|-----------|--------|
| 1 | Apply iptables to restrict port 3001 to 127.0.0.1; operator uses SSH tunnel | R1, R2, R3 | Low |
| 2 | Deploy TLS reverse proxy (nginx/Caddy) with valid certificate | R1, R3 | Medium |
| 3 | Enforce strong password policy on Shuffle admin accounts | R4, R5 | Low |
| 4 | Add rate limiting on login endpoint (fail2ban or nginx) | R4 | Low-Medium |
| 5 | Network segmentation — isolate Shuffle in dedicated VLAN | R2, R6 | High |

---

## Recommendation

Apply mitigation 1 (iptables lockdown) immediately pending operator approval. Defer mitigations 2–5 to Phase 38+.

---

## No secrets
