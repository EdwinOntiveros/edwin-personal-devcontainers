#!/usr/bin/env bash

###############################################################################
# Developer Workspace Base smoke tests
#
# Verifies the base image contract:
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

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-}")/../../" && pwd)"

# shellcheck disable=SC1091
source "${TEST_ROOT}/helpers/bootstrap.sh"

# shellcheck disable=SC1091
source "${TEST_ROOT}/suites/bootstrap.sh"

include_once "developer_workspace_base_smoke" || exit 0

echo
echo "======================= Check is running inside container image =================================="
check "Running inside container" test -f /.dockerenv

echo
echo "======================= Dev tools =================================="
test_devtools

echo
echo "======================= Check image identity =================================="
test_image_identity

echo
echo "======================= Non root user =================================="
test_nonroot

echo
echo "======================= Workspace folder =================================="
test_workspace

echo
echo "======================= Passwordless Sudo =================================="
test_passwordless_sudo
test_sudo_equivalence

echo
echo "======================= Git config =================================="
test_git_config

echo
echo "======================= Locale settings =================================="
test_locale

echo
echo "======================= Additional environment settings =================================="
test_envsettings

echo
echo "======================= END SMOKE TEST =================================="

print_summary
