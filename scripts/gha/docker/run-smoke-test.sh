#!/usr/bin/env bash

###############################################################################
# Run an image smoke test.
#
# Inputs:
#
#   IMAGE_NAME
#       Image name under images/<image_name>.
#
#   IMAGE_REFERENCE
#       Docker image reference to test.
#
#   TESTS_ROOT
#       Optional tests root.
#       Defaults to tests.
#
###############################################################################

set -Eeuo pipefail

: "${IMAGE_NAME:?IMAGE_NAME is required}"
: "${IMAGE_REFERENCE:?IMAGE_REFERENCE is required}"

TESTS_ROOT="${TESTS_ROOT:-tests}"
TEST_PATH="${TESTS_ROOT}/images/${IMAGE_NAME}/smoke.sh"

# =============================================================================
# Validate test entrypoint
# =============================================================================

if [[ ! -f "${TEST_PATH}" ]]; then
    echo "ERROR: Smoke test does not exist:" >&2
    echo "    ${TEST_PATH}" >&2
    exit 1
fi

if [[ ! -r "${TEST_PATH}" ]]; then
    echo "ERROR: Smoke test is not readable:" >&2
    echo "    ${TEST_PATH}" >&2
    exit 1
fi

# =============================================================================
# Validate image
# =============================================================================

if ! docker image inspect "${IMAGE_REFERENCE}" >/dev/null 2>&1; then
    echo "ERROR: Docker image does not exist:" >&2
    echo "    ${IMAGE_REFERENCE}" >&2
    exit 1
fi

# =============================================================================
# Run smoke test
# =============================================================================

echo "Running smoke test:"
echo "    ${TEST_PATH}"

echo
echo "Image:"
echo "    ${IMAGE_REFERENCE}"

echo
echo "======================== Begin Automated Smoke tests ==================="

docker run \
    --rm \
    --volume "${PWD}/${TESTS_ROOT}:/tests:ro" \
    "${IMAGE_REFERENCE}" \
    bash "${TEST_PATH}"

echo
echo "======================= End Smoke tests ================================"
echo
echo "Smoke test completed successfully:"
echo "    ${IMAGE_NAME}"
