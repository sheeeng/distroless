#!/usr/bin/env bash

set -o errexit
set -o xtrace

# kill $(pgrep bazel)

# ----------------------------------------------------------------------

GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
echo "\${GIT_ROOT_DIR}: ${GIT_ROOT_DIR}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "\${SCRIPT_DIR}: ${SCRIPT_DIR}"

# ----------------------------------------------------------------------

bazel version
bazel version --gnu_format
bazel --version

# ----------------------------------------------------------------------

BAZEL_BIN_PATH="${GIT_ROOT_DIR}/bazel-bin"
echo "\${BAZEL_BIN_PATH}: ${BAZEL_BIN_PATH}"

for item in "${BAZEL_BIN_PATH}/*"; do
    rm --force --recursive --verbose "$(readlink --canonicalize ${item})"
done
[ -d "${BAZEL_OUT_PATH}" ] && rm --verbose "${BAZEL_BIN_PATH}"

# -----------------------------------

BAZEL_OUT_PATH="${GIT_ROOT_DIR}/bazel-out"
echo "\${BAZEL_OUT_PATH}: ${BAZEL_OUT_PATH}"

for item in "${BAZEL_OUT_PATH}/*"; do
    rm --force --recursive --verbose "$(readlink --canonicalize ${item})"
done
[ -d "${BAZEL_OUT_PATH}" ] && rm --verbose "${BAZEL_OUT_PATH}"

# ----------------------------------------------------------------------

bazel clean \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_timestamps

bazel build \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_timestamps \
    //package_manager:dpkg_parser.par

# ----------------------------------------------------------------------

bazel shutdown --iff_heap_size_greater_than=1
