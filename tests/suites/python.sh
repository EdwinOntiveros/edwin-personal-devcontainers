#!/usr/bin/env bash
###############################################################################
# Python Runtime Tests
#
# Provides:
#
# - test_python
#
###############################################################################

include_once "python_tests" || return 0

_validate_python_version() {
    python -c '
import sys

raise SystemExit(
    0 if sys.version_info >= (3, 13) else 1
)
'
}

_validate_python_runtime() {
    python -c '
import json
import pathlib
import sqlite3
import ssl

json.dumps({"status": "ok"})
pathlib.Path.cwd()
sqlite3.sqlite_version
ssl.OPENSSL_VERSION
'
}

_validate_uv_managed_python() {
    local python_path
    local managed_path

    python_path="$(readlink -f "$(command -v python)")"
    managed_path="$(readlink -f "$(uv python find "${PYTHON_VERSION}")")"

    test "${python_path}" = "${managed_path}"
}

test_python() {
    check "Check uv is installed" \
        command -v uv

    check "Check uv is executable" \
        test -x "$(command -v uv)"

    check "Check python is installed" \
        command -v python

    check "Check python3 is installed" \
        command -v python3

    check "Check Python version >= 3.13" \
        _validate_python_version

    check "Check Python runtime" \
        _validate_python_runtime

    check "Check UV managed Python" \
        _validate_uv_managed_python

    check "Check UV Python installation directory" \
        test -d "${UV_PYTHON_INSTALL_DIR}"

    check "Check UV Python installation readable" \
        test -r "${UV_PYTHON_INSTALL_DIR}"

    check "Check UV cache directory" \
        test -d "${UV_CACHE_DIR}"

    check "Check UV cache writable" \
        test -w "${UV_CACHE_DIR}"

    check "Check UV Python preference" \
        test "${UV_PYTHON_PREFERENCE}" = "only-managed"
}
