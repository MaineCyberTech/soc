<#
.SYNOPSIS
  MCT Sysmon EventID 7 tuning - rollback mode (no arguments required; Level.io/RMM-safe).

.DESCRIPTION
  Restores the newest timestamped backup of sysmon-config.xml and reloads Sysmon. This script is self-contained (policy XML embedded) and requires no parameters -
  intended for runners like Level.io that execute scripts without arguments.

  Log: C:\Windows\Sysmon\mct-sysmon-tune.log  (no secrets)
#>
$ErrorActionPreference = "Stop"
$SysmonExe = "C:\Windows\Sysmon\Sysmon64.exe"
$SysmonCfg = "C:\Windows\Sysmon\sysmon-config.xml"
$PolicyPath = "C:\Windows\Sysmon\mct-eid7-policy.xml"
$BackupDir = "C:\Windows\Sysmon\mct-backups"
$LogFile = "C:\Windows\Sysmon\mct-sysmon-tune.log"
$Mode = "rollback"
$Log = @()

function Write-LogLine([string]$Msg) {
    $Line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ssZ')] $Msg"
    $Log += $Line
    Write-Host $Line
}

function Get-SysmonHash([string]$Path) {
    if (-not (Test-Path $Path)) { return "<missing>" }
    return (Get-FileHash -Algorithm SHA256 -Path $Path).Hash.Substring(0, 16)
}

function Test-SysmonService {
    $svc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq "Running") { return "RUNNING" }
    return "NOT RUNNING / MISSING"
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

function Backup-CurrentConfig {
    if (-not (Test-Path $SysmonCfg)) { Write-LogLine "WARN: no deployed config at $SysmonCfg - nothing to back up"; return "" }
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $ts = Get-Date -Format "yyyyMMddTHHmmssZ"
    $bak = Join-Path $BackupDir "sysmon-config.$ts.xml"
    Copy-Item -Path $SysmonCfg -Destination $bak -Force
    Write-LogLine "Backup written: $bak (sha256 $((Get-SysmonHash $bak)))"
    return $bak
}

function Invoke-Apply {
    Write-LogLine "== apply =="
    Write-PolicyFile
    Write-LogLine "Current deployed config sha256: $(Get-SysmonHash $SysmonCfg)"
    $bak = Backup-CurrentConfig
    Copy-Item -Path $PolicyPath -Destination $SysmonCfg -Force
    Write-LogLine "Loaded include-oriented policy -> $SysmonCfg"
    & $SysmonExe -c $SysmonCfg
    if ($LASTEXITCODE -ne 0) {
        Write-LogLine "ERROR: Sysmon rejected the config (exit $LASTEXITCODE) - rollback recommended (use rollback-sysmon-tune.ps1)"
        exit 1
    }
    Write-LogLine "Sysmon reload OK; service: $(Test-SysmonService)"
    Write-LogLine "New deployed config sha256: $(Get-SysmonHash $SysmonCfg)"
    Write-LogLine "Validation (SOC-side): EID7 >=99% drop, EID1/10 flowing, buffer clean - confirm in Wazuh."
}

function Invoke-Check {
    Write-LogLine "== check =="
    Write-LogLine "Sysmon service: $(Test-SysmonService)"
    Write-LogLine "Policy file sha256: $(Get-SysmonHash $PolicyPath)"
    Write-LogLine "Deployed config sha256: $(Get-SysmonHash $SysmonCfg)"
    Write-LogLine "Backups present: $((Get-ChildItem -Path $BackupDir -Filter 'sysmon-config.*.xml' -ErrorAction SilentlyContinue | Measure-Object).Count)"
    try {
        $null = Get-WinEvent -FilterHashtable @{LogName = "Microsoft-Windows-Sysmon/Operational"; Id = 7 } -MaxEvents 1 -ErrorAction SilentlyContinue
        Write-LogLine "EID7 events: recent activity present"
    } catch { Write-LogLine "EID7 events: none found in channel (quiet)" }
    Write-LogLine "Check Wazuh: agent keepalive + EID7/EID1/EID10 counts."
}

function Invoke-Rollback {
    Write-LogLine "== rollback =="
    $target = (Get-ChildItem -Path $BackupDir -Filter "sysmon-config.*.xml" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    if (-not $target) { Write-LogLine "ERROR: no backup found to restore"; exit 3 }
    Copy-Item -Path $target -Destination $SysmonCfg -Force
    Write-LogLine "Restored $target"
    & $SysmonExe -c $SysmonCfg
    if ($LASTEXITCODE -ne 0) { Write-LogLine "ERROR: rollback config rejected (exit $LASTEXITCODE)"; exit 1 }
    Write-LogLine "Rollback OK; service: $(Test-SysmonService)"
}

switch ($Mode) {
    "apply" { Invoke-Apply }
    "rollback" { Invoke-Rollback }
    default { Invoke-Check }
}

$Log | Out-File -FilePath $LogFile -Append -Encoding utf8
Write-Host "Log: $LogFile"
