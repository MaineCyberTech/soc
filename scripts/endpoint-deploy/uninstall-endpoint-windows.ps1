<#
MCT endpoint uninstall - Windows
Removes Wazuh agent + Sysmon (+ Velociraptor). For offboarding or reinstall.
level.io: idempotent, exit 0 on success.
#>
param(
    [string]$RemoveSysmon = "yes"
)
$ErrorActionPreference = "Continue"
Write-Output "=== MCT endpoint uninstall (Windows) started $(Get-Date -Format o) ==="

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "ERROR: must run as Administrator"
    exit 1
}

# Wazuh agent (msiexec uninstall)
$w = Get-WmiObject -Class Win32_Product -Filter "Name LIKE 'Wazuh%'" -ErrorAction SilentlyContinue
if ($w) {
    $id = $w.IdentifyingNumber
    Write-Output "uninstalling Wazuh agent ($id)"
    $p = Start-Process msiexec.exe -ArgumentList "/x $id /qn /norestart" -Wait -PassThru
    Write-Output "Wazuh uninstall exit=$($p.ExitCode)"
} else {
    # fallback: service + files
    Stop-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
    sc.exe delete WazuhSvc | Out-Null
    Remove-Item "C:\Program Files (x86)\ossec-agent" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Wazuh agent removed (fallback)"
}

# Sysmon
if ($RemoveSysmon -eq "yes") {
    $sysmon = Get-ChildItem "$env:TEMP\sysmon\Sysmon64.exe","$env:ProgramFiles\Sysmon64.exe","$env:WINDIR\Sysmon64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $sysmon) {
        # download for clean uninstall
        $zip = "$env:TEMP\Sysmon.zip"
        Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile $zip -ErrorAction SilentlyContinue
        Expand-Archive -Path $zip -DestinationPath "$env:TEMP\sysmon" -Force -ErrorAction SilentlyContinue
        $sysmon = Get-ChildItem "$env:TEMP\sysmon\Sysmon64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    }
    if ($sysmon) {
        Start-Process -FilePath $sysmon.FullName -ArgumentList "-u" -Wait -NoNewWindow -ErrorAction SilentlyContinue
        Write-Output "Sysmon removed"
    } else {
        sc.exe delete Sysmon64 | Out-Null
        Write-Output "Sysmon removed (service delete fallback)"
    }
}

# Velociraptor
if (Test-Path "$env:ProgramFiles\velociraptor.exe") {
    & "$env:ProgramFiles\velociraptor.exe" --config "$env:ProgramFiles\velociraptor.client.yaml" service stop | Out-Null
    & "$env:ProgramFiles\velociraptor.exe" --config "$env:ProgramFiles\velociraptor.client.yaml" service remove | Out-Null
    Remove-Item "$env:ProgramFiles\velociraptor.exe","$env:ProgramFiles\velociraptor.client.yaml" -Force -ErrorAction SilentlyContinue
    Write-Output "Velociraptor removed"
}

Write-Output "=== MCT endpoint uninstall (Windows) completed $(Get-Date -Format o) ==="
exit 0
