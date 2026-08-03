#!/usr/bin/env bash

###############################################################################
# Trap handler helper
#
# Provides:
#
# - Trap handler function
#
###############################################################################

include_once "trap_handler" || exit 0

on_error() {
    local rc=$?

    echo
    echo "⛔ ERROR (exit ${rc})"
    echo "Line: ${BASH_LINENO[0]}"
    echo "Command: ${BASH_COMMAND}"
    echo "Function: ${FUNCNAME[1]:-main}"

    echo
    echo "Function stack:"

    local i
    for i in "${!FUNCNAME[@]}"; do
        echo "   - ${FUNCNAME[$i]} (${BASH_SOURCE[$i]}:${BASH_LINENO[$i]})"
    done

    exit "${rc}"
}

trap on_error ERR
