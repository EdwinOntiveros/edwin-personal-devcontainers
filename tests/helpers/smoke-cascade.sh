#!/usr/bin/env bash
###############################################################################
# Smoke test cascade
#
# Provides:
#
# - test_parent_smoke
#
###############################################################################

include_once "smoke_cascade" || exit 0

test_parent_smoke() {
    local parent_smoke="$1"

    if [[ -z "${parent_smoke}" ]]; then
        echo "ERROR: Parent smoke test path cannot be empty." >&2
        return 1
    fi

    local smoke_path="${TEST_ROOT}/${parent_smoke}"

    if [[ ! -f "${smoke_path}" ]]; then
        echo "ERROR: Parent smoke test does not exist:" >&2
        echo "    ${smoke_path}" >&2
        return 1
    fi

    if [[ ! -r "${smoke_path}" ]]; then
        echo "ERROR: Parent smoke test is not readable:" >&2
        echo "    ${smoke_path}" >&2
        return 1
    fi

    echo
    echo "Running parent ${parent_smoke} smoke test"
    bash "${smoke_path}"

}
