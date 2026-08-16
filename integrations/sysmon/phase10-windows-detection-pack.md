# Phase 10 Windows Detection Pack (Backlog)

Date: 2026-08-15
Source: pilot telemetry (agent 012, Sysmon 24k events/day)
Status: BACKLOG - not deployed until measured (no noisy rules prematurely).

## Detection categories

### 1. Process creation (Sysmon EID 1)

| # | Detection | Query/condition | Priority |
|---|---|---|---|
| D1 | Suspicious LOLBin execution | image in (powershell, wscript, mshta, regsvr32, rundll32, certutil, bitsadmin) with non-standard parent | HIGH |
| D2 | Encoded PowerShell | EID 1 image=powershell + cmdline contains -enc/-e | HIGH |
| D3 | Process from temp/weird path | image matches ^C:\\(Users\|Temp\|Windows\\Temp\|ProgramData) | MEDIUM |
| D4 | Rundll32 launching scriptlet | image=rundll32, cmdline contains .sct|.jse|javascript | HIGH |

### 2. PowerShell script block logging (EID 4104 - NOT yet enabled)

| # | Detection | Condition | Priority |
|---|---|---|---|
| D5 | PS script block with obfuscation | script contains Base64/enc/IEX patterns | HIGH |
| D6 | PS downloading payloads | script contains Invoke-WebRequest/Net.WebClient | HIGH |

### 3. Service creation (Sysmon EID 6 / System 7045)

| # | Detection | Condition | Priority |
|---|---|---|---|
| D7 | New service with binary in temp | service image path ^C:\\(Temp\|Users\\Public\|ProgramData) | HIGH |
| D8 | Service creation by non-SYSTEM | 7045 with low-integrity subject | MEDIUM |

### 4. Scheduled tasks (Security 4698 / Sysmon)

| # | Detection | Condition | Priority |
|---|---|---|---|
| D9 | Scheduled task with encoded cmd | task command contains -enc/echo\|base64 | HIGH |

### 5. Defender exclusion changes (Security 4657 / registry)

| # | Detection | Condition | Priority |
|---|---|---|---|
| D10 | Defender exclusion added | registry path contains Windows Defender\Exclusions | HIGH |

### 6. Network connections by process (Sysmon EID 3)

| # | Detection | Condition | Priority |
|---|---|---|---|
| D11 | Outbound connection from LOLBin | process in LOLBin list, remote port 443/80/53, frequent | MEDIUM |
| D12 | Connection to known-bad | EID 3 dst_ip in threat feed | HIGH (needs feed) |

## Deployment rules

- Add to pilot first (agent 012), measure volume 7 days, then promote to
  windows-clients group.
- No rule deployed without volume measurement (safety).
- Rule levels: D1/D2/D4/D7/D10/D12 = 10-12; others = 6-8.

## No secrets

No secret values printed.
