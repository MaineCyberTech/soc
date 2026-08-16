<#
MCT endpoint verification - Windows
Verifies Wazuh agent + Sysmon (+ Velociraptor) after deployment.
Designed for level.io: prints PASS/FAIL per check, exit 1 on any FAIL.
#>
param(
    [switch]$Quiet
)
$ErrorActionPreference = "Continue"
$fail = 0
function Ok($msg)  { Write-Output "[PASS] $msg" }
function Bad($msg) { Write-Output "[FAIL] $msg"; $script:fail = 1 }

Write-Output "== MCT endpoint verification (Windows) =="

# Wazuh service
$w = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
if ($w) {
    if ($w.Status -eq "Running") { Ok "WazuhSvc running" } else { Bad "WazuhSvc status=$($w.Status)" }
} else {
    Bad "WazuhSvc not found"
}

# agent registered (client.keys)
$keys = "C:\Program Files (x86)\ossec-agent\client.keys"
if (Test-Path $keys) {
    $lineCount = (Get-Content $keys | Measure-Object -Line).Lines
    if ($lineCount -gt 0) { Ok "agent enrolled (client.keys, $lineCount entries)" } else { Bad "client.keys empty" }
} else {
    Bad "client.keys not found - agent not enrolled"
}

# agent ossec.conf manager
$conf = "C:\Program Files (x86)\ossec-agent\ossec.conf"
if (Test-Path $conf) {
    $addr = Select-String -Path $conf -Pattern "<address>[^<]+" | Select-Object -First 1
    if ($addr) { Ok "ossec.conf manager set ($($addr.Matches.Value -replace '<address>',''))" } else { Bad "ossec.conf manager address missing" }
} else {
    Bad "ossec.conf not found"
}

# Sysmon
$s = Get-Service -Name "Sysmon64" -ErrorAction SilentlyContinue
if ($s) {
    if ($s.Status -eq "Running") { Ok "Sysmon64 running" } else { Bad "Sysmon64 status=$($s.Status)" }
    $events = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1 -ErrorAction SilentlyContinue
    if ($events) { Ok "Sysmon events flowing (last: $($events[0].TimeCreated))" } else { Bad "no Sysmon events found" }
} else {
    Write-Output "[INFO] Sysmon not installed (optional)"
}

# Velociraptor
if (Test-Path "$env:ProgramFiles\velociraptor.exe") {
    $v = Get-Process velociraptor -ErrorAction SilentlyContinue
    if ($v) { Ok "velociraptor running" } else { Bad "velociraptor installed but not running" }
} else {
    Write-Output "[INFO] velociraptor not installed (optional)"
}

Write-Output ""
Write-Output "Result: $(if ($fail -eq 0) { 'PASS' } else { 'FAIL' })"
exit $fail
