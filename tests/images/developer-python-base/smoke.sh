#!/usr/bin/env bash
###############################################################################
# Developer Python Base smoke tests
#
# Verifies:
#
# - inherited developer-workspace-base contract
# - Python runtime
# - UV-managed Python
# - UV cache configuration
###############################################################################

set -Eeuo pipefail

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-}")/../../" && pwd)"

# shellcheck disable=SC1091
source "${TEST_ROOT}/helpers/bootstrap.sh"

# shellcheck disable=SC1091
source "${TEST_ROOT}/suites/bootstrap.sh"

include_once "developer_python_base_smoke" || exit 0

echo
echo "======================= Check is running inside container image =================================="
check "Running inside container" test -f /.dockerenv

echo
echo "======================= Parent image regression =================================="
test_parent_smoke \
    "images/developer-workspace-base/smoke.sh"

echo
echo "======================= Python runtime =================================="
test_python

echo
echo "======================= END SMOKE TEST =================================="

print_summary
