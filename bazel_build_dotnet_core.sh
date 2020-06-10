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

bazel build \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_timestamps \
    //package_manager:dpkg_parser.par

# ----------------------------------------------------------------------

bazel build \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_loading_progress \
    --show_progress \
    --show_progress_rate_limit=1 \
    --show_timestamps \
    --verbose_failures \
    --worker_verbose \
    //experimental/dotnet_core_runtime:dotnet_core_runtime

bazel run \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_loading_progress \
    --show_progress \
    --show_progress_rate_limit=1 \
    --show_timestamps \
    --verbose_failures \
    --worker_verbose \
    //experimental/dotnet_core_runtime:dotnet_core_runtime

docker run \
    --cpus 1 \
    --memory 256M \
    --rm \
    bazel/experimental/dotnet_core_runtime:dotnet_core_runtime_debian10 \
    dotnet --list-runtimes

# -----------------------------------

bazel build \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_loading_progress \
    --show_progress \
    --show_progress_rate_limit=1 \
    --show_timestamps \
    --verbose_failures \
    --worker_verbose \
    //experimental/dotnet_core_runtime:debug

bazel run \
    --announce_rc \
    --attempt_to_print_relative_paths \
    --color=yes \
    --curses=no \
    --host_force_python=PY2 \
    --show_loading_progress \
    --show_progress \
    --show_progress_rate_limit=1 \
    --show_timestamps \
    --verbose_failures \
    --worker_verbose \
    //experimental/dotnet_core_runtime:debug

docker run \
    --cpus 1 \
    --memory 256M \
    --rm \
    bazel/experimental/dotnet_core_runtime:debug_debian10 \
    dotnet --info

# ----------------------------------------------------------------------

# bazel build --host_force_python=PY2 --curses=no //experimental/dotnet:dotnet_debian9
# bazel build --host_force_python=PY2 --curses=no //experimental/dotnet:dotnet_debian10
# bazel run --host_force_python=PY2 --curses=no //experimental/dotnet:dotnet_debian9
# bazel run --host_force_python=PY2 --curses=no //experimental/dotnet:dotnet_debian10
# bazel test --host_force_python=PY2 --curses=no --test_output=errors //experimental/dotnet:dotnet_debian9
# bazel test --host_force_python=PY2 --curses=no --test_output=errors //experimental/dotnet:dotnet_debian10

bazel shutdown --iff_heap_size_greater_than=1
