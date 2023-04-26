#!/bin/bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)

source ${REPO_ROOT}/tools/ci/helper_functions.sh

# setup distribution folder
DIST_DIR=${REPO_ROOT}/dist_host
mkdir -p ${DIST_DIR}

# row format is: "target     copy_path"
applications=(
    "datapartition_mkimage   tools/datapartition_mkimage"
)

# perform builds
path="${REPO_ROOT}"
echo '******************************************************'
echo '* Building host applications'
echo '******************************************************'

(cd ${path}; rm -rf build_host)
(cd ${path}; mkdir -p build_host)
(cd ${path}/build_host; log_errors cmake ../)

for ((i = 0; i < ${#applications[@]}; i += 1)); do
    read -ra FIELDS <<< ${applications[i]}
    target="${FIELDS[0]}"
    copy_path="${FIELDS[1]}"
    (cd ${path}/build_host; log_errors make ${target} -j)
    (cd ${path}/build_host; cp ${copy_path}/${target} ${DIST_DIR})
done