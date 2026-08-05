#!/usr/bin/env bash

#################################################################
# Environment Settings Tests
#
# - Provides:
#
# * Assertions for general environment settings
# * test_envsettings function
#
#################################################################

include_once "envsettings_tests" || return 0

test_envsettings() {
    check "Check EDITOR" test "$EDITOR" = "vim.tiny"
    check "Check VISUAL" test "$VISUAL" = "vim.tiny"
}
