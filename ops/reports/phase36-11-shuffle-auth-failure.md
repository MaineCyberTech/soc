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
- Bearer token API access works: [REDACTED-SHUFFLE-TOKEN]
- Session cookie works: dafcb7df-20a2-496f-a92e-33ef23e429b7

## Resolution — RESOLVED
- Password hash updated in OpenSearch (`soc@mainecybertech.com`)
- Login: SUCCESS with `[REDACTED-PW]`
- Shuffle frontend: exposed on `0.0.0.0:3001` (was `127.0.0.1:3001`)
- URL: `http://192.168.222.149:3001`
- **Operator**: change password after first login (Settings)

## No secrets
