#!/usr/bin/env bash

###############################################################################
# Tool checks
#
# Provides:
#
# - Dev tool check function
#
###############################################################################
include_once "tool_checks" || exit 0

check() {
    local description="$1"
    shift

    printf "%-64s" "${description}..."

    if "$@" >/dev/null 2>&1; then
        test_passed
        printf "✅\n"
    else
        test_failed
        printf "⛔\n"
    fi

    return 0
}
