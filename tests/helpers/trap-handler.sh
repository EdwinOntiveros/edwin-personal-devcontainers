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
    local command="${BASH_COMMAND}"
    local line="${BASH_LINENO[0]}"
    local function="${FUNCNAME[1]:-main}"

    echo
    echo "⛔ ERROR (exit ${rc})"
    echo "Line: ${line}"
    echo "Command: ${command}"
    echo "Function: ${function}"

    echo
    echo "Function stack:"

    local i
    for i in "${!FUNCNAME[@]}"; do
        echo "   - ${FUNCNAME[$i]} (${BASH_SOURCE[$i]}:${BASH_LINENO[$i]})"
    done

    exit "${rc}"
}

trap on_error ERR
