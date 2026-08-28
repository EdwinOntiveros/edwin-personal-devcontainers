#!/usr/bin/env bash

###############################################################################
# Prepare GitHub Actions helper scripts for execution.
###############################################################################

set -Eeuo pipefail

: "${SCRIPTS_ROOT:?SCRIPTS_ROOT is required}"

SCRIPTS="${SCRIPTS_ROOT}"

if [[ ! -d "${SCRIPTS}" ]]; then
    echo "ERROR: Scripts directory does not exist: ${SCRIPTS}" >&2
    exit 1
fi

find "${SCRIPTS}" \
    -type f \
    -name "*.sh" \
    -exec chmod +x {} +

echo "Helper Scripts prepared:"
echo "    ${SCRIPTS}"
