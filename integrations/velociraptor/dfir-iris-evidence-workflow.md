# Velociraptor -> DFIR-IRIS Evidence Workflow

Purpose: get collected endpoint evidence into an IRIS case in a reproducible way.

## Flow

```text
IRIS case opened (triage)
  -> analyst launches Velociraptor hunt (see wazuh-alert-to-hunt-map.md)
  -> collection completes
  -> download collection zip (GUI: Hunt -> Collected -> Download)
  -> attach to IRIS case (manual upload or API)
  -> record evidence hash + case reference in the case timeline
```

## Manual attach (recommended default)

1. In IRIS: open case -> Evidence -> Add evidence -> upload the Velociraptor zip.
2. Set evidence title: `velociraptor-<hunt_id>-<client_hostname>`.
3. Add the collection SHA256 (from the zip filename metadata) to the case timeline.

## API attach (automation path, optional)

```text
POST {IRIS_BASE}/api/case/<case_id>/evidence
Authorization: Bearer <REDACTED_IRIS_API_KEY>
multipart: evidence_file=<velociraptor_collection.zip>
```

Requires the evidence type to be configured in IRIS (Evidence Types admin).

## Naming convention

`velociraptor-<huntid>-<hostname>-<YYYYMMDD>.zip`

## Retention

- Velociraptor collections: keep per case closeout; archive evidence zips to `ops/backups` or S3 DR bundle for completed cases (see `phase2-backup.md`).
- Case evidence remains in IRIS; IRIS database is backed up per `dfir-iris.md`.

## Failure modes

| Failure | Handling |
|---|---|
| Collection still running | Wait; hunt results are streamed, partial zip may exist |
| Client offline | Retry hunt; note in case; use Wazuh agent data meanwhile |
| Zip too large for IRIS upload | Split or upload via API with larger limit; store zip in backup share, reference path in case |
