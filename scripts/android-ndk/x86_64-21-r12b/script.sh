#!/usr/bin/env bash

MASON_NAME=android-ndk
MASON_VERSION=x86_64-21-r12b
MASON_LIB_FILE=

. ${MASON_DIR}/mason.sh

function mason_load_source {
    if [ ${MASON_PLATFORM} = 'osx' ]; then
        mason_download \
            https://dl.google.com/android/repository/android-ndk-r12b-darwin-x86_64.zip \
            1a3bbdde35a240086b022cdf13ddcf40c27caa6e
    elif [ ${MASON_PLATFORM} = 'linux' ]; then
        mason_download \
            https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip \
            c6286e131c233c25537a306eae0a29d50b352b91
    fi

    mason_setup_build_dir
    rm -rf ./android-ndk-r12b
    unzip -q ../.cache/${MASON_SLUG} $@

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/android-ndk-r12b
}

function mason_compile {
    rm -rf ${MASON_PREFIX}
    mkdir -p ${MASON_PREFIX}

    ${MASON_BUILD_PATH}/build/tools/make_standalone_toolchain.py \
        --force \
        --arch x86_64 \
        --api 21 \
        --stl libc++ \
        --install-dir "${MASON_PREFIX}"

    # NDK r12 ships with .so files which are preferred when linking, but cause
    # errors on devices when it's not present.
    find "${MASON_PREFIX}" -name "libstdc++.so" -delete
}

function mason_clean {
    make clean
}

function mason_cflags {
    :
}

function mason_ldflags {
    :
}

function mason_static_libs {
    :
}

mason_run "$@"
