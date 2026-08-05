#!/usr/bin/env bash

#################################################################
# Git Configuration Tests
#
# - Provides:
#
# * Assertions for git basic configuration
# * test_git_config function
#
#################################################################

include_once "git_config_tests" || return 0

_validate_git_config() {
    test "$(git config --global --get init.defaultBranch)" = "mainline"
    test "$(git config --global --get core.editor)" = "vim.tiny"
}

test_git_config() {
    check "Checking git default configuration" _validate_git_config
}
