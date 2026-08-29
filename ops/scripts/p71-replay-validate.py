#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["source_event_id","dead_letter_id","prior_state","approval_id","transition_atomic","idempotency_key_preserved","replay_object_id","object_readback","second_replay_suppressed","duplicate_objects_zero"];m=[k for k in r if not x.get(k)];bad=x.get("prior_state")!="DEAD_LETTERED";print(json.dumps({"missing_or_false":m,"invalid_prior_state":bad},indent=2));raise SystemExit(bool(m or bad))
