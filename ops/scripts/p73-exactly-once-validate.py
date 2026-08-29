#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["source_event_id","stable_idempotency_key","delivered_immutable","ambiguous_to_reconciliation","crash_windows_tested","timeout_window_tested","concurrent_race_tested","destination_object_count","second_replay_suppressed"];m=[k for k in r if not x.get(k)];bad=x.get("destination_object_count")!=1;print(json.dumps({"missing_or_false":m,"invalid_object_count":bad},indent=2));raise SystemExit(bool(m or bad))
