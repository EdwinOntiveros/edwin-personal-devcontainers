#!/usr/bin/env bash

#################################################################
# Workspace tests
#
# - Provides:
#
# * Assertions for workspace permissions validation
# * test_workspace function
#
#################################################################

include_once "workspace_tests" || return 0

_validate_workspace_write_and_read() {
    local tmpfile
    tmpfile="$(mktemp /workspace/.smoke.XXXXXX)"

    echo "smoke-test" > "${tmpfile}"
    test -s "${tmpfile}"
    grep -qx "smoke-test" "${tmpfile}"

    rm -f "${tmpfile}"
}

test_workspace() {

    check "Check current active dir is workspace" test "$(pwd)" = "/workspace"
    check "Check workspace folder exists" test -d /workspace
    check "Check non-root user has write access to workspace" test -w /workspace
    check "Check non-root user has execute access to workspace" test -x /workspace
    check "Checking workspace folder ownership" test -O "/workspace"
    check "Checking workspace write and read" _validate_workspace_write_and_read
    check "Check workspace group ownership" test "$(stat -c '%G' /workspace)" = "developer"
    check "Check workspace owner UID" test "$(stat -c '%u' /workspace)" -eq 1000
    check "Check workspace owner GID" test "$(stat -c '%g' /workspace)" -eq 1000
}
