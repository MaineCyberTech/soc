# D7 Evidence Export (verified path)

## After a hunt/flow completes

1. Server filestore: /var/tmp/velociraptor/clients/<client_id>/collections/<flow_id>/
   - stats.json.db, requests.json.db, + artifact result files
2. Export via GUI: Hunts -> Collected -> Download (zip)
3. Or copy the collection dir: `sudo tar czf velociraptor-<flow>-<client>.tar.gz <dir>`

## Attach to IRIS

1. IRIS -> Case -> Evidence -> Add evidence -> upload zip/tar.gz
2. Title: `velociraptor-<flow_id>-<hostname>-<date>`
3. Record SHA256 in case timeline

## Non-invasive artifacts (D7 validated)

- Generic.Client.Stats (validated - monitoring flow)
- Generic.Client.Info (hostname/OS - next validation when GUI password set)

## Safety

- No invasive artifacts in D7 (no processes/registry/memory collection).
- Evidence retained per case; archive to ops/backups at closeout.
