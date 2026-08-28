#!/usr/bin/env bash

###############################################################################
# .NET Development Tests
#
# Provides:
#
# - .NET CLI validation
# - .NET SDK validation
# - MSBuild validation
# - NuGet validation
#
###############################################################################

include_once "dotnet_tests" || return 0

DOTNET_MIN_MAJOR=${DOTNET_MIN_MAJOR:-10}

_validate_dotnet_cli() {
    command -v dotnet >/dev/null 2>&1
}

_dotnet_major_version() {
    dotnet --version | awk -F. '{print $1}'
}

_validate_dotnet_major_version() {
    local dotnet_version
    dotnet_version=$(_dotnet_major_version)

    test -n "${DOTNET_MIN_MAJOR}"
    test -n "${dotnet_version}"

    echo "Detected .NET major version: ${dotnet_version}"
    echo "Required .NET runtime version: ${DOTNET_MIN_MAJOR}"

    if (( dotnet_version >= DOTNET_MIN_MAJOR )); then
        return 0
    fi

    echo "ERROR: Detected .NET major version ${dotnet_version}"
    echo "      required minimum version is ${DOTNET_MIN_MAJOR}"
    return 1
}

_validate_dotnet_sdk() {
    dotnet --list-sdks | grep -Eq "^${DOTNET_MIN_MAJOR}\."
}

_validate_msbuild() {
    dotnet msbuild -version >/dev/null 2>&1
}

_validate_nuget() {
    dotnet nuget --version >/dev/null 2>&1
}

test_dotnet() {
    check "dotnet CLI is installed" _validate_dotnet_cli

    check "dotnet major version is >= ${DOTNET_MIN_MAJOR}" _validate_dotnet_major_version

    check ".NET ${DOTNET_MIN_MAJOR} SDK is installed" _validate_dotnet_sdk

    check "MSBuild is installed" _validate_msbuild

    check "NuGet is installed" _validate_nuget
}
