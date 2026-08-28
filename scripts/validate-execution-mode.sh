#!/usr/bin/env bash

###############################################################################
# Validate workflow execution mode.
#
# Inputs:
#
#   EXECUTION_MODE
#     Supported values:
#       gha
#       local
#
###############################################################################

set -Eeuo pipefail

: "${EXECUTION_MODE:?EXECUTION_MODE is required}"

case "${EXECUTION_MODE}" in
    gha|local)
        echo "Execution mode: ${EXECUTION_MODE}"
        ;;
    *)
        echo "ERROR: Unsupported execution mode: ${EXECUTION_MODE}" >&2
        echo "Supported modes: gha, local" >&2
        exit 1
        ;;
esac
