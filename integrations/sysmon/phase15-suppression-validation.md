# Phase 15 Suppression Validation

Date: 2026-08-16

## Goal

Prove (a) legit-system VaultCli/Lsass events are suppressed, and (b) malicious
variants still alert.

## Method A: passive (natural events) - PRIMARY

- Wait for next VaultCli/Lsass event on agents 012/013 (when devices active).
- Verify: no 92153/92900 alert generated (event lands in archives without the
  rule or with suppression rule).
- Verify: non-listed image (e.g. C:\Temp\evil.exe loading vaultcli) STILL fires
  92153 - monitor archives for any such event.

## Method B: controlled (operator-assisted) - OPTIONAL

With operator approval on the client/pilot workstation:

```powershell
# Legit-path test (should NOT alert):
#   - any normal app in System32/Program Files loads vaultcli (already happens naturally)

# Malicious-variant test (SHOULD alert):
Copy-Item C:\Windows\System32\vaultcli.dll C:\Temp\evil-loader-test.dll
# then a test process from C:\Temp loads it - requires controlled trigger;
# run ONLY with operator approval.
```

## Acceptance

1. 7-day window: < 10 level>=9/day (agents 012+013).
2. One controlled malicious-variant test (optional) confirms 92153 still fires
   for non-listed paths.

## Status

- Window open (P15.12). Passive validation pending events.

## No secrets
