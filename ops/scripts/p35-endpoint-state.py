#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1])); required={'id','connectivity','certification','telemetry_quality','throttle','owner','next_action'}; bad=[r for r in x if required-set(r)]
print(json.dumps({'endpoints':x,'invalid':bad},indent=2)); raise SystemExit(bool(bad))
