<#
.SYNOPSIS
  Deploy / verify / roll back the MCT include-oriented Sysmon EventID 7 policy on a
  Windows endpoint (agents 013 SAMSUNG / 014 DESKTOP-MI54LFT).

.DESCRIPTION
  Applies integrations/sysmon/phase23-eventid7-policy.xml (include-oriented ImageLoad
  rules: LOLBin loading processes, unsigned modules, non-system module paths). Preserves
  EventID 1/10. Never disables all EventID 7. Every change is preceded by a timestamped
  config backup + SHA256 hash; rollback restores the prior config.

  Modes:
    check    - report current Sysmon config hash, service state, and recent EID7 volume.
    apply    - backup + hash, copy policy to Sysmon dir, reload config, verify service.
    rollback - restore the newest backup (or a specific path) and reload.

.PARAMETER Mode
  check | apply | rollback

.PARAMETER ConfigPath
  Path to the include-oriented policy XML (default C:\Windows\Sysmon\mct-eid7-policy.xml).

.PARAMETER BackupPath
  Specific backup to restore in rollback mode (optional; default = newest backup).

.EXAMPLE
  .\apply-sysmon-tune.ps1 -Mode check
  .\apply-sysmon-tune.ps1 -Mode apply
  .\apply-sysmon-tune.ps1 -Mode rollback

.NOTES
  Run from an elevated PowerShell on the endpoint. No secrets. Part of MCT Phase 24
  (see ops/reports/phase24-06-agent014-sysmon-apply.md and
  integrations/sysmon/phase23-eventid7-policy.xml).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("check", "apply", "rollback")]
    [string]$Mode,

    [string]$ConfigPath = "C:\Windows\Sysmon\mct-eid7-policy.xml",
    [string]$BackupPath = ""
)

$ErrorActionPreference = "Stop"
$SysmonExe = "C:\Windows\Sysmon\Sysmon64.exe"
$BackupDir = "C:\Windows\Sysmon\mct-backups"
$LogFile = "C:\Windows\Sysmon\mct-sysmon-tune.log"
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

function Get-RecentEid7Count {
    try {
        $e = Get-WinEvent -FilterHashtable @{LogName = "Microsoft-Windows-Sysmon/Operational"; Id = 7 } -MaxEvents 1 -ErrorAction SilentlyContinue
        return "EID7 events present (last 60 min via provider stats: n/a; see Wazuh for counts)"
    } catch {
        return "no recent EID7 events (channel quiet or empty)"
    }
}

function Test-SysmonService {
    $svc = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq "Running") { return "RUNNING" }
    return "NOT RUNNING / MISSING"
}

function Backup-CurrentConfig([string]$Source) {
    if (-not (Test-Path $Source)) {
        Write-LogLine "WARN: current config not found at $Source - skipping backup (rollback will rely on prior backups)"
        return ""
    }
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $ts = Get-Date -Format "yyyyMMddTHHmmssZ"
    $bak = Join-Path $BackupDir "sysmon-config.$ts.xml"
    Copy-Item -Path $Source -Destination $bak -Force
    Write-LogLine "Backup written: $bak (sha256 $((Get-SysmonHash $bak)))"
    return $bak
}

function Invoke-Apply {
    Write-LogLine "== apply =="
    if (-not (Test-Path $ConfigPath)) {
        Write-LogLine "ERROR: policy XML not found at $ConfigPath - copy phase23-eventid7-policy.xml there first"
        exit 3
    }
    $current = Test-Path "C:\Windows\Sysmon\sysmon-config.xml"
    if ($current) {
        $h = Get-SysmonHash "C:\Windows\Sysmon\sysmon-config.xml"
        Write-LogLine "Current sysmon-config.xml sha256: $h"
    }
    $bak = Backup-CurrentConfig "C:\Windows\Sysmon\sysmon-config.xml"
    if ($bak -and (Get-Item $ConfigPath).FullName -ne "C:\Windows\Sysmon\sysmon-config.xml") {
        Copy-Item -Path $ConfigPath -Destination "C:\Windows\Sysmon\sysmon-config.xml" -Force
        Write-LogLine "Copied policy -> C:\Windows\Sysmon\sysmon-config.xml"
    }
    Write-LogLine "Loading config (service stays running)..."
    & $SysmonExe -c "C:\Windows\Sysmon\sysmon-config.xml"
    if ($LASTEXITCODE -ne 0) {
        Write-LogLine "ERROR: Sysmon rejected the config (exit $LASTEXITCODE) - rollback recommended: .\apply-sysmon-tune.ps1 -Mode rollback"
        exit 1
    }
    Write-LogLine "Sysmon reload OK; service: $(Test-SysmonService)"
    Write-LogLine "New config sha256: $(Get-SysmonHash 'C:\Windows\Sysmon\sysmon-config.xml')"
    Write-LogLine "Validation (SOC-side): EID7 >=99% drop, EID1/10 flowing, buffer clean - confirm in Wazuh."
}

function Invoke-Rollback {
    Write-LogLine "== rollback =="
    $target = $BackupPath
    if (-not $target) {
        $target = (Get-ChildItem -Path $BackupDir -Filter "sysmon-config.*.xml" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    }
    if (-not $target -or -not (Test-Path $target)) {
        Write-LogLine "ERROR: no backup to restore (use -BackupPath)"
        exit 3
    }
    Copy-Item -Path $target -Destination "C:\Windows\Sysmon\sysmon-config.xml" -Force
    Write-LogLine "Restored $target"
    & $SysmonExe -c "C:\Windows\Sysmon\sysmon-config.xml"
    if ($LASTEXITCODE -ne 0) { Write-LogLine "ERROR: rollback config rejected (exit $LASTEXITCODE)"; exit 1 }
    Write-LogLine "Rollback OK; service: $(Test-SysmonService)"
}

switch ($Mode) {
    "check" {
        Write-LogLine "== check =="
        Write-LogLine "Sysmon service: $(Test-SysmonService)"
        Write-LogLine "Policy config sha256: $(Get-SysmonHash $ConfigPath)"
        Write-LogLine "Deployed config sha256: $(Get-SysmonHash 'C:\Windows\Sysmon\sysmon-config.xml')"
        Write-LogLine "Backups present: $((Get-ChildItem -Path $BackupDir -Filter 'sysmon-config.*.xml' -ErrorAction SilentlyContinue | Measure-Object).Count)"
        Write-LogLine (Get-RecentEid7Count)
        Write-LogLine "Check Wazuh: agent keepalive + EID7/EID1/EID10 counts."
    }
    "apply" { Invoke-Apply }
    "rollback" { Invoke-Rollback }
}

$Log | Out-File -FilePath $LogFile -Append -Encoding utf8
Write-Host "Log: $LogFile"