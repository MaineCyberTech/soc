# Velociraptor Evidence -> IRIS (Phase 7)

## Flow (validated)

```text
Hunt completes (Generic.Client.Info / stats)
  -> evidence exported (JSON/zip)
  -> IRIS Case -> Evidence -> upload
  -> record SHA256 in case timeline
  -> analyst triage per case template
```

## Commands

```bash
# client-side artifact run (root):
velociraptor --config /etc/velociraptor.client.yaml artifacts collect Generic.Client.Info

# server-side (after GUI password set):
# GUI -> Hunts -> New -> Generic.Client.Info -> clients -> download zip
```

## IRIS attach

1. Case -> Evidence -> Add -> upload file.
2. Title: velociraptor-<flow>-<hostname>-<date>.
3. Add SHA256 to timeline.

## Safety

- Non-invasive artifacts only (info/stats).
- No process/memory/registry collection without case approval.
