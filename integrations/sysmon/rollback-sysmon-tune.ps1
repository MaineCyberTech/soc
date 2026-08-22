<#
.SYNOPSIS
  MCT Sysmon EventID 7 tuning - rollback mode (no arguments required; Level.io/RMM-safe).

.DESCRIPTION
  Restores the newest backup (effective-config dump or file copy) and reloads Sysmon. This script is self-contained (policy XML embedded) and requires no parameters.

  - Sysmon executable is RESOLVED dynamically (service registration -> common paths -> PATH).
  - The effective current config is captured via "Sysmon64 -s" dump (path-independent
    backup), so rollback works even if the config file location differs.
  - Native commands run via cmd /c so Sysmon's stderr banner never aborts the script.

  Log: C:\Windows\Sysmon\mct-sysmon-tune.log  (no secrets)
#>
$ErrorActionPreference = "Stop"
$BackupDir = "C:\Windows\Sysmon\mct-backups"
$LogFile = "C:\Windows\Sysmon\mct-sysmon-tune.log"
$Mode = "rollback"
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

function Invoke-NativeCmd([string]$Native, [string[]]$ArgList, [string]$OutFile) {
    # Run a native command via cmd /c so stderr output (e.g. Sysmon banner) never becomes
    # a terminating PowerShell error under $ErrorActionPreference = "Stop".
    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $quoted = @()
    foreach ($a in $ArgList) {
        if ($a -match '\s') { $quoted += '"{0}"' -f $a } else { $quoted += $a }
    }
    $cmd = '"{0}" {1}' -f $Native, ($quoted -join ' ')
    if ($OutFile) { $cmd += ' > "{0}" 2>&1' -f $OutFile }
    $out = & cmd /c $cmd 2>&1
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $oldEAP
    return $rc
}

function Resolve-SysmonExe {
    try {
        $svc = Get-CimInstance Win32_Service -Filter "Name='Sysmon64'" -ErrorAction SilentlyContinue
        if ($svc -and $svc.PathName) {
            $p = ($svc.PathName -replace '^"([^"]+)".*$', '$1') -replace '^([^ ]+).*$', '$1'
            if (Test-Path $p) { return $p }
        }
    } catch {}
    foreach ($cand in @('C:\Windows\Sysmon\Sysmon64.exe',
                        'C:\Windows\Sysmon64.exe',
                        'C:\Program Files\Sysmon\Sysmon64.exe',
                        'C:\Program Files\Sysmon\sysmon64.exe',
                        'C:\Tools\Sysmon\Sysmon64.exe',
                        'C:\Level\Sysmon\Sysmon64.exe')) {
        if (Test-Path $cand) { return $cand }
    }
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
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $dump = Join-Path $BackupDir "effective-config-$(Get-Date -Format 'yyyyMMddTHHmmssZ').xml"
    $rc = Invoke-NativeCmd $Script:SysmonExe @('-s') $dump
    if ((Test-Path $dump) -and (Get-Item $dump).Length -gt 100) {
        Write-LogLine "Effective config dumped: $dump (sha256 $((Get-SysmonHash $dump)))"
        return $dump
    }
    Write-LogLine "WARN: 'sysmon -s' produced no usable dump (rc=$rc) - fallback to file copy"
    if (Test-Path $Script:SysmonCfg) {
        $bak = Join-Path $BackupDir "sysmon-config-$(Get-Date -Format 'yyyyMMddTHHmmssZ').xml"
        Copy-Item $Script:SysmonCfg $bak -Force
        Write-LogLine "Config file backup: $bak (sha256 $((Get-SysmonHash $bak)))"
        return $bak
    }
    return ""
}

function Write-PolicyFile {
    # Always write the embedded policy (source of truth) so stale copies from earlier
    # partial runs cannot be re-applied. Previous hash logged for audit.
    New-Item -ItemType Directory -Force -Path "C:\Windows\Sysmon" | Out-Null
    $before = Get-SysmonHash $PolicyPath
    $policyXml = @'
<!--
  MCT EventID 7 include-oriented policy (phase23-eventid7-policy.xml).
  Sysmon 15.21 / schema 4.91 (matches deployed endpoints 013/014).
  Collects ImageLoad events ONLY for suspicious combinations. EID1/3/5/6/8/10/11/12/13/14/
  15/17/18/22/25 remain collected per baseline. Never disable EventID 1/10.
  Deploy: .\Sysmon64.exe -c phase23-eventid7-policy.xml
  Rollback: .\Sysmon64.exe -c <prior>.xml (backup retained by apply-sysmon-tune.ps1)
-->
<Sysmon schemaversion="4.91">
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
        <Signed condition="is not">true</Signed>
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
    Write-LogLine "Policy file written: $PolicyPath (was $before, now $((Get-SysmonHash $PolicyPath)))"
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
    $rc = Invoke-NativeCmd $Script:SysmonExe @('-c', $PolicyPath) $null
    if ($rc -ne 0) { Write-LogLine "ERROR: Sysmon rejected the policy (exit $rc) - rollback recommended (rollback-sysmon-tune.ps1)"; exit 1 }
    Write-LogLine "Sysmon reload command accepted (rc=0); service: $(Test-SysmonService)"
    $verify = Join-Path $env:TEMP 'mct-sysmon-verify.txt'
    $vrc = Invoke-NativeCmd $Script:SysmonExe @('-s') $verify
    if ((Test-Path $verify) -and (Select-String -Path $verify -Pattern 'image-load-include' -Quiet -ErrorAction SilentlyContinue)) {
        Write-LogLine "VERIFIED: effective config now contains the include-oriented rules (marker 'image-load-include')"
    } else {
        Write-LogLine "WARN: effective config does NOT show the marker (rc=$vrc) - run rollback-sysmon-tune.ps1 and re-check"
    }
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
        $tmp = Join-Path $env:TEMP 'mct-sysmon-s.txt'
        $rc = Invoke-NativeCmd $Script:SysmonExe @('-s') $tmp
        Write-LogLine "Effective config dump size: $((Get-Item $tmp -ErrorAction SilentlyContinue).Length) bytes (rc=$rc)"
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
    $rc = Invoke-NativeCmd $Script:SysmonExe @('-c', $target) $null
    if ($rc -ne 0) { Write-LogLine "ERROR: restore rejected (exit $rc)"; exit 1 }
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
