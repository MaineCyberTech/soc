# Velociraptor Test Client Evidence Export

## Prereq

- Test client enrolled (see test-client-enrollment.md - currently blocked by port conflict).

## Hunt (non-invasive)

1. GUI (https://127.0.0.1:8889) -> New Hunt -> `Generic.Client.Info`
   (hostname, OS, users - safe, no process/registry collection).
2. Select the test client; launch.
3. Wait for completion (GUI -> Hunts -> Collected).

## Export

1. Hunt -> Collected -> the client row -> Download.
2. File: `velociraptor-<huntid>-<hostname>-<date>.zip`.

## Attach to IRIS

1. IRIS -> Case -> Evidence -> Add evidence -> upload zip.
2. Title: `velociraptor-<huntid>-<hostname>-<date>.zip`.
3. Record zip SHA256 in the case timeline.

## Artifacts for future hunts (from alert-to-hunt map)

- Linux: ssh-authorized-keys, sudoers-and-new-users, cron-and-systemd-persistence,
  listening-ports, suspicious-processes, docker-socket-and-privileged-containers.
- Windows: persistence-runkeys-services-scheduledtasks, suspicious-powershell,
  lolbins-execution, rdp-and-logon-artifacts, defender-exclusions.

## Blockers

- Client-server path not functional (Portainer owns port 8000) - fix per
  test-client-enrollment.md before running hunts.
