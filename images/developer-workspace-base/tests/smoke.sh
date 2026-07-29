#!/usr/bin/env bash

set -euo pipefail

echo "=== Non-root user ==="
test "$(whoami)" = "developer"

echo "=== Workspace folder ==="
test "$(pwd)" = "/workspace"

echo "=== Git ==="
git --version

echo "=== Curl ==="
curl --version

echo "=== jq ==="
jq --version

echo "=== ripgrep ==="
rg --version

echo "=== fd-find ==="
find --version

echo "== Locale =="
locale | grep "LANG=en_US.UTF-8"

echo "== Git config =="
test "$(git config --global --get init.defaultBranch)" = "main"

echo "All smoke tests passed. ✅"
