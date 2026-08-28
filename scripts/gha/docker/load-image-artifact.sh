#!/usr/bin/env bash

###############################################################################
# Load a compressed Docker image artifact.
#
# Inputs:
#
#   ARTIFACT_PATH
#       Path to .tar.gz Docker image artifact.
#
#   IMAGE_REFERENCE
#       Expected image reference after loading.
#
###############################################################################

set -Eeuo pipefail

: "${ARTIFACT_PATH:?ARTIFACT_PATH is required}"
: "${IMAGE_REFERENCE:?IMAGE_REFERENCE is required}"

# =============================================================================
# Validate artifact
# =============================================================================

if [[ -f "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: Image artifact does not exist:" >&2
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

if [[ -s "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: Image artifact is empty:" >&2
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

if ! gzip -t "${ARTIFACT_PATH}"; then
    echo "ERROR: Image artifact failed gzip validation:" >&2
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

# =============================================================================
# Load image
# =============================================================================

echo "Loading Docker image artifact:"
echo "      ${ARTIFACT_PATH}"

gunzip -c "${ARTIFACT_PATH}" |
    docker load

# =============================================================================
# Validate loaded image
# =============================================================================

if ! docker image inspect "${IMAGE_REFERENCE}" >/dev/null 2>&1; then
    echo "ERROR: Expected Docker image was not loaded:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

# =============================================================================
# Report
# =============================================================================

echo
echo "Docker image loaded successfully:"
echo "    ${IMAGE_REFERENCE}"
