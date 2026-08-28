#!/usr/bin/env bash

###############################################################################
# Discover Docker images from the repository.
#
# Source of truth:
#
#   images/<image_name>/Dockerfile
#
# Inputs:
#
#   IMAGES_ROOT
#       Optional image root.
#       Defaults to:
#           images
#
# Outputs:
#
#   GITHUB_OUTPUT:
#
#       matrix
#
# Example:
#
#   {
#       "image_name": [
#           "developer-dotnet-base",
#           "developer-python-base",
#           "developer-workspace-base"
#       ]
#   }
#
###############################################################################

set -Eeuo pipefail

: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"

IMAGES_ROOT=${IMAGES_ROOT:-images}

if [[ ! -d "${IMAGES_ROOT}" ]]; then
    echo "ERROR: Images Directory does not exist:" >&2
    echo "      ${IMAGES_ROOT}" >&2
    exit 1
fi

declare -a images=()

while IFS= read -r -d '' dockerfile; do
    image_directory="$(dirname "${dockerfile}")"
    image_name="${image_directory#"${IMAGES_ROOT}/"}"

    if [[ -z "${image_name}" ]]; then
        echo "ERROR: Unable to resolve image name:" >&2
        echo "      ${dockerfile}" >&2
        exit 1
    fi

    if [[ "${image_name}" == */* ]]; then
        echo "ERROR: Nested image directories are not supported:" >&2
        echo "      ${dockerfile}" >&2
        exit 1
    fi

    if [[ ! "${image_name}" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
        echo "ERROR: Invalid image name:" >&2
        echo "    ${image_name}" >&2
        echo >&2
        echo "Image names must contain only:" >&2
        echo "    lowercase letters" >&2
        echo "    numbers" >&2
        echo "    ." >&2
        echo "    _" >&2
        echo "    -" >&2
        exit 1
    fi

    images+=("${image_name}")
done < <(
    find "${IMAGES_ROOT}" \
    -mindepth 2 \
    -maxdepth 2 \
    -type f \
    -name "Dockerfile" \
    -print0 |
    sort -z
)

if (( ${#images[@]} == 0)); then
    echo "ERROR: No Docker images found under:" >&2
    echo "      ${IMAGES_ROOT}/" >&2
    exit 1
fi

json="$(
    printf '%s\n' "${images[@]}" |
        jq -Rsc '
            split("\n")
            | map(select(length > 0))
            | {image_name: .}
        '
)"

echo "Discovered docker images:"
printf '    -%s\n' "${images[@]}"

echo
echo "Images matrix:"
echo "${json}"

printf 'matrix=%s\n' "${json}" >> "${GITHUB_OUTPUT}"
