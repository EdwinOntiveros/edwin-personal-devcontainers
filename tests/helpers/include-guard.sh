#!/usr/bin/env bash

###############################################################################
# Include guard
#
# Provides:
# - Include guard helper function
# Usage:
#   include_once "MODULE_NAME"
###############################################################################

[[ -n "${_INCLUDE_GUARD_LOADED:-}" ]] && exit 0

readonly _INCLUDE_GUARD_LOADED=1

include_once() {
    local module="$1"

    local guard="_SCRIPT_${module^^}_LOADED"

    if [[ -n "${!guard:-}" ]]; then
        return 1
    fi

    declare -rg "${guard}=1"

    return 0
}
