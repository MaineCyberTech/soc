#!/usr/bin/env python3
import json,sys
x=json.load(open(sys.argv[1]));r=["action_service","desired_network","dns_name","first_reschedule","second_reschedule","dns_pass","tcp_pass","tls_pass","scoped_secret_present","ca_present","strict_e2e_pass"];m=[k for k in r if not x.get(k)];print(json.dumps({"missing_or_false":m},indent=2));raise SystemExit(bool(m))
