# Phase 21 EventID 7 Tuning Plan (agent 014)

Date: 2026-08-19
Status: PLAN - apply approval-gated + endpoint-access dependent.

## Objective

Stop the ~574K docs/24h EventID 7 (Image Loaded) archive flood from 014 while preserving
image-load detection for non-standard processes, and keeping EventID 1 / 10 intact.

## Targeted excludes (EventID 7) - known-safe process paths

Add to the Sysmon config `ImageLoad` rule group, `onmatch="exclude"`:

```xml
<ImageLoad onmatch="exclude">
  <Image condition="is">C:\Windows\System32\conhost.exe</Image>
  <Image condition="is">C:\Program Files\Docker\Docker\resources\bin\docker.exe</Image>
  <Image condition="is">C:\Program Files\Level\osqueryi.exe</Image>
  <Image condition="is">C:\Program Files\Level\level.exe</Image>
  <Image condition="is">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Image>
  <Image condition="is">C:\Windows\System32\backgroundTaskHost.exe</Image>
  <Image condition="is">C:\Windows\System32\wbem\WmiPrvSE.exe</Image>
  <Image condition="is">C:\Windows\System32\RuntimeBroker.exe</Image>
  <Image condition="is">C:\Windows\System32\taskhostw.exe</Image>
  <Image condition="is">C:\Windows\System32\wermgr.exe</Image>
  <Image condition="is">C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe</Image>
  <Image condition="is">C:\Users\Admin\AppData\Local\Programs\Microsoft VS Code\Code.exe</Image>
  <Image condition="begin with">C:\Program Files (x86)\Google\GoogleUpdater\</Image>
  <Image condition="begin with">C:\Windows\WinSxS\</Image>
  <Image condition="begin with">C:\Windows\UUS\</Image>
  <Image condition="begin with">C:\Windows\SystemApps\</Image>
</ImageLoad>
```

This excludes the measured top sources (conhost, docker, osqueryi, powershell = ~89% of flood)
plus standard system paths. All other ImageLoad events continue to flow.

## Preserved events

| EventID | Purpose | Status |
|---|---|---|
| 1 | Process Create | preserved (15,186/24h) |
| 10 | ProcessAccess | preserved (1,499/24h) |
| 7 (other processes) | Image Loaded detection | preserved for non-excluded paths |

## Security tradeoff (documented)

- Excluding ImageLoad for these specific, verified-known paths loses image-load telemetry for
  those binaries only. conhost/docker/osqueryi/powershell image loads are routine and
  low-value; detection value for suspicious DLL loads in other processes is retained.
- Tradeoff justified by the ~1.6M docs/day storage/signal cost of the untuned flood.
- Rollback: reload prior config (`sysmon -c <old>.xml` or `sysmon -u`).

## No secrets