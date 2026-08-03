#!/usr/bin/env bash

#################################################################
# Image Identity Tests
#
# - Provides:
#
# * Assertions for container image identity validations
# * test_image_identity function
#
#################################################################

include_once "image_identity_tests" || return 0

test_image_identity() {
    check "Check debian release" grep -q "bookworm" /etc/os-release
    check "Check architecture command" test -n "$(uname -m)"
    check "Check bash version >= 5" test "${BASH_VERSINFO[0]}" -ge 5
}
