#!/usr/bin/env python3
"""Mint and cache a short-lived GitHub App token from the Kestrel broker.

The SOC host holds one dedicated Kestrel broker token in a root-only file. This
helper sends that token to the Kestrel token broker, validates the GitHub App
installation token response, and caches the installation token with a five-minute
safety margin. It never reads or writes a GitHub personal access token.

Default output is metadata only. The token is printed only when the caller
explicitly passes ``--print-token``.

Exit codes:
  0  success
  2  configuration/token-file problem (including unsafe file mode or symlink)
  3  broker unavailable, denied, or returned an invalid response
  4  cache file or cache write problem
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import stat
import sys
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

DEFAULT_BROKER_URL = "http://192.168.222.225:8090"
DEFAULT_BROKER_TOKEN_FILE = "/etc/soc/kestrel-broker-token-github"
DEFAULT_CACHE_DIR = "/run/soc"
DEFAULT_TIMEOUT = 20.0
MAX_RESPONSE_BYTES = 64 * 1024
MAX_SECRET_FILE_BYTES = 8 * 1024
SAFETY_MARGIN = dt.timedelta(minutes=5)
ALIAS_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$")
WHITESPACE_RE = re.compile(r"\s")


class KestrelTokenError(Exception):
    """Base class for safe, token-free error messages."""

    exit_code = 1


class ConfigError(KestrelTokenError):
    exit_code = 2


class BrokerError(KestrelTokenError):
    exit_code = 3


class CacheError(KestrelTokenError):
    exit_code = 4


class _NoRedirect(urllib.request.HTTPRedirectHandler):
    """Do not follow redirects, so the Authorization header cannot be replayed."""

    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def _utcnow() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc)


def _parse_expires_at(value: object) -> dt.datetime:
    if not isinstance(value, str) or not value.strip():
        raise BrokerError("broker response has no expires_at")
    text = value.strip()
    if text.endswith(("Z", "z")):
        text = text[:-1] + "+00:00"
    try:
        parsed = dt.datetime.fromisoformat(text)
    except ValueError:
        raise BrokerError("broker response has an invalid expires_at") from None
    if parsed.tzinfo is None:
        raise BrokerError("broker response expires_at has no timezone")
    return parsed.astimezone(dt.timezone.utc)


def _canonical_timestamp(value: dt.datetime) -> str:
    return value.astimezone(dt.timezone.utc).isoformat().replace("+00:00", "Z")


def validate_issue_response(
    payload: object,
    *,
    now: dt.datetime | None = None,
    safety_margin: dt.timedelta = dt.timedelta(0),
) -> dict:
    """Validate a broker GitHub issue response.

    The returned mapping contains only normalised, non-secret metadata plus the
    token. Callers must keep the token out of logs and default output. A broker
    response must be in the future; cache validation passes the five-minute
    safety margin separately.
    """
    if not isinstance(payload, dict):
        raise BrokerError("broker returned an invalid response")

    token = payload.get("token")
    if not isinstance(token, str) or not token.strip():
        raise BrokerError("broker response has no GitHub token")
    token = token.strip()
    if WHITESPACE_RE.search(token):
        raise BrokerError("broker response token contains whitespace")

    expires = _parse_expires_at(payload.get("expires_at"))
    current = now or _utcnow()
    if expires <= current + safety_margin:
        raise BrokerError("broker response token is expired or too close to expiry")

    installation_id = payload.get("installation_id")
    if isinstance(installation_id, bool):
        raise BrokerError("broker response has an invalid installation_id")
    if isinstance(installation_id, int):
        if installation_id <= 0:
            raise BrokerError("broker response has an invalid installation_id")
        installation_value: int | str = installation_id
    elif isinstance(installation_id, str):
        candidate = installation_id.strip()
        if not candidate.isdigit() or int(candidate) <= 0:
            raise BrokerError("broker response has an invalid installation_id")
        installation_value = candidate
    else:
        raise BrokerError("broker response has no installation_id")

    cached = payload.get("cached", False)
    if not isinstance(cached, bool):
        raise BrokerError("broker response has an invalid cached flag")

    audit_id = payload.get("audit_id")
    if audit_id is not None and not isinstance(audit_id, str):
        raise BrokerError("broker response has an invalid audit_id")

    return {
        "token": token,
        "expires_at": _canonical_timestamp(expires),
        "installation_id": installation_value,
        "cached": cached,
        "audit_id": audit_id,
    }


def _reject_symlink(path: Path, kind: str) -> None:
    try:
        info = os.lstat(path)
    except FileNotFoundError:
        return
    except OSError as exc:
        raise ConfigError(f"cannot inspect {kind} file {path}: {exc.strerror}") from None
    if stat.S_ISLNK(info.st_mode):
        raise ConfigError(f"{kind} file {path} must not be a symlink")
    if not stat.S_ISREG(info.st_mode):
        raise ConfigError(f"{kind} file {path} must be a regular file")


def _check_private_mode(info: os.stat_result, path: Path, kind: str) -> None:
    if info.st_mode & 0o077:
        raise ConfigError(
            f"{kind} file {path} is too permissive; expected 0600 (no group/world access)"
        )
    if not info.st_mode & stat.S_IRUSR:
        raise ConfigError(f"{kind} file {path} is not readable by its owner")
    if info.st_uid != os.geteuid():
        raise ConfigError(f"{kind} file {path} must be owned by uid {os.geteuid()}")


def read_secure_secret(path_text: str, kind: str = "broker token") -> str:
    """Read a 0600 regular file without following symlinks."""
    path = Path(path_text)
    _reject_symlink(path, kind)
    flags = os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0)
    try:
        fd = os.open(path, flags)
    except FileNotFoundError:
        raise ConfigError(f"{kind} file {path} does not exist") from None
    except OSError as exc:
        raise ConfigError(f"cannot open {kind} file {path}: {exc.strerror}") from None
    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise ConfigError(f"{kind} file {path} must be a regular file")
        _check_private_mode(info, path, kind)
        if info.st_size > MAX_SECRET_FILE_BYTES:
            raise ConfigError(f"{kind} file {path} is unexpectedly large")
        with os.fdopen(fd, "r", encoding="utf-8") as handle:
            fd = -1
            value = handle.read(MAX_SECRET_FILE_BYTES + 1)
    except UnicodeDecodeError:
        raise ConfigError(f"{kind} file {path} is not valid UTF-8") from None
    finally:
        if fd >= 0:
            os.close(fd)
    value = value.strip()
    if not value:
        raise ConfigError(f"{kind} file {path} is empty")
    if WHITESPACE_RE.search(value):
        raise ConfigError(f"{kind} file {path} contains whitespace inside the value")
    return value


def _validated_alias(value: str | None) -> str:
    alias = (value or "").strip()
    if not alias:
        raise ConfigError(
            "no GitHub App alias configured; set KESTREL_GITHUB_APP or pass --app"
        )
    if not ALIAS_RE.fullmatch(alias):
        raise ConfigError("GitHub App alias contains invalid characters")
    return alias


def _validated_broker_url(value: str | None) -> str:
    text = (value or DEFAULT_BROKER_URL).strip()
    parsed = urllib.parse.urlsplit(text)
    if parsed.scheme not in ("http", "https"):
        raise ConfigError("broker URL must use http or https")
    if not parsed.netloc or parsed.username or parsed.password:
        raise ConfigError("broker URL must have a host and no embedded credentials")
    if parsed.query or parsed.fragment:
        raise ConfigError("broker URL must not contain a query or fragment")
    return text.rstrip("/")


def cache_path_for_app(app: str) -> Path:
    return Path(DEFAULT_CACHE_DIR) / f"kestrel-github-token-{app}.json"


def _check_cache_parent(path: Path) -> Path:
    parent = path.parent
    try:
        info = os.lstat(parent)
    except FileNotFoundError:
        try:
            parent.mkdir(mode=0o700, parents=True, exist_ok=True)
            info = os.lstat(parent)
        except OSError as exc:
            raise CacheError(f"cannot create cache directory {parent}: {exc.strerror}") from None
    except OSError as exc:
        raise CacheError(f"cannot inspect cache directory {parent}: {exc.strerror}") from None
    if stat.S_ISLNK(info.st_mode):
        raise CacheError(f"cache directory {parent} must not be a symlink")
    if not stat.S_ISDIR(info.st_mode):
        raise CacheError(f"cache directory {parent} is not a directory")
    return parent


def load_cache(
    path: Path,
    *,
    app: str | None = None,
    broker_url: str | None = None,
    now: dt.datetime | None = None,
    safety_margin: dt.timedelta = SAFETY_MARGIN,
) -> dict | None:
    """Return a valid cached token record, or None for a miss/corrupt cache."""
    try:
        info = os.lstat(path)
    except FileNotFoundError:
        return None
    except OSError as exc:
        raise CacheError(f"cannot inspect cache file {path}: {exc.strerror}") from None
    if stat.S_ISLNK(info.st_mode):
        raise CacheError(f"cache file {path} must not be a symlink")
    if not stat.S_ISREG(info.st_mode):
        raise CacheError(f"cache file {path} must be a regular file")
    try:
        _check_private_mode(info, path, "cache")
    except ConfigError as exc:
        raise CacheError(str(exc)) from None

    flags = os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0)
    try:
        fd = os.open(path, flags)
    except OSError as exc:
        raise CacheError(f"cannot open cache file {path}: {exc.strerror}") from None
    try:
        with os.fdopen(fd, "r", encoding="utf-8") as handle:
            fd = -1
            raw = handle.read(MAX_RESPONSE_BYTES + 1)
    finally:
        if fd >= 0:
            os.close(fd)
    if len(raw) > MAX_RESPONSE_BYTES:
        return None
    try:
        payload = json.loads(raw)
    except (ValueError, TypeError):
        return None
    if not isinstance(payload, dict):
        return None
    if app is not None and payload.get("app") not in (None, app):
        return None
    if broker_url is not None and payload.get("broker_url") not in (None, broker_url):
        return None
    try:
        record = validate_issue_response(payload, now=now, safety_margin=safety_margin)
    except BrokerError:
        return None
    record["app"] = payload.get("app", app)
    record["broker_url"] = payload.get("broker_url", broker_url)
    return record


def write_cache(path: Path, record: dict) -> None:
    """Atomically write a 0600 cache file in the destination directory."""
    parent = _check_cache_parent(path)
    data = (
        json.dumps(record, sort_keys=True, separators=(",", ":")) + "\n"
    ).encode("utf-8")
    fd = -1
    temp_name: str | None = None
    try:
        fd, temp_name = tempfile.mkstemp(
            prefix=f".{path.name}.", suffix=".tmp", dir=str(parent)
        )
        os.fchmod(fd, 0o600)
        with os.fdopen(fd, "wb") as handle:
            fd = -1
            handle.write(data)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temp_name, path)
        temp_name = None
        try:
            dir_fd = os.open(parent, os.O_RDONLY | getattr(os, "O_DIRECTORY", 0))
        except OSError:
            dir_fd = -1
        if dir_fd >= 0:
            try:
                os.fsync(dir_fd)
            finally:
                os.close(dir_fd)
    except OSError as exc:
        raise CacheError(f"cannot write cache file {path}: {exc.strerror}") from None
    finally:
        if fd >= 0:
            os.close(fd)
        if temp_name is not None:
            try:
                os.unlink(temp_name)
            except OSError:
                pass


def issue_token(
    broker_url: str,
    broker_token: str,
    app: str,
    *,
    timeout: float = DEFAULT_TIMEOUT,
) -> dict:
    """Call the Kestrel broker and return the validated token record."""
    url = broker_url.rstrip("/") + "/v1/tokens/issue"
    body = json.dumps({"provider": "github", "app": app}).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=body,
        method="POST",
        headers={
            "Authorization": "Bearer " + broker_token,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "User-Agent": "soc-kestrel-github-token",
        },
    )
    opener = urllib.request.build_opener(_NoRedirect())
    try:
        with opener.open(request, timeout=timeout) as response:
            raw = response.read(MAX_RESPONSE_BYTES + 1)
    except urllib.error.HTTPError as exc:
        raise BrokerError(f"Kestrel broker rejected the request (HTTP {exc.code})") from None
    except (urllib.error.URLError, TimeoutError, OSError):
        raise BrokerError("Kestrel broker is unavailable") from None
    if len(raw) > MAX_RESPONSE_BYTES:
        raise BrokerError("Kestrel broker returned an oversized response")
    try:
        payload = json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, ValueError):
        raise BrokerError("Kestrel broker returned invalid JSON") from None
    return validate_issue_response(payload)


def _public_record(record: dict, *, cache_hit: bool, cache_file: Path) -> dict:
    return {
        "provider": "github",
        "app": record.get("app"),
        "expires_at": record["expires_at"],
        "installation_id": record["installation_id"],
        "cached": bool(record.get("cached", False)),
        "cache_hit": cache_hit,
        "cache_file": str(cache_file),
        "audit_id": record.get("audit_id"),
    }


def _emit(
    record: dict | None,
    *,
    output_format: str,
    print_token: bool,
    cache_hit: bool,
    cache_file: Path,
    dry_run: bool,
    app: str,
    broker_url: str,
    token_file: Path,
) -> None:
    if dry_run:
        data = {
            "dry_run": True,
            "provider": "github",
            "app": app,
            "broker_url": broker_url,
            "token_file": str(token_file),
            "cache_file": str(cache_file),
            "cache_hit": cache_hit,
            "action": "would use cache" if cache_hit else "would request broker token",
        }
        if output_format == "json":
            print(json.dumps(data, sort_keys=True))
        else:
            print("dry-run: no broker request and no cache write")
            print(f"app={app}")
            print(f"broker_url={broker_url}")
            print(f"token_file={token_file}")
            print(f"cache_file={cache_file}")
            print(f"action={data['action']}")
        return

    assert record is not None
    if print_token and output_format == "text":
        print(record["token"])
        return
    public = _public_record(record, cache_hit=cache_hit, cache_file=cache_file)
    if print_token:
        public["token"] = record["token"]
    if output_format == "json":
        print(json.dumps(public, sort_keys=True))
        return
    for key in (
        "provider",
        "app",
        "expires_at",
        "installation_id",
        "cached",
        "cache_hit",
        "cache_file",
        "audit_id",
    ):
        print(f"{key}={public.get(key)}")


def _env_float(name: str, default: float) -> float:
    raw = os.environ.get(name, "").strip()
    if not raw:
        return default
    try:
        value = float(raw)
    except ValueError:
        raise ConfigError(f"{name} must be a number") from None
    if value <= 0 or value > 120:
        raise ConfigError(f"{name} must be between 0 and 120 seconds")
    return value


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Mint a short-lived GitHub App token through the Kestrel broker. "
            "Metadata is printed by default; use --print-token only when a caller needs it."
        )
    )
    parser.add_argument("--app", help="GitHub App alias allowed by the broker policy")
    parser.add_argument("--broker-url", help="Kestrel broker base URL")
    parser.add_argument("--token-file", help="Kestrel broker token file (0600, no symlink)")
    parser.add_argument("--cache-file", help="installation-token cache file (0600)")
    parser.add_argument("--timeout", type=float, help="broker request timeout in seconds")
    parser.add_argument(
        "--format", choices=("text", "json"), default="text", help="metadata output format"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="validate configuration and cache state without contacting the broker",
    )
    parser.add_argument(
        "--print-token",
        action="store_true",
        help="print the minted token (only for callers that require it)",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        app = _validated_alias(args.app or os.environ.get("KESTREL_GITHUB_APP"))
        broker_url = _validated_broker_url(
            args.broker_url or os.environ.get("KESTREL_BROKER_URL")
        )
        token_file = Path(
            args.token_file
            or os.environ.get("KESTREL_BROKER_TOKEN_FILE")
            or DEFAULT_BROKER_TOKEN_FILE
        )
        cache_file = Path(
            args.cache_file
            or os.environ.get("KESTREL_GITHUB_TOKEN_CACHE")
            or cache_path_for_app(app)
        )
        timeout = (
            args.timeout
            if args.timeout is not None
            else _env_float("KESTREL_BROKER_TIMEOUT", DEFAULT_TIMEOUT)
        )
        if timeout <= 0 or timeout > 120:
            raise ConfigError("timeout must be between 0 and 120 seconds")

        # Validate the dedicated broker token file even on a cache hit. This
        # keeps a missing/unsafe credential from being masked by an old cache.
        broker_token = read_secure_secret(str(token_file))
        now = _utcnow()
        cached = load_cache(cache_file, app=app, broker_url=broker_url, now=now)

        if args.dry_run:
            _emit(
                None,
                output_format=args.format,
                print_token=False,
                cache_hit=cached is not None,
                cache_file=cache_file,
                dry_run=True,
                app=app,
                broker_url=broker_url,
                token_file=token_file,
            )
            return 0

        if cached is not None:
            _emit(
                cached,
                output_format=args.format,
                print_token=args.print_token,
                cache_hit=True,
                cache_file=cache_file,
                dry_run=False,
                app=app,
                broker_url=broker_url,
                token_file=token_file,
            )
            return 0

        record = issue_token(broker_url, broker_token, app, timeout=timeout)
        record["app"] = app
        record["broker_url"] = broker_url
        # Do not persist a token that has less than the safety margin left.
        if _parse_expires_at(record["expires_at"]) > _utcnow() + SAFETY_MARGIN:
            write_cache(cache_file, record)
        _emit(
            record,
            output_format=args.format,
            print_token=args.print_token,
            cache_hit=False,
            cache_file=cache_file,
            dry_run=False,
            app=app,
            broker_url=broker_url,
            token_file=token_file,
        )
        return 0
    except KestrelTokenError as exc:
        print(f"kestrel-github-token: {exc}", file=sys.stderr)
        return exc.exit_code


if __name__ == "__main__":
    raise SystemExit(main())
