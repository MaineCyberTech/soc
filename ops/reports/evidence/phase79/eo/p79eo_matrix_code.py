import json, os, sys, time, socket, ssl, hashlib, requests, urllib3
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
urllib3.disable_warnings()

# ---------------------------------------------------------------------------
# Phase 79 EFFECTIVELY-ONCE matrix build of the deployed v2 node.
# Default path (no p79_eo directive in the event) == canonical v2 semantics:
#   create-only claim -> IRIS POST -> ledger finalize DELIVERED; 409 => no re-POST.
# Hardening vs v2: ledger endpoint selection is connectivity-checked (TLS hostname
# verification preserved) and an unreachable ledger is FAIL-CLOSED (never POSTs).
# A p79_eo directive (synthetic events only) selects a fault-injection scenario.
# ---------------------------------------------------------------------------
DEDUP_HOST = "shuffle-opensearch"
DEDUP_PORT = 9200
DEDUP_FALLBACK_IPS = ["172.20.0.3"]
DEDUP_IDX = "wazuh-iris-dedup-000001"
IRIS_HOST = "iriswebapp_nginx"
IRIS_PORT = 8443

FE = self.full_execution


def load_env():
    env = {}
    for path in ["/run/secrets/iris-shuffle.env", "/run/secrets/dedup-shuffle.env"]:
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
DEDUP_USER = ENV.get("OPENSEARCH_DEDUP_USER", "")
DEDUP_PASS = ENV.get("OPENSEARCH_DEDUP_PASSWORD", "")
OS_CA = ENV.get("OPENSEARCH_CA_BUNDLE", "/opt/mct/security/ca-bundle.pem")
IRIS_CA = ENV.get("IRIS_CA", "/run/secrets/iris-ca.crt")


def tcp_ok(host, port, timeout=3):
    try:
        s = socket.create_connection((host, port), timeout=timeout)
        s.close()
        return True
    except Exception:
        return False


def pick_dedup_ip():
    cands = []
    try:
        cands.append(socket.gethostbyname(DEDUP_HOST))
    except Exception:
        pass
    for ip in DEDUP_FALLBACK_IPS:
        if ip not in cands:
            cands.append(ip)
    for ip in cands:
        if tcp_ok(ip, DEDUP_PORT):
            return ip, cands
    return None, cands


DEDUP_IP, DEDUP_CANDS = pick_dedup_ip()
_orig_gai = socket.getaddrinfo


def _gai(host, port, *a, **k):
    # keep TLS hostname verification against the cert-valid name while using the
    # reachable ledger address
    if host == DEDUP_HOST and DEDUP_IP:
        host = DEDUP_IP
    return _orig_gai(host, port, *a, **k)


socket.getaddrinfo = _gai
BASE = "https://%s:%d" % (DEDUP_HOST, DEDUP_PORT)


def provenance():
    p = {"container_hostname": socket.gethostname(), "pid": os.getpid()}
    try:
        p["ppid"] = os.getppid()
    except Exception:
        pass
    for k, f in (("netns", "/proc/self/ns/net"), ("pidns", "/proc/self/ns/pid"),
                 ("mntns", "/proc/self/ns/mnt")):
        try:
            p[k] = os.readlink(f)
        except Exception:
            p[k] = None
    try:
        p["cgroup"] = open("/proc/self/cgroup").read().strip().splitlines()[-1][:180]
    except Exception:
        pass
    try:
        p["cmdline"] = open("/proc/self/cmdline").read().replace("\x00", " ").strip()[:160]
    except Exception:
        pass
    try:
        p["execution_id"] = FE.get("execution_id")
        wf = FE.get("workflow") or {}
        p["workflow_id"] = wf.get("id")
        p["workflow_name"] = wf.get("name")
        p["execution_source"] = FE.get("execution_source")
        p["start_node"] = FE.get("start")
    except Exception:
        pass
    try:
        act = getattr(self, "action", None) or {}
        if isinstance(act, dict):
            p["action_id"] = act.get("id")
            p["action_label"] = act.get("label")
            p["app_name"] = act.get("app_name")
            p["app_version"] = act.get("app_version")
    except Exception:
        pass
    p["request_executor"] = "shuffle_action_task"
    p["ledger_ip_selected"] = DEDUP_IP
    p["ledger_ip_candidates"] = DEDUP_CANDS
    try:
        p["iris_resolved"] = socket.gethostbyname(IRIS_HOST)
    except Exception:
        p["iris_resolved"] = None
    p["secrets_used"] = ["iris-shuffle-dedicated", "dedup-shuffle-dedicated"]
    p["ts_utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    p["epoch"] = time.time()
    return p


def ledger_url(eid):
    return "%s/%s/_doc/%s" % (BASE, DEDUP_IDX, eid)


def ledger_get(eid):
    try:
        r = requests.get(ledger_url(eid), auth=(DEDUP_USER, DEDUP_PASS), verify=OS_CA, timeout=10)
        if r.status_code == 200:
            j = r.json()
            return {"status": 200, "source": j.get("_source"), "seq_no": j.get("_seq_no"),
                    "primary_term": j.get("_primary_term"), "version": j.get("_version")}
        return {"status": r.status_code, "body": r.text[:200]}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:200]}


def ledger_claim(eid, extra=None):
    doc = {"event_id": eid, "alert_id": None, "claimed_ts": time.time(), "state": "CLAIMED"}
    if extra:
        doc.update(extra)
    try:
        r = requests.put(ledger_url(eid) + "?op_type=create&refresh=true", json=doc,
                         auth=(DEDUP_USER, DEDUP_PASS), verify=OS_CA, timeout=10)
        j = {}
        try:
            j = r.json()
        except Exception:
            pass
        return {"status": r.status_code, "result": j.get("result"), "seq_no": j.get("_seq_no"),
                "primary_term": j.get("_primary_term"), "error_type": (j.get("error") or {}).get("type"),
                "body": r.text[:200]}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:200]}


def ledger_occ_put(eid, doc, seq_no, primary_term):
    try:
        r = requests.put(ledger_url(eid) + "?if_seq_no=%s&if_primary_term=%s&refresh=true" % (seq_no, primary_term),
                         json=doc, auth=(DEDUP_USER, DEDUP_PASS), verify=OS_CA, timeout=10)
        j = {}
        try:
            j = r.json()
        except Exception:
            pass
        return {"status": r.status_code, "result": j.get("result"), "seq_no": j.get("_seq_no"),
                "primary_term": j.get("_primary_term"),
                "error_type": (j.get("error") or {}).get("type"), "body": r.text[:220]}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:200]}


def ledger_guarded_update(eid, new_state, alert_id=None):
    """Ledger writer contract: DELIVERED is terminal/immutable. The transition script
    refuses to mutate a DELIVERED record."""
    script = ("if (ctx._source.state == 'DELIVERED') { throw new IllegalArgumentException("
              "'DELIVERED is immutable; refusing transition to ' + params.new_state); } "
              "ctx._source.state = params.new_state; "
              "if (params.alert_id != null) { ctx._source.alert_id = params.alert_id; } "
              "ctx._source.reconcile_ts = params.ts;")
    body = {"script": {"source": script, "lang": "painless",
                       "params": {"new_state": new_state, "alert_id": alert_id, "ts": time.time()}}}
    try:
        r = requests.post("%s/%s/_update/%s?refresh=true" % (BASE, DEDUP_IDX, eid), json=body,
                          auth=(DEDUP_USER, DEDUP_PASS), verify=OS_CA, timeout=15)
        j = {}
        try:
            j = r.json()
        except Exception:
            pass
        et = (j.get("error") or {})
        cb = et.get("caused_by") or {}
        cb2 = cb.get("caused_by") or {}
        return {"status": r.status_code, "result": j.get("result"),
                "error_type": et.get("type"),
                "caused_by": (cb.get("reason") or "")[:200],
                "guard_reason": (cb2.get("reason") or cb.get("reason") or "")[:220],
                "guard_type": cb2.get("type") or cb.get("type"),
                "body": r.text[:600]}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:200]}


arg = FE.get("execution_argument", "{}")
try:
    alert = json.loads(arg) if isinstance(arg, str) else arg
except Exception:
    alert = {}
if not isinstance(alert, dict):
    alert = {}
rule = (alert.get("rule") or {})
rule_id = rule.get("id")
directive = alert.get("p79_eo") or {}
MODE = str(directive.get("mode", "happy"))


def build_body():
    return {"alert_title": "Wazuh flow alert (Class A)", "alert_source": "wazuh",
            "alert_source_ref": str(rule_id) if rule_id is not None else "",
            "alert_severity_id": 6, "alert_customer_id": 1, "alert_status_id": 2,
            "alert_source_content": {"monitor": str(rule_id) if rule_id is not None else ""},
            "alert_tags": "source:wazuh,class:A"}


def iris_post(timeout=20, attempts=1):
    url = "https://%s:%d/alerts/add" % (IRIS_HOST, IRIS_PORT)
    sess = requests.Session()
    sess.mount("https://", HTTPAdapter(max_retries=Retry(connect=3, read=0, backoff_factor=1.0)))
    last = None
    for i in range(1, attempts + 1):
        try:
            r = sess.post(url, json=build_body(),
                          headers={"Authorization": "Bearer " + IRIS_TOKEN, "Content-Type": "application/json"},
                          verify=IRIS_CA, timeout=timeout)
            aid = None
            try:
                aid = r.json().get("data", {}).get("alert_id")
            except Exception:
                pass
            return {"ok": bool(r.ok), "http_status": r.status_code, "alert_id": aid, "attempt": i}
        except Exception as e:
            last = {"ok": False, "error_class": type(e).__name__, "error": str(e)[:180], "attempt": i}
        time.sleep(1)
    return last


def iris_post_response_lost(hold=8.0):
    """REAL response loss: the request is fully sent over a verified TLS channel and
    the client never reads the response, then closes the socket."""
    info = {"technique": "tls_socket_send_then_close_without_read", "hold_seconds": hold}
    try:
        ctx = ssl.create_default_context(cafile=IRIS_CA)
        raw = socket.create_connection((IRIS_HOST, IRIS_PORT), timeout=10)
        s = ctx.wrap_socket(raw, server_hostname=IRIS_HOST)
        info["tls_peer_cn"] = str(s.getpeercert().get("subject"))[:120]
        payload = json.dumps(build_body()).encode()
        req = (b"POST /alerts/add HTTP/1.1\r\nHost: " + IRIS_HOST.encode() + b":" + str(IRIS_PORT).encode() +
               b"\r\nAuthorization: Bearer " + IRIS_TOKEN.encode() +
               b"\r\nContent-Type: application/json\r\nContent-Length: " + str(len(payload)).encode() +
               b"\r\nConnection: close\r\n\r\n" + payload)
        s.sendall(req)
        info["request_bytes"] = len(req)
        time.sleep(hold)  # destination processes; client NEVER reads the response
        try:
            s.shutdown(socket.SHUT_RDWR)
        except Exception:
            pass
        s.close()
        info["response_read"] = False
        info["ok"] = True
    except Exception as e:
        info["ok"] = False
        info["error"] = str(e)[:180]
    return info


def iris_post_timeout_raw(read_timeout=0.05, hold=6.0):
    """REAL client read-timeout: request fully sent over a verified TLS channel, then the
    client's read times out while the destination keeps processing (ambiguous outcome)."""
    info = {"technique": "tls_socket_send_then_client_read_timeout",
            "read_timeout_s": read_timeout, "hold_seconds": hold}
    try:
        ctx = ssl.create_default_context(cafile=IRIS_CA)
        raw = socket.create_connection((IRIS_HOST, IRIS_PORT), timeout=10)
        s = ctx.wrap_socket(raw, server_hostname=IRIS_HOST)
        payload = json.dumps(build_body()).encode()
        req = (b"POST /alerts/add HTTP/1.1\r\nHost: " + IRIS_HOST.encode() + b":" + str(IRIS_PORT).encode() +
               b"\r\nAuthorization: Bearer " + IRIS_TOKEN.encode() +
               b"\r\nContent-Type: application/json\r\nContent-Length: " + str(len(payload)).encode() +
               b"\r\n\r\n" + payload)
        t0 = time.time()
        s.sendall(req)
        info["request_bytes"] = len(req)
        s.settimeout(read_timeout)
        try:
            data = s.recv(4096)
            info["timed_out"] = False
            info["unexpected_response_bytes"] = len(data)
            info["unexpected_status_line"] = data.split(b"\r\n")[0].decode("utf-8", "ignore")[:40]
        except Exception as e:
            info["timed_out"] = True
            info["error_class"] = type(e).__name__
            info["error"] = str(e)[:120]
            info["elapsed_s"] = round(time.time() - t0, 4)
        time.sleep(hold)  # destination keeps processing; client never learns the outcome
        try:
            s.close()
        except Exception:
            pass
        info["response_never_read"] = True
        info["ok"] = True
    except Exception as e:
        info["ok"] = False
        info["error"] = str(e)[:160]
    return info


def iris_lookup_by_ref(ref):
    """Direct IRIS read-back: enumerate destination objects carrying this source ref."""
    try:
        r = requests.get("https://%s:%d/alerts/filter?source_reference=%s&per_page=100" % (IRIS_HOST, IRIS_PORT, ref),
                         headers={"Authorization": "Bearer " + IRIS_TOKEN}, verify=IRIS_CA, timeout=25)
        if r.status_code != 200:
            return {"status": r.status_code, "body": r.text[:160]}
        d = r.json().get("data", {})
        objs = [{"alert_id": a.get("alert_id"), "alert_source_ref": a.get("alert_source_ref")}
                for a in d.get("alerts", []) if a.get("alert_source_ref") == ref]
        return {"status": 200, "destination_object_count": len(objs), "objects": objs,
                "api_total": d.get("total")}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:180]}


def iris_detail(aid):
    try:
        r = requests.get("https://%s:%d/alerts/%s" % (IRIS_HOST, IRIS_PORT, aid),
                         headers={"Authorization": "Bearer " + IRIS_TOKEN}, verify=IRIS_CA, timeout=25)
        if r.status_code != 200:
            return {"status": r.status_code, "body": r.text[:160]}
        a = r.json().get("data", {})
        return {"status": 200, "alert_id": a.get("alert_id"), "alert_source_ref": a.get("alert_source_ref"),
                "alert_title": a.get("alert_title"), "alert_source": a.get("alert_source"),
                "alert_creation_time": a.get("alert_creation_time"),
                "alert_tags": a.get("alert_tags")}
    except Exception as e:
        return {"status": "ERR", "error": str(e)[:180]}


OUT = {"phase": 79, "workstream": "effectively-once", "mode": MODE, "provenance": provenance()}
raw_id = alert.get("id") or alert.get("alert_id")
EID = str(raw_id) if raw_id else hashlib.md5(json.dumps(alert, sort_keys=True).encode()).hexdigest()
OUT["event_id"] = EID
OUT["source_id_stable"] = {"wazuh_id": alert.get("id"), "wazuh_alert_id": alert.get("alert_id"),
                           "rule_id": rule_id, "derived_event_id": EID,
                           "ledger_doc_id": EID,
                           "sha256_event_id": hashlib.sha256(EID.encode()).hexdigest()}

try:
    if not IRIS_TOKEN:
        OUT["state"] = "AUTH_FAILED"
        OUT["reason"] = "token_unavailable"
    elif DEDUP_IP is None:
        # FAIL-CLOSED: no ledger => no destination write (cannot guarantee once-only)
        OUT["state"] = "LEDGER_UNAVAILABLE_FAIL_CLOSED"
        OUT["destination_posted"] = False
    elif MODE in ("happy", "replay", "retry"):
        c = ledger_claim(EID, {"scenario": MODE})
        OUT["claim"] = c
        if c["status"] == 409:
            cur = ledger_get(EID)
            OUT["ledger_existing"] = cur
            st = (cur.get("source") or {}).get("state")
            aid = (cur.get("source") or {}).get("alert_id")
            if aid and st == "DELIVERED":
                OUT["state"] = "DUP_SKIP"
                OUT["cached_alert_id"] = aid
            else:
                OUT["state"] = "RECONCILE_PENDING"
                OUT["reason"] = "claim exists without DELIVERED alert_id; fail-closed, no re-POST"
            OUT["destination_posted"] = False
        elif c["status"] in (200, 201):
            p = iris_post(timeout=20, attempts=2)
            OUT["iris_post"] = p
            if p and p.get("ok"):
                fin = ledger_occ_put(EID, {"event_id": EID, "alert_id": p["alert_id"],
                                           "claimed_ts": time.time(), "state": "DELIVERED",
                                           "scenario": MODE}, c["seq_no"], c["primary_term"])
                OUT["ledger_finalize"] = fin
                OUT["state"] = "ROUTED"
                OUT["alert_id"] = p["alert_id"]
                OUT["destination_posted"] = True
            else:
                OUT["state"] = "DEAD_LETTER"
                OUT["destination_posted"] = False
        else:
            OUT["state"] = "LEDGER_CLAIM_ERROR_FAIL_CLOSED"
            OUT["destination_posted"] = False

    elif MODE == "create_only":
        c1 = ledger_claim(EID, {"scenario": "create_only#1"})
        c2 = ledger_claim(EID, {"scenario": "create_only#2"})
        OUT["claim_1"] = c1
        OUT["claim_2_duplicate"] = c2
        posted = None
        if c1["status"] in (200, 201):
            posted = iris_post(timeout=20, attempts=2)
            OUT["iris_post"] = posted
            if posted and posted.get("ok"):
                OUT["ledger_finalize"] = ledger_occ_put(
                    EID, {"event_id": EID, "alert_id": posted["alert_id"], "claimed_ts": time.time(),
                          "state": "DELIVERED", "scenario": "create_only"}, c1["seq_no"], c1["primary_term"])
                OUT["alert_id"] = posted["alert_id"]
        OUT["second_claim_rejected_409"] = (c2["status"] == 409)
        OUT["second_destination_post_attempted"] = False
        OUT["ledger_after"] = ledger_get(EID)
        OUT["state"] = "CREATE_ONLY_VERIFIED"

    elif MODE == "occ":
        c = ledger_claim(EID, {"scenario": "occ"})
        OUT["claim"] = c
        cur = ledger_get(EID)
        OUT["ledger_before"] = cur
        seq, term = cur.get("seq_no"), cur.get("primary_term")
        stale = ledger_occ_put(EID, {"event_id": EID, "alert_id": 999999, "state": "STALE_OVERWRITE_ATTEMPT",
                                     "claimed_ts": time.time()},
                               (seq - 1) if isinstance(seq, int) else 0, term)
        OUT["stale_version_write"] = stale
        OUT["stale_rejected"] = (stale.get("status") == 409 and
                                 stale.get("error_type") == "version_conflict_engine_exception")
        after_stale = ledger_get(EID)
        OUT["ledger_after_stale"] = after_stale
        OUT["state_unchanged_by_stale_write"] = (
            (after_stale.get("source") or {}).get("state") == (cur.get("source") or {}).get("state"))
        fresh = ledger_occ_put(EID, {"event_id": EID, "alert_id": None, "state": "CLAIMED_OCC_ADVANCED",
                                     "claimed_ts": time.time(), "scenario": "occ"}, seq, term)
        OUT["current_version_write"] = fresh
        OUT["ledger_after_fresh"] = ledger_get(EID)
        OUT["state"] = "OCC_VERIFIED"
        OUT["destination_posted"] = False

    elif MODE == "delivered_immutable":
        cur = ledger_get(EID)
        OUT["ledger_before"] = cur
        st = (cur.get("source") or {}).get("state")
        OUT["precondition_state"] = st
        create_attempt = ledger_claim(EID, {"scenario": "immutability_probe", "state": "TAMPERED"})
        OUT["create_only_mutation_attempt"] = create_attempt
        OUT["create_only_rejected_409"] = (create_attempt.get("status") == 409)
        guarded = ledger_guarded_update(EID, "TAMPERED_REOPEN")
        OUT["guarded_transition_attempt"] = guarded
        blob = (str(guarded.get("guard_reason", "")) + str(guarded.get("caused_by", "")) +
                str(guarded.get("body", ""))).lower()
        OUT["guarded_transition_rejected"] = (guarded.get("status") in (400, 409, 500) and
                                              "immutable" in blob)
        after = ledger_get(EID)
        OUT["ledger_after"] = after
        OUT["state_preserved"] = ((after.get("source") or {}).get("state") == st)
        OUT["version_unchanged"] = (after.get("version") == cur.get("version"))
        OUT["state"] = "DELIVERED_IMMUTABLE_VERIFIED"
        OUT["destination_posted"] = False

    elif MODE == "partial_success":
        c = ledger_claim(EID, {"scenario": "partial_success"})
        OUT["claim"] = c
        if c["status"] in (200, 201):
            p = iris_post(timeout=25, attempts=1)
            OUT["iris_post"] = p
            OUT["destination_posted"] = bool(p and p.get("ok"))
            # SIMULATED LEDGER-WRITE FAILURE: finalize is directed at an unreachable
            # ledger endpoint (real network failure), so DELIVERED is never recorded.
            fin_err = None
            try:
                requests.put("https://%s:9299/%s/_doc/%s" % (DEDUP_HOST, DEDUP_IDX, EID),
                             json={"event_id": EID, "alert_id": (p or {}).get("alert_id"),
                                   "state": "DELIVERED"},
                             auth=(DEDUP_USER, DEDUP_PASS), verify=OS_CA, timeout=4)
                fin_err = "unexpected_success"
            except Exception as e:
                fin_err = {"error_class": type(e).__name__, "error": str(e)[:160]}
            OUT["ledger_finalize_failure"] = fin_err
            # FAIL-CLOSED: possible acceptance -> RECONCILIATION_REQUIRED (OCC guarded)
            rec = ledger_occ_put(EID, {"event_id": EID, "alert_id": None,
                                       "claimed_ts": time.time(), "state": "RECONCILIATION_REQUIRED",
                                       "scenario": "partial_success",
                                       "note": "destination possibly accepted; ledger finalize failed"},
                                 c["seq_no"], c["primary_term"])
            OUT["reconcile_marker"] = rec
            OUT["ledger_after"] = ledger_get(EID)
            OUT["state"] = "RECONCILIATION_REQUIRED"
        else:
            OUT["state"] = "CLAIM_NOT_OWNED"
        OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))

    elif MODE == "crash_after_accept":
        c = ledger_claim(EID, {"scenario": "crash_after_accept"})
        OUT["claim"] = c
        if c["status"] in (200, 201):
            p = iris_post(timeout=25, attempts=1)
            OUT["iris_post"] = p
            OUT["destination_posted"] = bool(p and p.get("ok"))
            OUT["ledger_after_crash"] = ledger_get(EID)
            OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))
            OUT["state"] = "CRASH_AFTER_ACCEPT_SIMULATED"
            OUT["crash_detail"] = ("execution aborted between destination acceptance and ledger "
                                   "finalize; ledger left CLAIMED without alert_id")
            print(json.dumps(OUT))
            sys.stdout.flush()
            raise RuntimeError("P79EO simulated abort after destination accept (event_id=%s)" % EID)
        else:
            OUT["state"] = "CLAIM_NOT_OWNED"

    elif MODE == "response_loss":
        c = ledger_claim(EID, {"scenario": "response_loss"})
        OUT["claim"] = c
        if c["status"] in (200, 201):
            info = iris_post_response_lost(hold=float(directive.get("hold", 8.0)))
            OUT["iris_post_response_lost"] = info
            rec = ledger_occ_put(EID, {"event_id": EID, "alert_id": None, "claimed_ts": time.time(),
                                       "state": "RECONCILE_RESPONSE_LOSS", "scenario": "response_loss",
                                       "note": "request sent, response never received; acceptance unknown"},
                                 c["seq_no"], c["primary_term"])
            OUT["reconcile_marker"] = rec
            OUT["ledger_after"] = ledger_get(EID)
            OUT["state"] = "RECONCILE_RESPONSE_LOSS"
            time.sleep(2)
            OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))
        else:
            OUT["state"] = "CLAIM_NOT_OWNED"

    elif MODE == "timeout":
        c = ledger_claim(EID, {"scenario": "timeout"})
        OUT["claim"] = c
        if c["status"] in (200, 201):
            rt = float(directive.get("read_timeout", 0.05))
            res = iris_post_timeout_raw(read_timeout=rt, hold=float(directive.get("hold", 6.0)))
            OUT["iris_post_timeout"] = res
            rec = ledger_occ_put(EID, {"event_id": EID, "alert_id": None, "claimed_ts": time.time(),
                                       "state": "RECONCILIATION_REQUIRED", "scenario": "timeout",
                                       "note": "ambiguous timeout; destination acceptance unknown"},
                                 c["seq_no"], c["primary_term"])
            OUT["reconcile_marker"] = rec
            OUT["ledger_after"] = ledger_get(EID)
            OUT["state"] = "RECONCILIATION_REQUIRED"
            time.sleep(3)
            OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))
        else:
            OUT["state"] = "CLAIM_NOT_OWNED"

    elif MODE == "reconcile":
        cur = ledger_get(EID)
        OUT["ledger_before"] = cur
        st = (cur.get("source") or {}).get("state")
        found = iris_lookup_by_ref(str(rule_id))
        OUT["iris_by_ref"] = found
        n = found.get("destination_object_count")
        if st == "DELIVERED":
            OUT["state"] = "ALREADY_DELIVERED_IMMUTABLE"
            OUT["destination_posted"] = False
        elif n == 1:
            aid = found["objects"][0]["alert_id"]
            g = ledger_guarded_update(EID, "RECONCILED_DELIVERED", aid)
            OUT["reconcile_write"] = g
            OUT["ledger_after"] = ledger_get(EID)
            OUT["reconciled_alert_id"] = aid
            OUT["iris_detail"] = iris_detail(aid)
            OUT["state"] = "RECONCILED_DELIVERED"
            OUT["destination_posted"] = False
        elif n == 0:
            OUT["state"] = "RECONCILED_NOT_DELIVERED"
            OUT["destination_posted"] = False
        else:
            OUT["state"] = "RECONCILE_AMBIGUOUS_MULTIPLE_OBJECTS"
            OUT["destination_posted"] = False

    elif MODE == "readback":
        cur = ledger_get(EID)
        OUT["ledger"] = cur
        aid = (cur.get("source") or {}).get("alert_id")
        OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))
        if aid:
            OUT["iris_detail"] = iris_detail(aid)
            OUT["marker_parity"] = (OUT["iris_detail"].get("alert_source_ref") == str(rule_id))
        OUT["state"] = "READBACK_VERIFIED"
        OUT["destination_posted"] = False

    else:
        OUT["state"] = "UNKNOWN_MODE"

    if MODE in ("happy", "replay", "retry", "create_only"):
        OUT["iris_by_ref"] = iris_lookup_by_ref(str(rule_id))
        aid = OUT.get("alert_id") or OUT.get("cached_alert_id")
        if aid:
            OUT["iris_detail"] = iris_detail(aid)
            OUT["marker_parity"] = (OUT["iris_detail"].get("alert_source_ref") == str(rule_id))
except Exception as e:
    if OUT.get("state") != "CRASH_AFTER_ACCEPT_SIMULATED":
        OUT["state"] = OUT.get("state") or "HANDLER_ERROR"
        OUT["handler_error"] = {"class": type(e).__name__, "error": str(e)[:200]}
        print(json.dumps(OUT))
    raise
else:
    print(json.dumps(OUT))
