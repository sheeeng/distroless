#!/usr/bin/env bash

set -o errexit
set -o xtrace

# ----------------------------------------------------------------------

GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
echo "\${GIT_ROOT_DIR}: ${GIT_ROOT_DIR}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "\${SCRIPT_DIR}: ${SCRIPT_DIR}"

IMAGE_TAG='distroless/examples/dotnet/core:latest'

# ----------------------------------------------------------------------

cd "${GIT_ROOT_DIR}"

bazel build \
    --curses=no \
    --host_force_python=PY2 \
    //examples/dotnet_core:hello

bazel run \
    --curses=no \
    --host_force_python=PY2 \
    //examples/dotnet_core:hello

bazel test \
    --curses=no \
    --host_force_python=PY2 \
    //examples/dotnet_core:hello_test
