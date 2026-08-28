#!/usr/bin/env bash

###############################################################################
# Validate a locally exchanged image artifact.
###############################################################################

set -Eeuo pipefail

: "${ARTIFACT_NAME:?ARTIFACT_NAME is required}"
: "${ARTIFACT_PATH:?ARTIFACT_PATH is required}"

if [[ ! -f "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: Artifact does not exist:"
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

if [[ ! -s "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: Artifact is empty:"
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

echo "Validating local artifact:"
echo "    ${ARTIFACT_NAME}"

echo
echo "Path:"
echo "    ${ARTIFACT_PATH}"

echo
echo "Size:"
du -h "${ARTIFACT_PATH}" | cut -f1

echo
echo "Artifact validation complete!"
