#!/usr/bin/env bash

###############################################################################
# Developer Workspace Base Smoke Test
#
# Verifies the image contract:
#
#  - required developer tools
#  - image identity
#  - non-root developer user
#  - workspace validation
#  - writable workspace
#  - passwordless sudo
#  - git defaults
#  - locale configuration
###############################################################################

set -Eeuo pipefail

on_error() {
    local rc=$?

    echo
    echo "⛔ ERROR (exit ${rc})"
    echo "Line: ${BASH_LINENO[0]}"
    echo "Command: ${BASH_COMMAND}"
    echo "Function: ${FUNCNAME[1]}"

    echo "Function stack:"
    local i
    for i in "${!FUNCNAME[@]}"; do
        echo "   - ${FUNCNAME[$i]} (${BASH_SOURCE[$i]}:${BASH_LINENO[$i]})"
    done

    exit "${rc}"
}

trap on_error ERR

declare -i PASSED=0
check() {
    local description="$1"
    shift

    printf "%-64s" "${description}..."

    "$@" >/dev/null 2>&1

    PASSED=$((PASSED + 1))

    printf "✅\n"
}

echo
echo "======================= Dev tools =================================="

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

test_dev_tool() {
    local tool="$1"
    command -v "${tool}" >/dev/null

    "${tool}" --help >/dev/null 2>&1 \
        || "${tool}" --version >/dev/null 2>&1 \
        || true
}

for tool in "${required_tools[@]}"; do
    check "Checking ${tool}" test_dev_tool "${tool}"
done

echo "All devtools installed 🎉"

echo
echo "======================= Check image identity =================================="
check "Check debian release" grep -q "bookworm" /etc/os-release
check "Check architecture command" test -n "$(uname -m)"
check "Check bash version >= 5" test "${BASH_VERSINFO[0]}" -ge 5

echo
echo "======================= Non root user =================================="
check "Check non-root username" test "$(whoami)" = "developer"
check "Check non-root UID is 1000" test "$(id -u)" -eq 1000
check "Check non-root GID is 1000" test "$(id -g)" -eq 1000
check "Check that user isn't root" test "$(id -u)" -ne 0

check "Check home folder exists" test -d "$HOME"
check "Check home folder is writable" test -w "$HOME"
check "Check home folder path" test "$HOME" = "/home/developer"
check "Check home folder ownership" test -O "$HOME"

echo
echo "======================= Workspace folder =================================="

test_workspace_write() {
    local tmpfile
    tmpfile="$(mktemp /workspace/.smoke.XXXXXX)"

    echo "smoke-test" > "${tmpfile}"
    test -s "${tmpfile}"
    grep -qx "smoke-test" "${tmpfile}"

    rm -f "${tmpfile}"
}

check "Check current active dir is workspace" test "$(pwd)" = "/workspace"
check "Check workspace folder exists" test -d /workspace
check "Check non-root user has write access to workspace" test -w /workspace
check "Check non-root user has execute access to workspace" test -x /workspace
check "Checking workspace folder ownership" test -O "/workspace"
check "Checking workspace write and read" test_workspace_write
check "Check workspace group ownership" test "$(stat -c '%G' /workspace)" = "developer"
check "Check workspace owner UID" test "$(stat -c '%u' /workspace)" -eq 1000
check "Check workspace owner GID" test "$(stat -c '%g' /workspace)" -eq 1000

echo
echo "======================= Passwordless Sudo =================================="

check "Checking passwordless sudo" sudo -n true
check "Checking sudo privileges" test "$(sudo -n whoami)" = "root"

echo
echo "======================= Git config =================================="

validate_git_config() {
    test "$(git config --global --get init.defaultBranch)" = "mainline"
    test "$(git config --global --get core.editor)" = "vim"
}

check "Checking git default configuration" validate_git_config

echo
echo "======================= Locale settings =================================="

test_locale_config() {
    locale -a | grep -qx "en_US.utf8"
    test "${LANG}" = "en_US.UTF-8"
    test "${LC_ALL}" = "en_US.UTF-8"
}

check "Checking locale config" test_locale_config

echo
echo "======================= Additional environment settings =================================="

check "Check EDITOR" test "$EDITOR" = "vim"
check "Check VISUAL" test "$VISUAL" = "vim"

echo "========================================"
echo "Developer Workspace Base Contract"
printf "Passed: %d checks\n" "${PASSED}"
echo "Status: PASSED"
echo "========================================"
