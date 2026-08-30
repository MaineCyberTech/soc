import json, os, time, socket, requests, urllib3, hashlib
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
urllib3.disable_warnings()
OPENSEARCH = "https://shuffle-opensearch:9200"
DEDUP_IDX = "wazuh-iris-dedup-000001"
IRIS_HOST = "iriswebapp_nginx"
IRIS_PORT = 8443

def load_env():
    env = {}
    for path in ["/shuffle-files/iris-shuffle.env", "/run/secrets/iris-shuffle.env", "/run/secrets/dedup-shuffle.env"]:
        try:
            with open(path) as fh:
                for line in fh:
                    line = line.strip()
                    if not line or line.startswith("#") or "=" not in line:
                        continue
                    k, v = line.split("=", 1)
                    env[k.strip()] = v.strip().strip('"')
        except Exception:
            continue
    return env

ENV = load_env()
IRIS_TOKEN = ENV.get("IRIS_API_KEY")
DEDUP_USER = ENV.get("OPENSEARCH_DEDUP_USER", "admin")
DEDUP_PASS = ENV.get("OPENSEARCH_DEDUP_PASSWORD", "")

def wait_connect(host, port, tries=10, delay=2):
    for _ in range(tries):
        try:
            s = socket.create_connection((host, port), timeout=5); s.close(); return True
        except Exception:
            time.sleep(delay)
    return False

arg = self.full_execution.get("execution_argument", "{}")
try:
    alert = json.loads(arg) if isinstance(arg, str) else arg
except Exception:
    alert = {}

rule = (alert.get("rule") or {})
rule_id = rule.get("id")

def build_body():
    return {"alert_title":"Wazuh flow alert (Class A)","alert_source":"wazuh","alert_source_ref":str(rule_id) if rule_id is not None else "","alert_severity_id":6,"alert_customer_id":1,"alert_status_id":2,"alert_source_content":{"monitor":str(rule_id) if rule_id is not None else ""},"alert_tags":"source:wazuh,class:A"}

token = IRIS_TOKEN
if not token:
    print(json.dumps({"state":"AUTH_FAILED","reason":"token_unavailable"}))
else:
    raw_id = alert.get("id") or alert.get("alert_id")
    event_id = str(raw_id) if raw_id else hashlib.md5(json.dumps(alert, sort_keys=True).encode()).hexdigest()
    dedup_url = "%s/%s/_doc/%s" % (OPENSEARCH, DEDUP_IDX, event_id)
    ca = os.environ.get("OPENSEARCH_CA_BUNDLE", "/opt/mct/security/opensearch-ca.pem")
    iris_ca = os.environ.get("IRIS_CA", "/run/secrets/iris-ca.crt")

    # 1) ATOMIC CLAIM before any IRIS POST (exactly-once: only one execution can claim)
    claim_body = {"event_id": event_id, "alert_id": None, "claimed_ts": time.time(), "state": "CLAIMED"}
    try:
        cr = requests.put(dedup_url + "?op_type=create", json=claim_body, auth=(DEDUP_USER, DEDUP_PASS), verify=ca, timeout=10)
    except Exception:
        cr = None

    if cr is not None and cr.status_code == 409:
        # event_id already claimed by a prior attempt (or concurrent racer)
        seen = None
        try:
            g = requests.get(dedup_url, auth=(DEDUP_USER, DEDUP_PASS), verify=ca, timeout=10)
            if g.status_code == 200:
                seen = g.json().get("_source", {}).get("alert_id")
        except Exception:
            seen = None
        if seen:
            print(json.dumps({"state":"DUP_SKIP","event_id":event_id,"cached_alert_id":str(seen)[:80]}))
        else:
            # CLAIMED but alert_id not recorded (crash-after-accept / partial-success /
            # response-loss / timeout). Fail-closed: NEVER re-POST (would create a
            # duplicate if IRIS already has the object). Reconciliation blocks replay.
            print(json.dumps({"state":"RECONCILE_PENDING","event_id":event_id,"reason":"claim_without_alert_id; no_duplicate"}))
    else:
        # 2) We own the claim. POST to IRIS, then record alert_id (CLAIMED -> DELIVERED).
        url = "https://%s:%d/alerts/add" % (IRIS_HOST, IRIS_PORT)
        wait_connect(IRIS_HOST, IRIS_PORT)
        sess = requests.Session()
        sess.mount("https://", HTTPAdapter(max_retries=Retry(connect=6, read=3, backoff_factor=1.5)))
        state = None
        max_attempts = 5
        for attempt in range(1, max_attempts + 1):
            try:
                r = sess.post(url, json=build_body(), headers={"Authorization":"Bearer " + token, "Content-Type":"application/json"}, verify=iris_ca, timeout=20)
                if r.ok:
                    aid = None
                    try:
                        aid = r.json().get("data", {}).get("alert_id")
                    except Exception:
                        pass
                    for _ in range(5):
                        try:
                            requests.put(dedup_url, json={"event_id": event_id, "alert_id": aid, "claimed_ts": time.time(), "state": "DELIVERED"}, auth=(DEDUP_USER, DEDUP_PASS), verify=ca, timeout=10)
                            break
                        except Exception:
                            time.sleep(1)
                    print(json.dumps({"state":"ROUTED","http_status":r.status_code,"alert_id":aid,"attempt":attempt,"event_id":event_id}))
                    state = "ROUTED"
                    break
                state = {"state":"TARGET_FAILED","http_status":r.status_code,"resp":r.text[:200],"attempt":attempt}
            except Exception as e:
                state = {"state":"TARGET_FAILED","error":str(e)[:200],"attempt":attempt}
            time.sleep(2 ** attempt)
        if state != "ROUTED":
            # All attempts failed: leave CLAIMED-without-alert_id (fail-closed, no duplicate).
            print(json.dumps({"state":"DEAD_LETTER","detail":state,"event_id":event_id}))
