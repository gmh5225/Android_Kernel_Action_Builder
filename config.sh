#!/bin/bash

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/bin/clang"
# export HOSTCXX="${REPO_ROOT}/data/gcc64/bin/aarch64-elf-g++" 
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
# export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/arm-eabi-"
# export CROSS_COMPILE_ARM32="${REPO_ROOT}/data/gcc/bin/arm-eabi-gcc-"
export ANYKERNEL_DIR="${REPO_ROOT}/data/anykernel"
export ANYKERNEL_IMAGE_DIR="${ANYKERNEL_DIR}"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"

# Define to enable ccache
if [ ! -z ${AKCI_CCACHE} ]; then
    export CLANG="ccache ${CLANG}"
    mkdir -p "ccache"
    export CCACHE_BASEDIR="${REPO_ROOT}"
    export CCACHE_DIR="${REPO_ROOT}/ccache"
    export CCACHE_COMPILERCHECK="content"
fi

# If not defined gives long compiler name
  export COMPILER_NAME="clang"
# export COMPILER_NAME="gcc"

# 'ld.lld'(default)
export LINKER=ld.lld

# Kernel config
# export DEFCONFIG="lisa-qgki_defconfig"
export DEFCONFIG="infinix_x573_defconfig"
export KERNEL_NAME="infinix-Kernel"

export KBUILD_BUILD_USER="skyhuppa"
export KBUILD_BUILD_HOST="github_runner"
export KBUILD_BUILD_VERSION=1.0
