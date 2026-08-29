#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["source_event_id","prior_state","no_existing_object","approval_id","atomic_transition","idempotency_key_preserved","one_object","object_readback","second_replay_suppressed"];m=[k for k in r if not x.get(k)];bad=x.get("prior_state")!="DEAD_LETTERED";print(json.dumps({"missing_or_false":m,"invalid_prior_state":bad},indent=2));raise SystemExit(bool(m or bad))
