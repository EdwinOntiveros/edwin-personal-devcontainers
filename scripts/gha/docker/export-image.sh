#!/usr/bin/env bash


###############################################################################
# Export a Docker image as a compressed transport artifact.
#
# Inputs:
#
#   IMAGE_REFERENCE
#       Docker image reference to export.
#
#   ARTIFACT_NAME
#       Artifact base name.
#
# Outputs:
#
#   GITHUB_OUTPUT:
#
#       artifact_name
#       artifact_path
#
###############################################################################

set -Eeuo pipefail

: "${IMAGE_REFERENCE:?IMAGE_REFERENCE is required}"
: "${ARTIFACT_NAME:?ARTIFACT_NAME is required}"

ARTIFACT_ROOT="${ARTIFACT_ROOT:-/tmp}"
ARTIFACT_PATH="${ARTIFACT_ROOT}/${ARTIFACT_NAME}.tar.gz"

# =============================================================================
# Validate Docker image
# =============================================================================

if ! docker image inspect "${IMAGE_REFERENCE}" >/dev/null 2>&1; then
    echo "ERROR: Docker image does not exist:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

# =============================================================================
# Prepare artifact directory
# =============================================================================

mkdir -p "${ARTIFACT_ROOT}"

# =============================================================================
# Export image
# =============================================================================

echo "Exporting Docker image:"
echo "      ${IMAGE_REFERENCE}"

docker save "${IMAGE_REFERENCE}" |
    gzip -c > "${ARTIFACT_PATH}"

# =============================================================================
# Validate artifact
# =============================================================================

if [[ ! -f "${ARTIFACT_PATH}" ]]; then
    echo "ERROR: Image artifact was not created:" >&2
    echo "    ${ARTIFACT_PATH}" >&2
    exit 1
fi

if [[ ! -s "${ARTIFACT_PATH}" ]]; then
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
# Export outputs
# =============================================================================

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    {
        printf 'artifact_name=%s\n' "${ARTIFACT_NAME}"
        printf 'artifact_path=%s\n' "${ARTIFACT_PATH}"
    } >> "${GITHUB_OUTPUT}"
fi

# =============================================================================
# Report
# =============================================================================

echo
echo "Image artifact created:"
echo "    ${ARTIFACT_PATH}"

echo
echo "Artifact size:"
du -h "${ARTIFACT_PATH}" | cut -f1
