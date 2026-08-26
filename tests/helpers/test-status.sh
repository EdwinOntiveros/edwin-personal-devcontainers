#!/usr/bin/env bash

###############################################################################
# Test status helper
#
# Provides:
#
# - Passed test counter
# - Splash message print function
#
###############################################################################

include_once "test_status" || exit 0

declare -gi PASSED=0
declare -gi FAILED=0

test_passed() {
    PASSED+=1
}

test_failed() {
    FAILED+=1
}

print_summary() {
    local red
    local green
    local reset
    local yellow
    local blue

    reset="$(tput sgr0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"

    echo
    echo "========================================"
    echo "Developer Workspace Contract"
    echo "${blue}Passed${reset}: ${PASSED} checks"
    echo "${blue}Failed${reset}: ${FAILED} checks"
    if (( FAILED > 0)); then
        echo "${yellow}Status${reset}: ${red}FAILURE${reset}"
        return 1
    fi
    echo "${yellow}Status${reset}: ${green}SUCCESS${reset}"
    echo "========================================"
    return 0
}
