#!/usr/bin/env bash

###############################################################################
# Test Suites Bootstrap
#
# Single truth source for all test suites
#
# - Provides:
# * Test suites entrypoints
#
###############################################################################

SUITES_DIR="$(dirname "${BASH_SOURCE[0]:-}")"

# shellcheck disable=SC1091
source "${SUITES_DIR}/devtools.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/identity.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/non-root.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/workspace.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/sudo.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/git-config.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/locale.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/envsettings.sh"

# shellcheck disable=SC1091
source "${SUITES_DIR}/dotnet.sh"
