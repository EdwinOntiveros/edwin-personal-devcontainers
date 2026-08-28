#!/usr/bin/env bash

###############################################################################
# Validate a Docker image before test execution or publication.
#
# Inputs:
#
#   IMAGE_REFERENCE
#       Docker image reference to validate.
#
# Optional:
#
#   EXPECTED_IMAGE_NAME
#       Expected repository/image name.
#
#   EXPECTED_IMAGE_TAG
#       Expected image tag.
#
###############################################################################

set -Eeuo pipefail

: "${IMAGE_REFERENCE:?IMAGE_REFERENCE is required}"

# =============================================================================
# Image existence
# =============================================================================

if ! docker image inspect "${IMAGE_REFERENCE}" >/dev/null 2>&1; then
    echo "ERROR: Docker image does not exist:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

# =============================================================================
# Image metadata
# =============================================================================

IMAGE_ID="$(
    docker image inspect \
        --format '{{.Id}}' \
        "${IMAGE_REFERENCE}"
)"

IMAGE_CREATED="$(
    docker image inspect \
        --format '{{.Created}}' \
        "${IMAGE_REFERENCE}"
)"

IMAGE_SIZE="$(
    docker image inspect \
        --format '{{.Size}}' \
        "${IMAGE_REFERENCE}"
)"

if [[ -z "${IMAGE_ID}" ]]; then
    echo "ERROR: Docker image has no image ID:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

if [[ -z "${IMAGE_CREATED}" ]]; then
    echo "ERROR: Docker image has no creation timestamp:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

if [[ -z "${IMAGE_SIZE}" || "${IMAGE_SIZE}" -le 0 ]]; then
    echo "ERROR: Docker image has invalid size:" >&2
    echo "    ${IMAGE_SIZE}" >&2
    exit 1
fi

# =============================================================================
# Optional name validation
# =============================================================================

if [[ -n "${EXPECTED_IMAGE_NAME:-}" ]]; then
    actual_name="$(
        docker image inspect \
            --format '{{index .RepoTags 0}}' \
            "${IMAGE_REFERENCE}"
    )"

    expected_reference="local/${EXPECTED_IMAGE_NAME}:${EXPECTED_IMAGE_TAG:-*}"

    if [[ "${actual_name}" != "${IMAGE_REFERENCE}" ]]; then
        echo "ERROR: Loaded image reference does not match expected reference." >&2
        echo "Expected:" >&2
        echo "    ${expected_reference}" >&2
        echo "Actual:" >&2
        echo "    ${actual_name}" >&2
        exit 1
    fi
fi

# =============================================================================
# Report
# =============================================================================

echo "Docker image validated:"
echo
echo "  Reference:"
echo "    ${IMAGE_REFERENCE}"
echo
echo "  Image ID:"
echo "    ${IMAGE_ID}"
echo
echo "  Created:"
echo "    ${IMAGE_CREATED}"
echo
echo "  Size:"
echo "    ${IMAGE_SIZE} bytes"
