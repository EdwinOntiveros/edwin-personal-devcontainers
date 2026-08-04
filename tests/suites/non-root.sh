#!/usr/bin/env bash

#################################################################
# Non-root User Tests
#
# - Provides:
#
# * Assertions for non root user validation
# * test_nonroot function
#
#################################################################

include_once "nonroot_tests" || return 0

test_nonroot() {
    check "Check non-root username" test "$(whoami)" = "developer"
    check "Check non-root UID is 1000" test "$(id -u)" -eq 1000
    check "Check non-root GID is 1000" test "$(id -g)" -eq 1000
    check "Check that user isn't root" test "$(id -u)" -ne 0

    check "Check home folder exists" test -d "$HOME"
    check "Check home folder is writable" test -w "$HOME"
    check "Check home folder path" test "$HOME" = "/home/developer"
    check "Check home folder ownership" test -O "$HOME"
}
