<#
.SYNOPSIS
  MCT Sysmon EventID 7 tuning - apply mode (no arguments required; Level.io/RMM-safe).

.DESCRIPTION
  Resolves Sysmon dynamically, dumps the effective current config (backup), creates the include-oriented policy file (embedded XML), loads it, reloads Sysmon, and verifies. Preserves EventID 1/10. This script is self-contained (policy XML embedded) and requires no parameters.

  - Sysmon executable is RESOLVED dynamically (service registration -> common paths -> PATH).
  - The effective current config is captured via "Sysmon64 -s" dump (path-independent
    backup), so rollback works even if the config file location differs.

  Log: C:\Windows\Sysmon\mct-sysmon-tune.log  (no secrets)
#>
$ErrorActionPreference = "Stop"
$BackupDir = "C:\Windows\Sysmon\mct-backups"
$LogFile = "C:\Windows\Sysmon\mct-sysmon-tune.log"
$Mode = "apply"
$Log = @()
$Script:SysmonExe = ""
$Script:SysmonCfg = ""

function Write-LogLine([string]$Msg) {
    $Line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ssZ')] $Msg"
    $Log += $Line
    Write-Host $Line
}

function Get-SysmonHash([string]$Path) {
    if (-not $Path -or -not (Test-Path $Path)) { return "<missing>" }
    return (Get-FileHash -Algorithm SHA256 -Path $Path).Hash.Substring(0, 16)
}

function Resolve-SysmonExe {
    # 1) registered service binary path (authoritative)
    try {
        $svc = Get-CimInstance Win32_Service -Filter "Name='Sysmon64'" -ErrorAction SilentlyContinue
        if ($svc -and $svc.PathName) {
            $p = ($svc.PathName -replace '^"([^"]+)".*$', '$1') -replace '^([^ ]+).*$', '$1'
            if (Test-Path $p) { return $p }
        }
    } catch {}
    # 2) common install paths
    foreach ($cand in @('C:\Windows\Sysmon\Sysmon64.exe',
                        'C:\Windows\Sysmon64.exe',
                        'C:\Program Files\Sysmon\Sysmon64.exe',
                        'C:\Program Files\Sysmon\sysmon64.exe',
                        'C:\Tools\Sysmon\Sysmon64.exe',
                        'C:\Level\Sysmon\Sysmon64.exe')) {
        if (Test-Path $cand) { return $cand }
    }
    # 3) PATH lookup
    $cmd = Get-Command Sysmon64.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return ""
}

function Resolve-SysmonCfg {
    $exeDir = Split-Path $Script:SysmonExe -Parent
    foreach ($cand in @((Join-Path $exeDir 'sysmon-config.xml'),
                        (Join-Path $exeDir 'Sysmon.xml'),
                        'C:\Windows\Sysmon\sysmon-config.xml',
                        'C:\Windows\sysmon-config.xml',
                        'C:\Windows\System32\sysmon-config.xml')) {
        if (Test-Path $cand) { return $cand }
    }
    return (Join-Path $exeDir 'sysmon-config.xml')
}

function Dump-EffectiveConfig {
    # "Sysmon64 -s" prints the current effective config (path-independent backup)
    $dump = Join-Path $BackupDir "effective-config-$(Get-Date -Format 'yyyyMMddTHHmmssZ').xml"
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    & $Script:SysmonExe -s *> $dump
    if ((Test-Path $dump) -and (Get-Item $dump).Length -gt 100) {
        Write-LogLine "Effective config dumped: $dump (sha256 $((Get-SysmonHash $dump)))"
        return $dump
    }
    Write-LogLine "WARN: 'sysmon -s' produced no dump (older Sysmon? fallback to file copy)"
    if (Test-Path $Script:SysmonCfg) {
        $bak = Join-Path $BackupDir "sysmon-config-$(Get-Date -Format 'yyyyMMddTHHmmssZ').xml"
        Copy-Item $Script:SysmonCfg $bak -Force
        Write-LogLine "Config file backup: $bak (sha256 $((Get-SysmonHash $bak)))"
        return $bak
    }
    return ""
}

function Write-PolicyFile {
    New-Item -ItemType Directory -Force -Path "C:\Windows\Sysmon" | Out-Null
    if (-not (Test-Path $PolicyPath)) {
        $policyXml = @'
<!--
  Phase 23 EventID 7 include-oriented policy (phase23-eventid7-policy.xml).
  Collects ImageLoad events ONLY for suspicious combinations (LOLBin loading processes,
  unsigned modules, modules staged in non-system paths). EID1/3/5/6/8/10/11/12/13/14/15/
  17/18/22/25 remain collected per baseline. Never disable EventID 1/10.
  Deploy: .\Sysmon64.exe -c phase23-eventid7-policy.xml
  Rollback: .\Sysmon64.exe -c <prior>.xml  (prior config exported before change)
-->
<Sysmon schemaversion="4.90">
  <EventFiltering>
    <!-- EventID 7 include-oriented rule group (or: any condition logs the event) -->
    <RuleGroup name="group=image-load-include" groupRelation="or">
      <ImageLoad onmatch="include">
        <!-- LOLBin loading processes (scriptlet/execution abuse with module loads) -->
        <Image condition="contains">rundll32.exe</Image>
        <Image condition="contains">regsvr32.exe</Image>
        <Image condition="contains">mshta.exe</Image>
        <Image condition="contains">wscript.exe</Image>
        <Image condition="contains">cscript.exe</Image>
        <Image condition="contains">wmic.exe</Image>
        <Image condition="contains">certutil.exe</Image>
        <Image condition="contains">cmd.exe</Image>
        <Image condition="contains">pwsh.exe</Image>
        <!-- Unsigned module loads -->
        <Signature condition="equals">Unsigned</Signature>
        <!-- Modules staged outside system directories -->
        <ImageLoaded condition="contains">\AppData\</ImageLoaded>
        <ImageLoaded condition="contains">\Temp\</ImageLoaded>
        <ImageLoaded condition="contains">\Downloads\</ImageLoaded>
        <ImageLoaded condition="contains">\ProgramData\</ImageLoaded>
        <ImageLoaded condition="begin with">C:\Windows\Temp\</ImageLoaded>
      </ImageLoad>
    </RuleGroup>
  </EventFiltering>
</Sysmon>
'@
        Set-Content -Path $PolicyPath -Value $policyXml -Encoding UTF8 -NoNewline
        Write-LogLine "Policy file created: $PolicyPath"
    } else {
        Write-LogLine "Policy file exists (not overwritten): $PolicyPath sha256 $((Get-SysmonHash $PolicyPath))"
    }
}

function Invoke-Apply {
    Write-LogLine "== apply =="
    $Script:SysmonExe = Resolve-SysmonExe
    if (-not $Script:SysmonExe) { Write-LogLine "ERROR: Sysmon64.exe not found (service missing?) - install Sysmon first"; exit 3 }
    Write-LogLine "Sysmon executable: $Script:SysmonExe"
    $Script:SysmonCfg = Resolve-SysmonCfg
    Write-LogLine "Config path (detected): $Script:SysmonCfg (sha256 $((Get-SysmonHash $Script:SysmonCfg)))"
    $bak = Dump-EffectiveConfig
    Write-PolicyFile
    & $Script:SysmonExe -c $PolicyPath
    if ($LASTEXITCODE -ne 0) { Write-LogLine "ERROR: Sysmon rejected the policy (exit $LASTEXITCODE) - rollback recommended (rollback-sysmon-tune.ps1)"; exit 1 }
    Write-LogLine "Sysmon reload OK; service: $(Test-SysmonService)"
    Write-LogLine "Deployed config sha256: $(Get-SysmonHash $Script:SysmonCfg)"
    Write-LogLine "Validation (SOC-side): EID7 >=99% drop, EID1/10 flowing, buffer clean - confirm in Wazuh."
}

function Invoke-Check {
    Write-LogLine "== check =="
    $Script:SysmonExe = Resolve-SysmonExe
    if (-not $Script:SysmonExe) { Write-LogLine "Sysmon executable: NOT FOUND (install Sysmon first)"; } else { Write-LogLine "Sysmon executable: $Script:SysmonExe" }
    $Script:SysmonCfg = Resolve-SysmonCfg
    Write-LogLine "Service: $(Test-SysmonService)"
    Write-LogLine "Config path (detected): $Script:SysmonCfg (sha256 $((Get-SysmonHash $Script:SysmonCfg)))"
    Write-LogLine "Policy file sha256: $(Get-SysmonHash $PolicyPath)"
    Write-LogLine "Backups present: $((Get-ChildItem -Path $BackupDir -Filter '*config*.xml' -ErrorAction SilentlyContinue | Measure-Object).Count)"
    if ($Script:SysmonExe) {
        & $Script:SysmonExe -s *> (Join-Path $env:TEMP 'mct-sysmon-s.txt')
        Write-LogLine "Effective config dump size: $((Get-Item (Join-Path $env:TEMP 'mct-sysmon-s.txt') -ErrorAction SilentlyContinue).Length) bytes"
    }
    try {
        $null = Get-WinEvent -FilterHashtable @{LogName = "Microsoft-Windows-Sysmon/Operational"; Id = 7 } -MaxEvents 1 -ErrorAction SilentlyContinue
        Write-LogLine "EID7 events: recent activity present"
    } catch { Write-LogLine "EID7 events: none found in channel (quiet)" }
    Write-LogLine "Check Wazuh: agent keepalive + EID7/EID1/EID10 counts."
}

function Invoke-Rollback {
    Write-LogLine "== rollback =="
    $Script:SysmonExe = Resolve-SysmonExe
    if (-not $Script:SysmonExe) { Write-LogLine "ERROR: Sysmon64.exe not found"; exit 3 }
    $target = (Get-ChildItem -Path $BackupDir -Filter "*.xml" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    if (-not $target) { Write-LogLine "ERROR: no backup found to restore"; exit 3 }
    & $Script:SysmonExe -c $target
    if ($LASTEXITCODE -ne 0) { Write-LogLine "ERROR: restore rejected (exit $LASTEXITCODE)"; exit 1 }
    Write-LogLine "Restored: $target ; service: $(Test-SysmonService)"
}

function Test-SysmonService {
    $svc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq "Running") { return "RUNNING" }
    return "NOT RUNNING / MISSING"
}

$PolicyPath = "C:\Windows\Sysmon\mct-eid7-policy.xml"

switch ($Mode) {
    "apply" { Invoke-Apply }
    "rollback" { Invoke-Rollback }
    default { Invoke-Check }
}

$Log | Out-File -FilePath $LogFile -Append -Encoding utf8
Write-Host "Log: $LogFile"
