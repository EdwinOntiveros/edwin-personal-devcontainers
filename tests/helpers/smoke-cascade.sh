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

    check \
        "Run parent smoke test: ${parent_smoke}" \
        bash "${TEST_ROOT}/${parent_smoke}"
}
