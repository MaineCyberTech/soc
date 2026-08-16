<#
MCT endpoint deployment - Windows
Installs Wazuh agent + Sysmon (+ optional Velociraptor client) on Windows 10/11/Server.
Designed for level.io: idempotent, logs to C:\ProgramData\MCT\mct-endpoint-install.log, exit 1 on failure.

level.io variables (script parameters or env):
  WAZUH_MANAGER         (default 192.168.222.149)
  WAZUH_AGENT_GROUP     (default "default"; e.g. "windows-clients")
  WAZUH_REG_PASSWORD    (optional, encrypted variable)
  WAZUH_AGENT_NAME      (optional; defaults to computer name)
  WAZUH_VERSION         (default 4.14.7)
  INSTALL_SYSMON        (default "yes" for Windows)
  INSTALL_VELOCIRAPTOR  (optional "yes" - requires VELO_CONFIG_URL or VELO_CONFIG_B64)
  VELO_CONFIG_URL       (URL to client.config.yaml)
  VELO_CONFIG_B64       (base64 of client.config.yaml)
#>
param(
    [string]$WAZUH_MANAGER = $(if ($env:WAZUH_MANAGER) { $env:WAZUH_MANAGER } else { "142.105.190.25" }),
    [string]$WAZUH_AGENT_GROUP = $(if ($env:MCT_AGENT_GROUP) { $env:MCT_AGENT_GROUP } elseif ($env:WAZUH_AGENT_GROUP) { $env:WAZUH_AGENT_GROUP } else { "default" }),
    [string]$WAZUH_REG_PASSWORD = $env:WAZUH_REG_PASSWORD,
    [string]$WAZUH_AGENT_NAME = $(if ($env:WAZUH_AGENT_NAME) { $env:WAZUH_AGENT_NAME } else { $env:COMPUTERNAME }),
    [string]$WAZUH_VERSION = $(if ($env:WAZUH_VERSION) { $env:WAZUH_VERSION } else { "4.14.7" }),
    [string]$INSTALL_SYSMON = $(if ($env:INSTALL_SYSMON) { $env:INSTALL_SYSMON } else { "yes" }),
    [string]$INSTALL_VELOCIRAPTOR = $(if ($env:INSTALL_VELOCIRAPTOR) { $env:INSTALL_VELOCIRAPTOR } else { "no" }),
    [string]$VELO_CONFIG_URL = $env:VELO_CONFIG_URL,
    [string]$VELO_CONFIG_B64 = $env:VELO_CONFIG_B64,
    [switch]$DryRun = $false,
    [switch]$PrintConfigRedacted = $false
)

$ErrorActionPreference = "Stop"

# Unresolved Level.io placeholders are treated as missing ({{VAR}}).
function Test-MctValue {
    param([string]$Value)
    if ([string]::IsNullOrEmpty($Value)) { return $false }
    if ($Value -match "\{\{.*\}\}") { return $false }
    return $true
}

if (-not (Test-MctValue $WAZUH_MANAGER) -or $WAZUH_MANAGER -eq "142.105.190.25" -and -not (Test-MctValue $env:WAZUH_MANAGER)) {
    Write-Output "WARN: WAZUH_MANAGER not set - using default (non-LAN deployments must set it)"
}
if (-not (Test-MctValue $WAZUH_REG_PASSWORD)) {
    Write-Output "ERROR: WAZUH_REG_PASSWORD is required (registration password enabled on master)"
    Write-Output "  Set it in Level.io as an encrypted automation variable and pass via"
    Write-Output "  -WAZUH_REG_PASSWORD or WAZUH_REG_PASSWORD env."
    exit 2
}

if ($DryRun -or $PrintConfigRedacted) {
    Write-Output "== MCT endpoint install (Windows) config =="
    Write-Output "  WAZUH_MANAGER = $(if (Test-MctValue $WAZUH_MANAGER) { $WAZUH_MANAGER } else { '<unset>' }) (non-secret)"
    Write-Output "  WAZUH_AGENT_GROUP = $WAZUH_AGENT_GROUP"
    Write-Output "  WAZUH_AGENT_NAME = $WAZUH_AGENT_NAME"
    Write-Output "  WAZUH_VERSION = $WAZUH_VERSION"
    Write-Output "  INSTALL_SYSMON = $INSTALL_SYSMON"
    Write-Output "  INSTALL_VELOCIRAPTOR = $INSTALL_VELOCIRAPTOR"
    Write-Output "  WAZUH_REG_PASSWORD = $(if (Test-MctValue $WAZUH_REG_PASSWORD) { '<set:redacted>' } else { '<unset>' })"
    Write-Output "  VELO_CONFIG_B64 = $(if (Test-MctValue $VELO_CONFIG_B64) { '<set:redacted>' } else { '<unset>' })"
    if ($DryRun) {
        Write-Output "DRY RUN - no changes made."
        exit 0
    }
}

$logDir = "C:\ProgramData\MCT"
$log = "$logDir\mct-endpoint-install.log"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
Start-Transcript -Path $log -Append -Force | Out-Null
Write-Output "=== MCT endpoint install (Windows) started $(Get-Date -Format o) ==="

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "ERROR: must run as Administrator"
    exit 1
}

# ---------------------------------------------------------------- Wazuh agent
$wazuhInstalled = (Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue) -ne $null
if ($wazuhInstalled) {
    Write-Output "Wazuh agent already installed - skipping install"
} else {
    Write-Output "installing Wazuh agent (MSI) $WAZUH_VERSION"
    $msi = "$env:TEMP\wazuh-agent.msi"
    Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-$WAZUH_VERSION-1.msi" -OutFile $msi
    $args = @(
        "/i", $msi, "/qn", "/norestart",
        "WAZUH_MANAGER=$WAZUH_MANAGER",
        "WAZUH_REGISTRATION_SERVER=$WAZUH_MANAGER",
        "WAZUH_AGENT_NAME=$WAZUH_AGENT_NAME"
    )
    if ($WAZUH_AGENT_GROUP -and $WAZUH_AGENT_GROUP -ne "default") {
        $args += "WAZUH_AGENT_GROUP=$WAZUH_AGENT_GROUP"
    }
    if (-not $WAZUH_REG_PASSWORD) {
        Write-Output "ERROR: WAZUH_REG_PASSWORD is required (registration password enabled on master)"
        Write-Output "  Set it in level.io as an encrypted variable (value in host creds.env WAZUH_REGISTRATION_PASSWORD)."
        exit 1
    }
    $args += "WAZUH_REGISTRATION_PASSWORD=$WAZUH_REG_PASSWORD"
    $p = Start-Process msiexec.exe -ArgumentList $args -Wait -PassThru
    Remove-Item $msi -Force -ErrorAction SilentlyContinue
    if ($p.ExitCode -ne 0) {
        Write-Output "ERROR: MSI install failed exit=$($p.ExitCode)"
        exit 1
    }
}

# wait for service
$deadline = (Get-Date).AddMinutes(3)
while ((Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue) -eq $null -and (Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 5
}
$svc = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
if (-not $svc) {
    Write-Output "ERROR: WazuhSvc not found after install"
    exit 1
}
Start-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
Write-Output "OK: Wazuh agent service $($svc.Status)"

# ---------------------------------------------------------------- Sysmon
if ($INSTALL_SYSMON -eq "yes") {
    $sysmonInstalled = (Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue) -ne $null
    if ($sysmonInstalled) {
        Write-Output "Sysmon already installed - skipping"
    } else {
        Write-Output "installing Sysmon"
        $zip = "$env:TEMP\Sysmon.zip"
        $sysmonDir = "$env:TEMP\sysmon"
        Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile $zip
        Expand-Archive -Path $zip -DestinationPath $sysmonDir -Force
        $sysmonExe = Get-ChildItem "$sysmonDir\Sysmon64.exe" -ErrorAction SilentlyContinue
        if (-not $sysmonExe) {
            $sysmonExe = Get-ChildItem "$sysmonDir\Sysmon.exe" | Select-Object -First 1
        }
        if (-not $sysmonExe) {
            Write-Output "WARN: Sysmon binary not found in zip - skipping"
        } else {
            $configPath = "$sysmonDir\sysmon-mct.xml"
            # sysmon-mct.xml is embedded below; if you prefer a managed config,
            # set SYSMON_CONFIG_URL to fetch it instead.
            if ($env:SYSMON_CONFIG_URL) {
                Invoke-WebRequest -Uri $env:SYSMON_CONFIG_URL -OutFile $configPath
            } else {
                @'
<Sysmon schemaversion="4.90">
  <EventFiltering>
    <ProcessCreate onmatch="exclude">
      <Image condition="is">C:\Windows\System32\conhost.exe</Image>
      <Image condition="is">C:\Windows\System32\svchost.exe</Image>
      <Image condition="is">C:\Windows\System32\fontdrvhost.exe</Image>
      <Image condition="is">C:\Windows\System32\dllhost.exe</Image>
      <Image condition="is">C:\Windows\System32\RuntimeBroker.exe</Image>
      <Image condition="is">C:\Windows\System32\backgroundTaskHost.exe</Image>
      <Image condition="is">C:\Windows\System32\cmd.exe</Image>
      <Image condition="is">C:\Windows\System32\SearchIndexer.exe</Image>
      <Image condition="is">C:\Windows\System32\spoolsv.exe</Image>
      <Image condition="is">C:\Windows\System32\winlogon.exe</Image>
      <Image condition="is">C:\Windows\System32\lsass.exe</Image>
      <Image condition="is">C:\Windows\System32\services.exe</Image>
      <Image condition="is">C:\Windows\System32\csrss.exe</Image>
      <Image condition="is">C:\Windows\System32\smss.exe</Image>
      <Image condition="is">C:\Windows\System32\wininit.exe</Image>
      <Image condition="is">C:\Windows\System32\Taskmgr.exe</Image>
      <Image condition="is">C:\Windows\System32\ctfmon.exe</Image>
      <Image condition="is">C:\Windows\System32\WerFault.exe</Image>
    </ProcessCreate>
    <NetworkConnect onmatch="include">
      <Image condition="is">C:\Windows\System32\svchost.exe</Image>
    </NetworkConnect>
    <NetworkConnect onmatch="exclude">
      <Image condition="is">C:\Windows\System32\svchost.exe</Image>
    </NetworkConnect>
    <CreateRemoteThread onmatch="include">
      <SourceImage condition="is">C:\Windows\System32\svchost.exe</SourceImage>
    </CreateRemoteThread>
    <CreateRemoteThread onmatch="exclude">
      <SourceImage condition="is">C:\Windows\System32\svchost.exe</SourceImage>
    </CreateRemoteThread>
    <FileCreateTime onmatch="exclude">
      <Image condition="is">C:\Windows\System32\svchost.exe</Image>
    </FileCreateTime>
    <ProcessAccess onmatch="include">
      <TargetImage condition="is">C:\Windows\System32\lsass.exe</TargetImage>
    </ProcessAccess>
    <ProcessAccess onmatch="exclude">
      <SourceImage condition="is">C:\Windows\System32\svchost.exe</SourceImage>
    </ProcessAccess>
    <ImageLoad onmatch="exclude">
      <Image condition="is">C:\Windows\System32\svchost.exe</Image>
    </ImageLoad>
  </EventFiltering>
</Sysmon>
'@ | Set-Content -Path $configPath -Encoding UTF8
            }
            Start-Process -FilePath $sysmonExe.FullName -ArgumentList "-accepteula -i `"$configPath`"" -Wait -NoNewWindow
            $deadline = (Get-Date).AddMinutes(2)
            while ((Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue) -eq $null -and (Get-Date) -lt $deadline) {
                Start-Sleep -Seconds 5
            }
            if (Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue) {
                Write-Output "OK: Sysmon installed"
            } else {
                Write-Output "WARN: Sysmon service not detected - check manually"
            }
        }
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
    }
}

# ---------------------------------------------------------------- Velociraptor
if ($INSTALL_VELOCIRAPTOR -eq "yes") {
    Write-Output "installing Velociraptor client"
    if (-not $VELO_CONFIG_URL -and -not $VELO_CONFIG_B64) {
        Write-Output "WARN: no VELO_CONFIG_URL/VELO_CONFIG_B64 - skipping client"
    } else {
        if (-not (Get-Command velociraptor -ErrorAction SilentlyContinue)) {
            $veloUrl = "https://github.com/Velocidex/velociraptor/releases/download/v0.77.2/velociraptor-v0.77.2-windows-amd64.exe"
            Invoke-WebRequest -Uri $veloUrl -OutFile "$env:ProgramFiles\velociraptor.exe"
        }
        $veloConfig = "$env:ProgramFiles\velociraptor.client.yaml"
        if ($VELO_CONFIG_B64) {
            [IO.File]::WriteAllBytes($veloConfig, [Convert]::FromBase64String($VELO_CONFIG_B64))
        } else {
            Invoke-WebRequest -Uri $VELO_CONFIG_URL -OutFile $veloConfig
        }
        & "$env:ProgramFiles\velociraptor.exe" --config $veloConfig service install | Out-Null
        & "$env:ProgramFiles\velociraptor.exe" --config $veloConfig service start | Out-Null
        Write-Output "OK: Velociraptor client installed"
    }
}

Write-Output "=== MCT endpoint install (Windows) completed $(Get-Date -Format o) ==="
Stop-Transcript | Out-Null
exit 0
