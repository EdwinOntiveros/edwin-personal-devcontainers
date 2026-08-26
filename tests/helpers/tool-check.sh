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

    local output
    if output="$("$@" 2>&1)"; then
        test_passed
        printf "✅\n"
        return 0
    fi

    local status
    status=$?

    test_failed
    printf "⛔\n"

    echo
    echo "  command failed:"
    echo "      $*"
    echo

    echo
    printf "Exit code: %d" "${status}"
    echo

    echo
    echo "  Output:"
    if [[ -n "${output}" ]]; then
        while IFS= read -r line; do
            echo "      ${line}"
        done <<< "${output}"
    else
        echo "      <no-output>"
    fi

    return 0
}
