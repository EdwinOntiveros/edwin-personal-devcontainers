#!/usr/bin/env bash

###############################################################################
# Validate GitHub Actions environment.
#
# Inputs:
#
#   INPUT_ENVIRONMENT
#
# Supported environments:
#
#   development
#   test
#   staging
#   production
#
###############################################################################

set -Eeuo pipefail

: "${INPUT_ENVIRONMENT:?INPUT_ENVIRONMENT is required}"

case "${INPUT_ENVIRONMENT}" in
    development|test|staging|production)
        echo "Environment validated: ${INPUT_ENVIRONMENT}"
        ;;

    *)
        echo "ERROR: Invalid environment: ${INPUT_ENVIRONMENT}" >&2
        echo "Allowed environments:" >&2
        echo "  development" >&2
        echo "  test" >&2
        echo "  staging" >&2
        echo "  production" >&2
        exit 1
        ;;
esac
