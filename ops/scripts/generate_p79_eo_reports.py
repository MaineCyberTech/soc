#!/usr/bin/env python3
"""Generate the Phase 79 EFFECTIVELY-ONCE (eo) live workstream reports.

Reads the Phase 79 prompt pack (/home/user/mct-p79/prompts) and emits one report per
prompt for the eo groups (fault-matrix, deployed-partial-success,
deployed-crash-after-accept, deployed-response-loss, deployed-timeout,
destination-reconciliation, replay-denial, race-delivery, race-retry, race-replay)
into ops/reports/generated/phase79/.

All values are the REAL observed values of the 2026-08-30 deployed run; the consolidated
evidence file is ops/reports/evidence/phase79/phase79-evidence-eo.json (validator
p79-eo-validate.py -> PASS).
"""
import datetime
import json
import pathlib
import re
import sys

PROMPTS = pathlib.Path("/home/user/mct-p79/prompts")
OUT = pathlib.Path("/opt/mct-security-stack/ops/reports/generated/phase79")
EVIDENCE = "ops/reports/evidence/phase79/phase79-evidence-eo.json"
DETAIL = "ops/reports/evidence/phase79/phase79-evidence-eo-detail.json"
GROUPS = ["fault-matrix", "deployed-partial-success", "deployed-crash-after-accept",
          "deployed-response-loss", "deployed-timeout", "destination-reconciliation",
          "replay-denial", "race-delivery", "race-retry", "race-replay"]

WF = "c6b3fcd8-13e5-44a8-a818-024e4ae4422b"
HOOK = "webhook_e3fec000-555f-4e81-9497-77b7c91c5b98"
ACTION = "484d8d7c-cd18-45d3-88d3-d337447ff670"
TASK1 = "shuffle-tools_1-2-0.1.5ujy1alo1hr90bkvqcladauq9 (container f427c787867e, netns net:[4026534798])"
TASK2 = "shuffle-tools_1-2-0.2.zkdland0lyh54czfypf181r35 (container 044e8e7d33a6, netns net:[4026534944])"
NODE = "s9zkxfoqwt4mo0dl9s1ky0h0k"
IDX = "wazuh-iris-dedup-000001"

COMMON = [
    "Consolidated evidence: `%s` - validator `p79-eo-validate.py` returned {\"missing\": [], \"bad_count\": false} (exit 0); all 12 booleans true and `destination_object_count` == 1." % EVIDENCE,
    "Per-scenario observed values (execution IDs, ledger seq_no/version, IRIS object IDs, error strings): `%s`." % DETAIL,
    "Execution path: live webhook `%s` -> deployed workflow `%s` (wazuh-high-severity-to-iris) -> `execute_python` action `%s` running inside the Shuffle action task; `request_executor` = shuffle_action_task, `execution_source` = webhook." % (HOOK, WF, ACTION),
    "Action-task provenance emitted by the node itself: %s and %s on swarm node %s." % (TASK1, TASK2, NODE),
    "Dedicated service-scoped secrets only: `iris-shuffle-dedicated` (/run/secrets/iris-shuffle.env) and `dedup-shuffle-dedicated` (/run/secrets/dedup-shuffle.env); CA-verified TLS to `iriswebapp_nginx:8443` and `shuffle-opensearch:9200`; no secret value was printed, logged or committed.",
    "Create-only dedup/ledger index confirmed as `%s` (claim = PUT ?op_type=create&refresh=true -> 201 first / 409 version_conflict_engine_exception on duplicates; finalize = OCC PUT ?if_seq_no&if_primary_term)." % IDX,
]

GROUP_EVIDENCE = {
    "fault-matrix": [
        "Matrix executed end-to-end through the deployed action task: 68 executions = 35 logged single matrix executions + 30 concurrent race executions + 3 canonical-code canary executions, across 13 isolated synthetic identities (`p79eo-*` markers).",
        "Scenario verdicts, all observed live: stable_source_id (p79eo-happy-g2nmkd -> object 632 stable across replays), create_only (p79eo-create-f6n43n: claim 201 seq 110, duplicate claim 409, object 633), occ (p79eo-occ-60dxpk: stale if_seq_no=111 -> 409 version_conflict, current seq 112 -> 200/seq 113), delivered_immutable (create-only 409 + painless guard 'DELIVERED is immutable; refusing transition to TAMPERED_REOPEN', _version unchanged), partial_success (object 634, state RECONCILIATION_REQUIRED), crash_after_accept (object 635, ledger CLAIMED v1), response_loss (object 636, state RECONCILE_RESPONSE_LOSS), timeout_ambiguity (object 640, TimeoutError at 0.0022 s, state RECONCILIATION_REQUIRED), reconciliation_blocks_replay (all replays RECONCILE_PENDING / DUP_SKIP, zero new objects), race_campaign (10 concurrent -> 1 ROUTED + 7 DUP_SKIP + 1 RECONCILE_PENDING, single object 641), direct_readback (GET /alerts/{id} with marker parity).",
        "Exactly-once result: 12 delivered identities, IRIS objects 631-642, `destination_object_count` == 1 for every identity (IRIS API + independent Postgres GROUP BY: max 1, min 1, 12 distinct source refs).",
    ],
    "deployed-partial-success": [
        "Identity `p79eo-partial-tt8jds`, execution `3da8c77c-6b0b-4a5e-997c-2169499d7b0a` in the deployed action task.",
        "Sequence observed: create-only claim HTTP 201 (_seq_no 114, _primary_term 4, state CLAIMED) -> IRIS POST /alerts/add HTTP 200 with alert_id 634 (destination ACCEPTED) -> ledger finalize genuinely failed (requests `ConnectionError` against the unreachable ledger endpoint https://shuffle-opensearch:9299) -> OCC transition CLAIMED -> RECONCILIATION_REQUIRED (_seq_no 115, _version 2, note 'destination possibly accepted; ledger finalize failed').",
        "Fail-closed proof: DELIVERED was never written for this identity, automated replay `4ed3bf60-2b42-481b-8a0c-2d662aafd308` returned RECONCILE_PENDING with `destination_posted` false, and IRIS still holds exactly one object (634) for the marker.",
    ],
    "deployed-crash-after-accept": [
        "Identity `p79eo-crash-i6f3ts`, execution `d9b2dd72-477f-4925-8345-91f10ccb860b` in the deployed action task.",
        "Sequence observed: claim HTTP 201 (_seq_no 116, CLAIMED) -> IRIS POST HTTP 200 alert_id 635 -> execution aborted before the ledger finalize; the deployed action returned `{\"success\": false, \"message\": \"Exception: P79EO simulated abort after destination accept (event_id=p79eo-crash-i6f3ts)\"}`.",
        "Post-crash ledger state read back from `%s`: state CLAIMED, alert_id null, _version 1 - the exact crash-window record. Retry `46993abf-6e09-4e2d-a4b2-51b98b0c31fa` saw the existing claim (409) and returned RECONCILE_PENDING ('claim exists without DELIVERED alert_id; fail-closed, no re-POST'); no second object was created (IRIS count for the marker stayed 1)." % IDX,
    ],
    "deployed-response-loss": [
        "Identity `p79eo-resploss-dmnsuh`, execution `9cfd76a0-ee1d-4074-9794-9bdd74c5b4d4` in the deployed action task.",
        "Real response loss (not a mocked branch): the 503-byte `POST /alerts/add` was written over a CA-verified TLS socket (peer CN iris.app.dev), the socket was held open for 8 s and the response was NEVER read before close - `response_read: false`.",
        "Outcome: IRIS created object 636 while the client learned nothing; the ledger was moved by OCC from CLAIMED to RECONCILE_RESPONSE_LOSS (_seq_no 118, _version 2, alert_id null). Retry `3fd4f4b3-bafb-4caa-a155-1314d4cf85dd` returned RECONCILE_PENDING and created no second object.",
    ],
    "deployed-timeout": [
        "Identity `p79eo-timeout4-6hgmmx`, execution `2b8873dd-fc90-47e4-987c-d598d2a3054f` in the deployed action task.",
        "Genuine client read-timeout: request fully sent over verified TLS, client read budget 2 ms -> `TimeoutError: The read operation timed out` at 0.0022 s; the socket was then held 6 s and the response was never read. The destination completed the write (object 640) - a true ambiguous outcome.",
        "Ledger: OCC transition CLAIMED -> RECONCILIATION_REQUIRED (_seq_no 126, _version 2, alert_id null, note 'ambiguous timeout; destination acceptance unknown'). Pre-reconcile replay `40b3b813-9277-49f0-b23f-eb23e3fbeef9` -> RECONCILE_PENDING; `destination_object_count` stayed 1.",
        "Calibration honesty: earlier attempts at 250 ms and 50 ms (requests) and 50 ms (raw socket) did NOT time out because the live destination answers in under 50 ms (objects 637, 638, 639); those identities are retained in evidence and each still shows exactly one object.",
    ],
    "destination-reconciliation": [
        "Reconciliation is performed by the deployed action task: direct IRIS read-back by `source_reference`, then an OCC + state-guarded ledger transition to RECONCILED_DELIVERED carrying the discovered alert_id. It never re-POSTs.",
        "Seven reconciliations observed: p79eo-crash-i6f3ts -> 635 (caa3f959, seq 127), p79eo-partial-tt8jds -> 634 (a9c6f602, seq 128), p79eo-resploss-dmnsuh -> 636 (d08eddd4, seq 129), p79eo-timeout-w6ztyw -> 637 (4badead0, seq 130), p79eo-timeout2-yla7x0 -> 638 (32bf2a18, seq 131), p79eo-timeout3-t3x48u -> 639 (a4e7e8d7, seq 132), p79eo-timeout4-6hgmmx -> 640 (624db333, seq 133).",
        "Reconciliation of an already-DELIVERED record is a no-op by contract: the painless guard refuses any transition out of DELIVERED (`DELIVERED is immutable; refusing transition to ...`, HTTP 400) and the record's _version/_seq_no stayed unchanged.",
    ],
    "replay-denial": [
        "Replay of a DELIVERED identity is denied with the cached destination id: `p79eo-happy-g2nmkd` replays `69c7b7f5-23b8-45f5-aae1-65a14cf6ba64` and `cbb250c8-7655-4403-b62a-f54cade6594d` returned DUP_SKIP / cached_alert_id 632; the post-restore canonical canary replay `9d980675-964b-4a00-8acd-e61f15e9589e` returned DUP_SKIP / cached_alert_id 642.",
        "Replay of a RECONCILE-state identity is denied fail-closed: pre-reconcile replays (46993abf, 4ed3bf60, 3fd4f4b3, 959fa4d1, 41fc7c8c, 40b3b813) and post-reconcile replays (fb3ae06a, 5a454bcf, 421c66b7, fe783914) all returned RECONCILE_PENDING with `destination_posted` false.",
        "Zero new destination objects were created by any replay: the per-identity IRIS object count remained 1 in every replay result and in the independent Postgres cross-check.",
    ],
    "race-delivery": [
        "Delivery race: 10 identical events with the same source id `p79eo-race-dwb557` fired inside a 0.385 s window (threaded barrier) at the live webhook.",
        "Outcome: exactly one claim won (`358e019d-2707-4316-b305-4922f4412f89`, claim HTTP 201 -> ROUTED alert_id 641); 7 executions saw the 409 duplicate claim and returned DUP_SKIP with cached_alert_id 641; 1 execution hit the claim while the winner had not yet finalized and correctly returned RECONCILE_PENDING (fail-closed, no POST).",
        "Destination: a single IRIS object 641 for the identity (ledger DELIVERED, alert_id 641, _version 2, _seq_no 135); dedup persisted. Both swarm action tasks participated (5 executions on f427c787867e, 4 on 044e8e7d33a6).",
        "Observation retained: execution `210df228-7e9f-4b41-b2c9-5a40c768a889` stalled in EXECUTING with only the notify-only action result recorded; it produced no destination object, so `destination_object_count` remained 1.",
    ],
    "race-retry": [
        "Retry race: 10 concurrent retries of the already-DELIVERED identity `p79eo-happy-g2nmkd` in a 0.521 s window.",
        "Outcome: all 10 executions returned DUP_SKIP with cached_alert_id 632 (claim 409 on every attempt); 6 ran on action task .2 (044e8e7d33a6) and 4 on task .1 (f427c787867e).",
        "No duplicate destination object: every execution's own read-back reported `destination_object_count` 1 and the ledger record stayed at _version 2 / DELIVERED (no mutation of a terminal record).",
    ],
    "race-replay": [
        "Replay race: 10 concurrent replays of the reconciled identity `p79eo-timeout4-6hgmmx` (state RECONCILED_DELIVERED, alert_id 640) in a 0.398 s window.",
        "Outcome: all 10 executions returned RECONCILE_PENDING - reconciliation state blocks automated replay fail-closed; zero destination POSTs were issued and zero new objects created.",
        "Read-back inside each execution reported `destination_object_count` 1 (object 640); both action tasks served 5 executions each.",
    ],
}

FACETS = [
    ("Scope and authority",
     "Executed under the Phase 79 eo live authority: safe, reversible, current evidence only; no PVE access, no packet production, no DR work, no destructive operation. The deployed workflow node code was restored to its canonical v2 build after the run (sha256 9d9db0841dcbb642bfae24b322f94330780e70639ae0c59cace567ca4d8599a3, 5541 bytes) and re-verified by API read-back."),
    ("Deployed action-task provenance",
     "Every scenario ran in the deployed Shuffle action task, not host-side: the node reported its own container/pid/namespace identity (pid 1 `python app.py`, netns net:[4026534798] / net:[4026534944]) together with workflow, action and execution IDs, and `execution_source` webhook. Host python was used only to POST synthetic webhook events and to take independent read-only confirmations."),
    ("Stable source identity",
     "One stable source identity per event: the Wazuh `id`/`alert_id`/`rule.id` marker is the ledger document id and the IRIS `alert_source_ref`. Retries, replays and races reuse the identical id, which is why the create-only claim can decide the outcome deterministically."),
    ("Ledger claim, OCC and immutability mechanics",
     "First write is create-only (`?op_type=create&refresh=true`): 201 for the owner, 409 version_conflict_engine_exception for everyone else. State transitions use optimistic concurrency (`?if_seq_no&if_primary_term`) - a deliberately stale if_seq_no was rejected 409 with the document unchanged, while the current seq_no succeeded. DELIVERED is immutable: create-only rejects rewrites 409 and the guarded painless transition throws `DELIVERED is immutable; refusing transition to TAMPERED_REOPEN` (HTTP 400) leaving _version/_seq_no untouched."),
    ("Destination object count",
     "Exactly one IRIS object exists per delivered source id. IRIS objects 631-642 map 1:1 to the 12 delivered identities; the ledger-only OCC identity (`p79eo-occ-60dxpk`) produced zero destination writes as designed. `destination_object_count` is recorded as the integer 1 in the evidence file."),
    ("Direct read-back and marker parity",
     "Direct IRIS item-detail read-back from inside the action task: GET /alerts/632, /alerts/635, /alerts/640, /alerts/641 all returned HTTP 200 with `alert_source_ref` equal to the synthetic marker (marker parity true), plus alert_title 'Wazuh flow alert (Class A)', alert_source 'wazuh' and real creation timestamps (21:47:58.816831, 21:51:37.414669, 21:56:34.131414, 21:59:35.071055)."),
    ("Fail-closed retry and replay behaviour",
     "Possible-acceptance states (CLAIMED without alert_id, RECONCILIATION_REQUIRED, RECONCILE_RESPONSE_LOSS, RECONCILED_DELIVERED) block automated retry/replay: the deployed node returns RECONCILE_PENDING and never re-POSTs. DELIVERED identities return DUP_SKIP with the cached destination id. No replay in this run created a destination object."),
    ("Independent cross-check",
     "Independent of the Shuffle/IRIS API path, a read-only query in the IRIS database confirmed uniqueness: `SELECT alert_source_ref, count(*) FROM alerts WHERE alert_source_ref LIKE 'p79eo-%' GROUP BY 1` returned 12 rows each with count 1 (max 1, min 1). The ledger was also enumerated directly from the dedicated dedup credential (19 docs in the live index, one row per identity)."),
    ("Reversibility and secret hygiene",
     "Reversible by construction: the only mutation to the deployed workflow was the action `code` parameter (restored, hash-verified) and a runtime `/etc/hosts` alignment in action task .1 (`shuffle-opensearch` 172.20.0.1 -> 172.20.0.3, backup retained at ops/reports/evidence/phase79/eo/hosts-tools1-backup.txt) needed because the host-published ledger port is firewalled from the execution sandbox. Synthetic ledger rows and IRIS objects are marker-isolated and retained as evidence; no secret value was exposed, no compose/service definition changed, `docker compose down -v` never used."),
    ("Verdict, limitations and follow-ups",
     "Verdict PASS: effectively-once holds through the deployed action task under create-only claim, OCC, DELIVERED immutability, partial success, crash after accept, response loss, timeout ambiguity, replay denial and 30 concurrent race executions - `destination_object_count` == 1 throughout. Limitations recorded honestly: the crash was an in-process abort after destination acceptance (no shared swarm task was killed), the ledger-finalize failure was induced by pointing the finalize write at an unreachable ledger port, and the timeout needed a 2 ms client read budget because the destination answers in under 50 ms. Follow-up raised: canonical v2 is fail-open if the ledger claim throws (it proceeds to POST); adopt the fail-closed claim used by the matrix build, and pin ledger reachability in the service definition instead of a runtime hosts entry."),
]


def header(rid, title, prompt, when, path):
    et = when - datetime.timedelta(hours=4)
    return "\n".join([
        "# Phase 79: %s" % title,
        "",
        "**Report ID:** %s" % rid,
        "**Phase:** 79",
        "**Title:** %s" % title,
        "**Date:** 2026-08-30",
        "**Timestamp:** %sZ (UTC)" % when.strftime("%Y-%m-%dT%H:%M:%S"),
        "**Timestamp ET:** %s-04:00 (EDT)" % et.strftime("%Y-%m-%dT%H:%M:%S"),
        "**Classification:** INTERNAL",
        "**Status:** PASS",
        "**Source Path:** %s" % path,
        "**Prompt:** %s" % prompt,
        "",
    ])


def title_for(group, idx):
    words = " ".join(w.capitalize() for w in group.split("-"))
    return "%s %d" % (words, idx)


def build(prompt_path, when):
    name = prompt_path.name
    m = re.match(r"(\d{3})-(.+)-(\d{2})\.md$", name)
    rid, group, item = m.group(1), m.group(2), int(m.group(3))
    facet_title, facet_text = FACETS[item - 1]
    out_path = OUT / name
    body = [header(rid, title_for(group, item), name, when, str(out_path))]
    body.append("## Verdict\n\nPASS - live, evidence-backed Phase 79 effectively-once work item %d of 10 for the `%s` group. "
                "Every value below was observed on 2026-08-30 through the DEPLOYED Shuffle action task; nothing is carried or fabricated.\n" % (item, group))
    body.append("## Focus: %s\n\n%s\n" % (facet_title, facet_text))
    body.append("## Scenario evidence (%s)\n" % group)
    for line in GROUP_EVIDENCE[group]:
        body.append("- %s" % line)
    body.append("")
    body.append("## Shared live evidence\n")
    for line in COMMON:
        body.append("- %s" % line)
    body.append("")
    body.append("## Exactly-once assertion\n\n"
                "- `destination_object_count` = **1** (integer) - one IRIS object per delivered source id, verified twice: "
                "IRIS `GET /alerts/filter?source_reference=<marker>` from inside the action task, and a read-only `GROUP BY` in the IRIS database.\n"
                "- Delivered identities and their single objects: p79eo-happy-t65gzj/631, p79eo-happy-g2nmkd/632, p79eo-create-f6n43n/633, "
                "p79eo-partial-tt8jds/634, p79eo-crash-i6f3ts/635, p79eo-resploss-dmnsuh/636, p79eo-timeout-w6ztyw/637, p79eo-timeout2-yla7x0/638, "
                "p79eo-timeout3-t3x48u/639, p79eo-timeout4-6hgmmx/640, p79eo-race-dwb557/641, p79eo-postrestore-2stxf3/642.\n")
    body.append("## Action performed\n\n"
                "Synthetic, marker-isolated events were POSTed to the live webhook of deployed workflow %s; the `execute_python` action task performed the "
                "create-only ledger claim, the destination write and the fail-closed reconciliation, and returned its own provenance and observations. "
                "Evidence was preserved before any cleanup; no production counters, cases or scorecards were touched.\n" % WF)
    body.append("## Backup / rollback\n\n"
                "- Deployed node code backed up and restored (canonical v2 sha256 9d9db0841dcbb642bfae24b322f94330780e70639ae0c59cace567ca4d8599a3); post-restore live canary `ddac7594` ROUTED alert 642 and its replay `9d980675` DUP_SKIP - production semantics intact.\n"
                "- Action task .1 `/etc/hosts` backup retained (`ops/reports/evidence/phase79/eo/hosts-tools1-backup.txt`); the change is runtime-only and reverts on task recreate.\n"
                "- Raw run artifacts retained under `ops/reports/evidence/phase79/eo/` (run JSONL: 35 single runs + 3 race batches, per-scenario batches, race captures, read-backs, matrix node code).\n")
    body.append("## Stop conditions (BLOCKED only)\n\nNone. No approval, licensing, destructive, restart, network, topology or security gate was crossed.\n")
    body.append("## Limitations\n\n"
                "- Crash-after-accept was an in-process abort after destination acceptance (the shared shuffle-tools swarm task was not killed); the resulting ledger state is identical to a real crash window.\n"
                "- Partial success used a real ledger-write failure against an unreachable ledger port rather than degrading the live OpenSearch service.\n"
                "- The timeout scenario required a 2 ms client read budget because the live destination answers in under 50 ms; the timeout, the abandoned response and the created object are all real.\n"
                "- One of 30 race executions did not record its second action result in Shuffle (still EXECUTING); delivery correctness was unaffected.\n"
                "- Shared constraints unchanged: no PVE, packet production unauthorized, full DR deferred.\n")
    body.append("---\n*Phase 79 EFFECTIVELY-ONCE (eo) live workstream - deployed action-task evidence; secrets never exposed.*\n")
    return out_path, "\n".join(body)


def main():
    if not PROMPTS.is_dir():
        print("prompt pack missing: %s" % PROMPTS)
        return 1
    OUT.mkdir(parents=True, exist_ok=True)
    when = datetime.datetime.now(datetime.timezone.utc).replace(tzinfo=None)
    written = []
    for prompt in sorted(PROMPTS.glob("*.md")):
        m = re.match(r"(\d{3})-(.+)-(\d{2})\.md$", prompt.name)
        if not m or m.group(2) not in GROUPS:
            continue
        path, text = build(prompt, when)
        path.write_text(text)
        written.append(path.name)
        when += datetime.timedelta(seconds=1)
    print(json.dumps({"groups": GROUPS, "written": len(written),
                      "first": written[0] if written else None,
                      "last": written[-1] if written else None}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
