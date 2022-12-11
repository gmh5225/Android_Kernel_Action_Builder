#!/bin/bash

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/bin/clang"
# export HOSTCXX="${REPO_ROOT}/data/gcc/bin/aarch64-elf-g++" 
# export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-elf-"
export CC_32="${REPO_ROOT}/data/gcc/bin/arm-eabi-"
export CC_COMPAT="${REPO_ROOT}/data/gcc/bin/arm-eabi-gcc"
export ANYKERNEL_DIR="${REPO_ROOT}/data/anykernel"
export ANYKERNEL_IMAGE_DIR="${ANYKERNEL_DIR}"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"
export DEFCONFIG_PATH="${KERNEL_DIR}/arch/arm64/configs/vendor/lisa-qgki_defconfig"


# Define to enable ccache
if [ ! -z ${AKCI_CCACHE} ]; then
    export CLANG="ccache ${CLANG}"
    mkdir -p "ccache"
    export CCACHE_BASEDIR="${REPO_ROOT}"
    export CCACHE_DIR="${REPO_ROOT}/ccache"
    export CCACHE_COMPILERCHECK="content"
fi

# If not defined gives long compiler name
# export COMPILER_NAME="CLANG"

# Kernel config
export DEFCONFIG="lisa_qgki_defconfig"
export KERNEL_NAME="lisa-Kernel"

export KBUILD_BUILD_USER="elf"
export KBUILD_BUILD_HOST="buildstation"
export KBUILD_BUILD_VERSION=1
