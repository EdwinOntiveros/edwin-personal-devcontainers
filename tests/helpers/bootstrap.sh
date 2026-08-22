#!/usr/bin/env bash

###############################################################################
# Helpers bootstrap
#
# Single truth source for all helpers needed for shellscript test suites
#
# Provides:
#   - Helper functions entrypoints
###############################################################################

HELPERS_DIR="$(dirname "${BASH_SOURCE[0]:-}")"

# shellcheck disable=SC1091
source "${HELPERS_DIR}/include-guard.sh"

# shellcheck disable=SC1091
source "${HELPERS_DIR}/test-status.sh"

# shellcheck disable=SC1091
source "${HELPERS_DIR}/tool-check.sh"

# shellcheck disable=SC1091
source "${HELPERS_DIR}/trap-handler.sh"

# shellcheck disable=SC1091
source "${HELPERS_DIR}/smoke-cascade.sh"
