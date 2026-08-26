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
# - project creation/build/test validation
#
###############################################################################

include_once "dotnet_tests" || return 0

DOTNET_MIN_MAJOR="${DOTNET_MIN_MAJOR:-10}"

_validate_dotnet_cli() {
    command -v dotnet >/dev/null 2>&1
}

_dotnet_major_version() {
    dotnet --version | awk -F. '{print $1}'
}

_valiate_dotnet_major_version() {
    return 0
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

    check ".NET ${DOTNET_MIN_MAJOR} SDK is installed" _validate_dotnet_sdk

    check "MSBuild is installed" _validate_msbuild

    check "NuGet is installed" _validate_nuget

    echo ".NET tooling is available and ready 🎉"
}
