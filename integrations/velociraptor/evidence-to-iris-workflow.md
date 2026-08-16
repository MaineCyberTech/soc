# Velociraptor Evidence -> IRIS Workflow

## When to use

After a Wazuh alert (or IRIS case) requires endpoint evidence collection.

## Steps

1. Open/confirm IRIS case (use the case template mapped from the alert family).
2. Launch Velociraptor hunt from the alert-to-hunt map (phase4 version).
3. Wait for collection completion (server GUI -> Hunts -> Collected).
4. Download collection zip.
5. Attach to IRIS: Case -> Evidence -> Add evidence -> upload zip.
   - Title: `velociraptor-<huntid>-<hostname>-<YYYYMMDD>.zip`
   - Record SHA256 in the case timeline.
6. Analyze artifacts; record findings in case notes.
7. Add IOCs to MISP if malicious (per IOC lifecycle).

## IRIS API attach (automation path)

POST https://127.0.0.1:8443/api/case/<case_id>/evidence
Authorization: Bearer <REDACTED_IRIS_API_KEY>
multipart: evidence_file=<zip>

Requires Evidence Type configured in IRIS admin.

## Retention

- Evidence zips: keep per case closeout; archive to ops/backups or S3 DR bundle.
- IRIS DB (case data) backed up via iris-db-dump.sh.

## Blockers

- No Velociraptor clients enrolled as of 2026-08-11 - enrollment required first
  (pilot Linux or Windows VM). Until then, evidence collection is manual-only.
