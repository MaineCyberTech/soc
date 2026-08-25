# Phase 36: Shuffle Auth Failure

Date: 2026-08-25

## Symptom
- Login with username "admin" fails: "Found 0 (0) user(s)"
- Login with "soc@mainecybertech.com": found 1 user but password incorrect
- API Bearer token auth WORKS

## Root cause
- User "soc@mainecybertech.com" exists but username != "admin"
- SHUFFLE_ADMIN_USERNAME=admin env var doesn't match actual user
- Password for soc@mainecybertech.com unknown/forgotten

## Workaround
- Bearer token API access works: 0c953f60-5cca-45b2-95f3-27373f4921ca
- Session cookie works: dafcb7df-20a2-496f-a92e-33ef23e429b7

## Resolution
- Workflow CRUD can proceed via API
- Webhook trigger setup requires UI login (password reset needed)
- **Deferred to operator**: reset password via Shuffle UI or recreate admin user

## No secrets
