<#
simulate-levelio-windows.ps1 - simulate Level.io variable injection on Windows.
Tests env success path and missing-required failure path (dry-run, no changes).
Usage: pwsh -File scripts/endpoint-deploy/test/simulate-levelio-windows.ps1
#>
$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $scriptDir "../../..")
$install = Join-Path $root "scripts/endpoint-deploy/install-wazuh-windows.ps1"

Write-Output "== Level.io variable simulation (Windows) $(Get-Date -Format o) =="
Write-Output "(dry-run only - no system changes)"

if (-not (Test-Path $install)) {
    Write-Output "[FAIL] install-wazuh-windows.ps1 missing"
    exit 1
}

# 1. env-var success path (dry-run)
Write-Output "--- Test 1: env-var success path (-DryRun) ---"
$env:WAZUH_MANAGER = "192.168.222.149"
$env:WAZUH_REG_PASSWORD = "testpw"
$env:WAZUH_AGENT_GROUP = "windows-clients"
$out = & pwsh -NoProfile -File $install -DryRun 2>&1
if ($LASTEXITCODE -eq 0 -and ($out -match "WAZUH_REG_PASSWORD = <set:redacted>")) {
    Write-Output "[PASS] env vars consumed; password redacted; dry-run exit 0"
} else {
    Write-Output "[FAIL] env path failed (rc=$LASTEXITCODE)"
}

# 2. missing required -> fail-fast exit 2
Write-Output "--- Test 2: missing required variable -> fail-fast ---"
Remove-Item Env:WAZUH_REG_PASSWORD -ErrorAction SilentlyContinue
$out = & pwsh -NoProfile -File $install -DryRun 2>&1
if ($LASTEXITCODE -eq 2 -and ($out -match "WAZUH_REG_PASSWORD is required")) {
    Write-Output "[PASS] missing required -> exit 2 with clear message"
} else {
    Write-Output "[FAIL] missing-required path failed (rc=$LASTEXITCODE)"
}

Write-Output "== Simulation complete =="
