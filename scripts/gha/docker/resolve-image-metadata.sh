#!/usr/bin/env bash

###############################################################################
# Resolve Docker image build metadata.
#
# Inputs:
#
#   INPUT_IMAGE_NAME
#       Docker image name under images/<image_name>.
#
#   INPUT_DOCKERFILE
#       Optional Dockerfile path relative to repository root.
#
#   GITHUB_SHA
#       Immutable Git revision associated with this workflow execution.
#
# Outputs:
#
#   GITHUB_OUTPUT:
#
#       image_name
#           Validated image name.
#
#       image_tag
#           Immutable Git SHA tag.
#
#       image_reference
#           Local Docker image reference.
#
#       dockerfile
#           Resolved Dockerfile path.
#
#       artifact_name
#           Tested image artifact name.
#
###############################################################################

set -Eeuo pipefail

# =============================================================================
# Required inputs
# =============================================================================

: "${INPUT_IMAGE_NAME:?INPUT_IMAGE_NAME is required}"
: "${GITHUB_SHA:?GITHUB_SHA is required}"
: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"

# =============================================================================
# Validate image name
# =============================================================================

IMAGE_NAME="${INPUT_IMAGE_NAME}"

if [[ -z "${IMAGE_NAME}" ]]; then
    echo "ERROR: Image name cannot be empty." >&2
    exit 1
fi

if [[ ! "${IMAGE_NAME}" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
    echo "ERROR: Image name must be a single directory name: ${IMAGE_NAME}" >&2
    echo "       Image names must contain only lowercase letters, numbers, '.', '_' or '-'." >&2
    exit 1
fi

if [[ "${IMAGE_NAME}" == */* ]]; then
    echo "ERROR: Nested image directories are not supported:" >&2
    echo "    ${IMAGE_NAME}" >&2
    exit 1
fi

# =============================================================================
# Resolve image directory
# =============================================================================

IMAGE_DIRECTORY="images/${IMAGE_NAME}"

if [[ ! -d "${IMAGE_DIRECTORY}" ]]; then
    echo "ERROR: Image directory does not exist:" >&2
    echo "      ${IMAGE_DIRECTORY}" >&2
    exit 1
fi

# =============================================================================
# Resolve Dockerfile
# =============================================================================

DOCKERFILE="${INPUT_DOCKERFILE:-${IMAGE_DIRECTORY}/Dockerfile}"

if [[ ! -f "${DOCKERFILE}" ]]; then
    echo "ERROR: Dockerfile does not exist:" >&2
    echo "    ${DOCKERFILE}" >&2
    exit 1
fi

if [[ ! -r "${DOCKERFILE}" ]]; then
    echo "ERROR: Dockerfile is not readable:" >&2
    echo "    ${DOCKERFILE}" >&2
    exit 1
fi

# =============================================================================
# Resolve immutable build tag
# =============================================================================

IMAGE_TAG="${GITHUB_SHA}"

if [[ -z "${IMAGE_TAG}" ]]; then
    echo "ERROR: Git SHA cannot be empty." >&2
    echo "    ${IMAGE_TAG}" >&2
    exit 1
fi

if [[ ! "${IMAGE_TAG}" =~ ^[0-9a-f]{40}$ ]]; then
    echo "ERROR: GITHUB_SHA must be a 40-character Git SHA:" >&2
    echo "    ${GITHUB_SHA}" >&2
    exit 1
fi


# =============================================================================
# Artifact name
# =============================================================================

IMAGE_REFERENCE="local/${IMAGE_NAME}:${IMAGE_TAG}"
ARTIFACT_NAME="tested-${IMAGE_NAME}-${IMAGE_TAG}"

# =============================================================================
# Export metadata
# =============================================================================

{
    printf 'image_name=%s\n' "${IMAGE_NAME}"
    printf 'image_tag=%s\n' "${IMAGE_TAG}"
    printf 'image_reference=%s\n' "${IMAGE_REFERENCE}"
    printf 'dockerfile=%s\n' "${DOCKERFILE}"
    printf 'artifact_name=%s\n' "${ARTIFACT_NAME}"
} >> "${GITHUB_OUTPUT}"

# =============================================================================
# Report
# =============================================================================

echo "========================== IMAGE METADATA ======================================="
echo
echo "Image metadata resolved:"
echo
echo "  Image name:"
echo "    ${IMAGE_NAME}"
echo
echo "  Image tag:"
echo "    ${IMAGE_TAG}"
echo
echo "  Image reference:"
echo "    ${IMAGE_REFERENCE}"
echo
echo "  Dockerfile :"
echo "    ${DOCKERFILE}"
echo
echo "  Artifact name:"
echo "    ${ARTIFACT_NAME}"
echo
echo "========================== END METADATA ====================================="
