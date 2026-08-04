#!/usr/bin/env bash

#################################################################
# Locale Configuration Tests
#
# - Provides:
#
# * Assertions locale configuration
# * test_locale function
#
#################################################################

include_once "locale_config_tests" || return 0

_validate_locale_config() {
    locale -a | grep -qx "en_US.utf8"
    test "${LANG}" = "en_US.UTF-8"
    test "${LC_ALL}" = "en_US.UTF-8"
}

test_locale() {
    check "Checking locale config" _validate_locale_config
}
