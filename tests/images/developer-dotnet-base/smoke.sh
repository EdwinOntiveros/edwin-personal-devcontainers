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

echo
echo "======================= Developer Workspace Base =================================="

test_devtools
test_image_identity
test_nonroot
test_passwordless_sudo
test_sudo_equivalence
test_git_config
test_locale
test_envsettings

echo
echo "======================= Test dotnet build tools =================================="

test_dotnet

echo
echo "======================= END SMOKE TEST =================================="

print_summary
