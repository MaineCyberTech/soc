# Phase 21 Windows 014 Sysmon EventID 7 Analysis

Date: 2026-08-19
Agent: 014 DESKTOP-MI54LFT (192.168.111.162, windows-clients)

## 1. EventID 7 volume

- **24h total: 573,809** archive docs (all level-0, no rule match -> archives only).
- Hourly profile: 08-18 21:00 12K -> 22:00-04:00 steady ~68-77K/hr -> 05:00 3.6K (drop) ->
  **06:00 59,529 (resumed)**. Flood is cyclic/ongoing, not a one-off.
- Agent 014 buffer flooded at 08-18 19:40-19:43 (rules 203/204/205) just before the flood began.
- Projection while active: ~1.6M docs/day.

## 2. Top ImageLoaded paths (processes loading modules, 24h)

| Count | Path | Classification |
|---|---|---|
| 258,402 | C:\Windows\System32\conhost.exe | standard Windows console host |
| 167,609 | C:\Program Files\Docker\Docker\resources\bin\docker.exe | known tooling (Docker Desktop) |
| 49,150 | C:\Program Files\Level\osqueryi.exe | known tooling (osquery) |
| 34,948 | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe | standard PowerShell |
| 11,489 | C:\Program Files (x86)\Google\GoogleUpdater\...\updater.exe | known updater |
| 9,400 | C:\Windows\System32\backgroundTaskHost.exe | standard |
| 8,153 | C:\Windows\System32\wbem\WmiPrvSE.exe | standard |
| 6,012 | C:\Windows\System32\RuntimeBroker.exe | standard |
| 3,337 | C:\Windows\System32\taskhostw.exe | standard |
| 2,664 | ...\Microsoft VS Code\Code.exe | known tooling |
| 1,258 | C:\Windows\System32\wermgr.exe | standard (crash reporting) |
| + | SoftLandingTask, MoUsoCoreWorker, TiWorker, level.exe, etc. | standard/known |

## 3. Standard vs suspicious

- **All top paths are standard Microsoft/system paths or known tooling** (Docker Desktop, Level
  osquery, VS Code, Google Updater). **No suspicious paths in the top 15.**
- conhost.exe (258K) + docker.exe (168K) alone = ~74% of the flood.

## 4. Current Sysmon config source

- Wazuh `windows-clients` group reads the full `Microsoft-Windows-Sysmon/Operational` channel.
- The Sysmon config on 014 is the deployment baseline; **no tuned `sysmon-mct.xml` exists in
  the repo** (deployment doc requires it). EventID 7 was deployed before its "high volume -
  enable after tuning" caveat was applied.

## 5. Tuning recommendation

- **Targeted exclude, not disable-all**: add EventID 7 `<ImageLoad onmatch="exclude">` rules
  for known-safe process paths (conhost.exe, docker.exe, osqueryi.exe, powershell.exe,
  GoogleUpdater, standard System32 paths, VS Code, Level tooling).
- Preserve EventID 7 for all OTHER processes (keeps suspicious image-load detection).
- Preserve EventID 1 (Process Create, 15,186/24h) and EventID 10 (ProcessAccess, 1,499/24h).
- Apply = endpoint-dependent (014 not reachable from stack host) -> operator steps.

## Files

- `ops/reports/phase21-windows014-sysmon-eid7-analysis.md` (this)
- `integrations/sysmon/phase21-eventid7-tuning-plan.md`

## No secrets