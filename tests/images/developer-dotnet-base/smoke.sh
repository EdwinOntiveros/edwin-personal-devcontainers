#!/usr/bin/env bash

###############################################################################
# .NET Development Image Smoke Tests
#
# Validates:
#
# - inherited developer workspace contract
# - .NET CLI
# - .NET SDK
# - MSBuild
# - NuGet
# - project creation
# - restore
# - build
# - test
#
###############################################################################

set -Eeuo pipefail

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-}")/../../" && pwd)"

# shellcheck disable=SC1091
source "${TEST_ROOT}/helpers/bootstrap.sh"

# shellcheck disable=SC1091
source "${TEST_ROOT}/suites/bootstrap.sh"

include_once "dotnet_smoke" || exit 0

echo
echo "======================= Check is running inside container image =================================="

check "Running inside container" test -f /.dockerenv

echo "======================= Parent image regression =================================="

test_parent_smoke \
    "images/developer-workspace-base/smoke.sh"

echo
echo "======================= Test dotnet build tools =================================="

test_dotnet

echo
echo "======================= END SMOKE TEST =================================="

print_summary
