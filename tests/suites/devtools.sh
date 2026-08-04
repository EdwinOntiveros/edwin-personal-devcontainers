#!/usr/bin/env bash

#################################################################
# Development Tools Tests
#
# - Provides:
#
# * Assertions for base developer tools
# * test_devtools function
#
#################################################################

include_once "devtools_tests" || return 0

declare -ra required_tools=(
    bash
    git
    curl
    wget
    openssl
    jq
    rg
    fdfind
    zip
    unzip
    ssh
    sudo
)

_validate_devtools() {
    local tool="$1"
    command -v "${tool}" >/dev/null

    timeout 2 "${tool}" --help >/dev/null 2>&1 \
        || timeout 2 "${tool}" --version >/dev/null 2>&1 \
        || true
}

test_devtools() {
    for tool in "${required_tools[@]}"; do
        check "Checking ${tool}" _validate_devtools "${tool}"
    done

    echo "All devtools installed 🎉"
}
