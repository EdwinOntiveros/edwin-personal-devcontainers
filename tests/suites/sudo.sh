#!/usr/bin/env bash

#################################################################
# Sudo privilege tests
#
# - Provides:
#
# * Assertions passwordless sudo validation
# * Assertions for sudo equivalence
# * test_passwordless_sudo function
# * test_sudo_equivalence function
#
#################################################################

include_once "sudo_tests" || return 0

test_passwordless_sudo() {
    check "Checking passwordless sudo" sudo -n true
}

test_sudo_equivalence(){
    check "Checking sudo privileges" test "$(sudo -n whoami)" = "root"
}
