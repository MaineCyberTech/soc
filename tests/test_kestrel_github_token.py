from __future__ import annotations

import contextlib
import datetime as dt
import http.server
import importlib.machinery
import importlib.util
import io
import json
import os
import socket
import stat
import tempfile
import threading
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
HELPER_PATH = ROOT / "scripts" / "kestrel-github-token.py"
LOADER = importlib.machinery.SourceFileLoader("soc_kestrel_github_token", str(HELPER_PATH))
SPEC = importlib.util.spec_from_loader("soc_kestrel_github_token", LOADER)
assert SPEC is not None and SPEC.loader is not None
helper = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(helper)

UTC = dt.timezone.utc
TOKEN = "ghs_test_installation_token_do_not_log"
AUDIT_ID = "audit-test-0001"


def future_expiry(hours: int = 1) -> str:
    value = dt.datetime.now(UTC) + dt.timedelta(hours=hours)
    return value.isoformat().replace("+00:00", "Z")


def past_expiry(hours: int = 1) -> str:
    value = dt.datetime.now(UTC) - dt.timedelta(hours=hours)
    return value.isoformat().replace("+00:00", "Z")


def near_expiry(minutes: int = 2) -> str:
    value = dt.datetime.now(UTC) + dt.timedelta(minutes=minutes)
    return value.isoformat().replace("+00:00", "Z")


def good_payload(**overrides):
    payload = {
        "token": TOKEN,
        "expires_at": future_expiry(),
        "cached": False,
        "installation_id": 12345678,
        "audit_id": AUDIT_ID,
    }
    payload.update(overrides)
    return payload


class FakeBroker:
    def __init__(self, status: int = 200, payload=None, body: bytes | None = None):
        self.status = status
        self.payload = good_payload() if payload is None else payload
        self.body = body
        self.requests: list[dict] = []
        self.headers: list[dict] = []
        owner = self

        class Handler(http.server.BaseHTTPRequestHandler):
            def do_POST(self):  # noqa: N802 - stdlib callback name
                length = int(self.headers.get("Content-Length", "0"))
                raw = self.rfile.read(length)
                try:
                    request_body = json.loads(raw.decode("utf-8"))
                except ValueError:
                    request_body = {"invalid": True}
                owner.requests.append(request_body)
                owner.headers.append(dict(self.headers))
                body = owner.body
                if body is None:
                    body = json.dumps(owner.payload).encode("utf-8")
                self.send_response(owner.status)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)

            def log_message(self, *_args):
                return

        self.server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)

    @property
    def url(self) -> str:
        host, port = self.server.server_address[:2]
        return f"http://{host}:{port}"

    def __enter__(self):
        self.thread.start()
        return self

    def __exit__(self, *_args):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=5)


class HelperTestCase(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.dir = Path(self.temp.name)
        self.token_file = self.dir / "broker-token"
        self.cache_file = self.dir / "cache.json"
        self.write_token_file()

    def write_token_file(self, value: str = "kbt_test_consumer_token", mode: int = 0o600):
        self.token_file.write_text(value + "\n", encoding="utf-8")
        os.chmod(self.token_file, mode)

    def run_main(self, *args, env: dict | None = None):
        out = io.StringIO()
        err = io.StringIO()
        environment = {
            "KESTREL_GITHUB_APP": "test-app",
            "KESTREL_BROKER_URL": "http://127.0.0.1:1",
            "KESTREL_BROKER_TOKEN_FILE": str(self.token_file),
            "KESTREL_GITHUB_TOKEN_CACHE": str(self.cache_file),
        }
        if env:
            environment.update(env)
        with mock.patch.dict(os.environ, environment, clear=True):
            with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
                code = helper.main(list(args))
        return code, out.getvalue(), err.getvalue()

    def base_args(self, broker_url: str):
        return [
            "--app",
            "test-app",
            "--broker-url",
            broker_url,
            "--token-file",
            str(self.token_file),
            "--cache-file",
            str(self.cache_file),
        ]

    def read_cache(self):
        return json.loads(self.cache_file.read_text(encoding="utf-8"))

    def assert_no_token(self, *values: str):
        for value in values:
            self.assertNotIn(TOKEN, value)


class SuccessAndCacheTests(HelperTestCase):
    def test_success_issues_and_caches_without_printing_token(self):
        with FakeBroker() as broker:
            code, out, err = self.run_main(*self.base_args(broker.url), "--format", "json")
        self.assertEqual(code, 0, err)
        self.assertEqual(len(broker.requests), 1)
        self.assertEqual(broker.requests[0], {"provider": "github", "app": "test-app"})
        self.assertEqual(broker.headers[0]["Authorization"], "Bearer kbt_test_consumer_token")
        self.assert_no_token(out, err)
        payload = json.loads(out)
        self.assertEqual(payload["provider"], "github")
        self.assertEqual(payload["app"], "test-app")
        self.assertEqual(payload["installation_id"], 12345678)
        self.assertEqual(payload["audit_id"], AUDIT_ID)
        self.assertFalse(payload["cache_hit"])
        self.assertNotIn("token", payload)

        cached = self.read_cache()
        self.assertEqual(cached["token"], TOKEN)
        self.assertEqual(stat.S_IMODE(self.cache_file.stat().st_mode), 0o600)
        self.assertFalse(self.cache_file.is_symlink())

    def test_cache_hit_does_not_call_broker(self):
        with FakeBroker() as broker:
            first = self.run_main(*self.base_args(broker.url), "--format", "json")
            second = self.run_main(*self.base_args(broker.url), "--format", "json")
        self.assertEqual(first[0], 0, first[2])
        self.assertEqual(second[0], 0, second[2])
        self.assertEqual(len(broker.requests), 1)
        payload = json.loads(second[1])
        self.assertTrue(payload["cache_hit"])
        self.assert_no_token(second[1], second[2])

    def test_expired_cache_is_refreshed(self):
        expired = {
            "token": "ghs_old_token",
            "expires_at": past_expiry(),
            "installation_id": 12345678,
            "cached": False,
            "audit_id": "old-audit",
            "app": "test-app",
            "broker_url": "http://127.0.0.1:1",
        }
        helper.write_cache(self.cache_file, expired)
        with FakeBroker() as broker:
            # The cached record was written for a different broker URL, so this
            # also verifies refresh after a broker/cache identity change.
            code, out, err = self.run_main(*self.base_args(broker.url), "--format", "json")
        self.assertEqual(code, 0, err)
        self.assertEqual(len(broker.requests), 1)
        self.assertFalse(json.loads(out)["cache_hit"])
        self.assertEqual(self.read_cache()["token"], TOKEN)

    def test_cache_inside_safety_margin_is_refreshed(self):
        near = {
            "token": "ghs_old_token",
            "expires_at": near_expiry(2),
            "installation_id": 12345678,
            "cached": False,
            "audit_id": "old-audit",
            "app": "test-app",
        }
        helper.write_cache(self.cache_file, near)
        with FakeBroker() as broker:
            code, out, err = self.run_main(*self.base_args(broker.url), "--format", "json")
        self.assertEqual(code, 0, err)
        self.assertEqual(len(broker.requests), 1)
        self.assertFalse(json.loads(out)["cache_hit"])
        self.assertEqual(self.read_cache()["token"], TOKEN)

    def test_print_token_outputs_only_the_token(self):
        with FakeBroker() as broker:
            code, out, err = self.run_main(
                *self.base_args(broker.url), "--format", "text", "--print-token"
            )
        self.assertEqual(code, 0, err)
        self.assertEqual(out, TOKEN + "\n")
        self.assert_no_token(err)

    def test_json_print_token_includes_token_only_on_request(self):
        with FakeBroker() as broker:
            code, out, err = self.run_main(
                *self.base_args(broker.url), "--format", "json", "--print-token"
            )
        self.assertEqual(code, 0, err)
        payload = json.loads(out)
        self.assertEqual(payload["token"], TOKEN)
        self.assert_no_token(err)

    def test_dry_run_does_not_contact_broker_or_write_cache(self):
        with FakeBroker() as broker:
            code, out, err = self.run_main(
                *self.base_args(broker.url), "--dry-run", "--format", "json", "--print-token"
            )
        self.assertEqual(code, 0, err)
        self.assertEqual(broker.requests, [])
        self.assertFalse(self.cache_file.exists())
        payload = json.loads(out)
        self.assertTrue(payload["dry_run"])
        self.assertNotIn("token", payload)
        self.assert_no_token(out, err)


class ResponseValidationTests(HelperTestCase):
    def test_expired_response_is_rejected_without_leaking_token(self):
        with FakeBroker(payload=good_payload(expires_at=past_expiry())) as broker:
            code, out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assert_no_token(out, err)
        self.assertFalse(self.cache_file.exists())

    def test_token_inside_safety_margin_is_used_but_not_cached(self):
        with FakeBroker(payload=good_payload(expires_at=near_expiry(2))) as broker:
            code, out, err = self.run_main(
                *self.base_args(broker.url), "--format", "json"
            )
        self.assertEqual(code, 0, err)
        self.assertEqual(len(broker.requests), 1)
        self.assertFalse(self.cache_file.exists())
        self.assertFalse(json.loads(out)["cache_hit"])
        self.assert_no_token(out, err)

    def test_missing_installation_id_is_rejected(self):
        payload = good_payload()
        payload.pop("installation_id")
        with FakeBroker(payload=payload) as broker:
            code, out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assert_no_token(out, err)

    def test_invalid_installation_id_is_rejected(self):
        for bad_value in (0, "", "not-a-number", None):
            with self.subTest(value=bad_value):
                with FakeBroker(payload=good_payload(installation_id=bad_value)) as broker:
                    code, out, err = self.run_main(*self.base_args(broker.url))
                self.assertEqual(code, 3)
                self.assert_no_token(out, err)

    def test_empty_token_is_rejected(self):
        with FakeBroker(payload=good_payload(token="")) as broker:
            code, out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assert_no_token(out, err)

    def test_malformed_json_and_oversized_body_are_rejected(self):
        with FakeBroker(body=b"{not-json") as broker:
            code, _out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assertIn("invalid JSON", err)
        with FakeBroker(body=b"x" * (helper.MAX_RESPONSE_BYTES + 1)) as broker:
            code, _out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assertIn("oversized", err)

    def test_broker_denial_does_not_leak_response_body(self):
        body = json.dumps({"token": TOKEN, "error": "denied"}).encode()
        with FakeBroker(status=403, body=body) as broker:
            code, out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 3)
        self.assertIn("HTTP 403", err)
        self.assert_no_token(out, err)


class FileSafetyTests(HelperTestCase):
    def test_token_file_with_loose_mode_is_rejected(self):
        self.write_token_file(mode=0o644)
        with FakeBroker() as broker:
            code, out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 2)
        self.assertEqual(broker.requests, [])
        self.assertIn("0600", err)
        self.assert_no_token(out, err)

    def test_token_file_symlink_is_rejected(self):
        target = self.dir / "real-token"
        target.write_text("kbt_test_consumer_token\n", encoding="utf-8")
        os.chmod(target, 0o600)
        self.token_file.unlink()
        self.token_file.symlink_to(target)
        with FakeBroker() as broker:
            code, _out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 2)
        self.assertEqual(broker.requests, [])
        self.assertIn("symlink", err)

    def test_token_file_not_regular_is_rejected(self):
        self.token_file.unlink()
        self.token_file.mkdir()
        with FakeBroker() as broker:
            code, _out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 2)
        self.assertEqual(broker.requests, [])
        self.assertIn("regular file", err)

    def test_cache_symlink_is_rejected(self):
        target = self.dir / "real-cache.json"
        target.write_text("{}", encoding="utf-8")
        os.chmod(target, 0o600)
        self.cache_file.symlink_to(target)
        with FakeBroker() as broker:
            code, _out, err = self.run_main(*self.base_args(broker.url))
        self.assertEqual(code, 4)
        self.assertEqual(broker.requests, [])
        self.assertIn("symlink", err)

    def test_pat_environment_is_not_used(self):
        self.token_file.unlink()
        with FakeBroker() as broker:
            code, _out, err = self.run_main(
                *self.base_args(broker.url),
                env={"GH_PAT": "pat_must_not_be_used", "GITHUB_TOKEN": "token_must_not_be_used"},
            )
        self.assertEqual(code, 2)
        self.assertEqual(broker.requests, [])
        self.assertIn("does not exist", err)
        self.assertNotIn("pat_must_not_be_used", err)


class AtomicAndFailureTests(HelperTestCase):
    def test_atomic_cache_write_preserves_old_file_on_replace_failure(self):
        old = {"token": "ghs_old", "expires_at": future_expiry(), "installation_id": 1}
        helper.write_cache(self.cache_file, old)
        before = self.cache_file.read_bytes()
        with mock.patch.object(helper.os, "replace", side_effect=OSError(5, "I/O error")):
            with self.assertRaises(helper.CacheError):
                helper.write_cache(self.cache_file, {"token": "ghs_new"})
        self.assertEqual(self.cache_file.read_bytes(), before)
        self.assertEqual(stat.S_IMODE(self.cache_file.stat().st_mode), 0o600)
        self.assertEqual(
            [p.name for p in self.dir.iterdir() if p.name.startswith(".cache.json.")], []
        )

    def test_unavailable_broker_fails_closed(self):
        socket_file = socket.socket()
        socket_file.bind(("127.0.0.1", 0))
        port = socket_file.getsockname()[1]
        socket_file.close()
        code, out, err = self.run_main(
            "--app",
            "test-app",
            "--broker-url",
            f"http://127.0.0.1:{port}",
            "--token-file",
            str(self.token_file),
            "--cache-file",
            str(self.cache_file),
            "--timeout",
            "1",
        )
        self.assertEqual(code, 3)
        self.assertIn("unavailable", err)
        self.assertFalse(self.cache_file.exists())
        self.assert_no_token(out, err)


class WrapperTests(HelperTestCase):
    def test_gh_wrapper_passes_token_as_environment_not_output(self):
        import subprocess

        fake_bin = self.dir / "bin"
        fake_bin.mkdir()
        capture = self.dir / "gh-token.txt"
        fake_gh = fake_bin / "gh"
        fake_gh.write_text(
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n"
            f"printf '%s' \"${{GH_TOKEN:-}}\" > {str(capture)!r}\n"
            "echo gh-ok\n",
            encoding="utf-8",
        )
        os.chmod(fake_gh, 0o755)
        with FakeBroker() as broker:
            environment = {
                "PATH": str(fake_bin) + os.pathsep + os.environ.get("PATH", ""),
                "KESTREL_GITHUB_APP": "test-app",
                "KESTREL_BROKER_URL": broker.url,
                "KESTREL_BROKER_TOKEN_FILE": str(self.token_file),
                "KESTREL_GITHUB_TOKEN_CACHE": str(self.cache_file),
            }
            result = subprocess.run(
                [str(ROOT / "scripts" / "gh-broker.sh"), "release", "list"],
                env=environment,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
            )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), "gh-ok")
        self.assertEqual(capture.read_text(encoding="utf-8"), TOKEN)
        self.assert_no_token(result.stdout, result.stderr)


if __name__ == "__main__":
    unittest.main()
