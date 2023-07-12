#!/bin/bash

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/bin/clang"
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
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
export COMPILER_NAME="GCC"

# Kernel config
 export DEFCONFIG="infinix_x573_defconfig"
 export KERNEL_NAME="Infinix-X573-Kernel"
# export DEFCONFIG="X573_defconfig"
# export KERNEL_NAME="X573-Kernel"

export KBUILD_BUILD_USER="skyhuppa"
export KBUILD_BUILD_HOST="github_runner"
export KBUILD_BUILD_VERSION=1.0

export DEVICENAME='Infinix Hot S3'
export CODENAME='Infinix-X573'	

# Setup Telegram API 
	pip -q install telegram-send
	git clone https://github.com/rahiel/telegram-send -b master -q telegram-send
	sed -i s/demo1/${BOT_API_KEY}/g telegram-send.conf
	sed -i s/demo2/${CHAT_ID}/g telegram-send.conf
       # mkdir $HOME/.config
	mv telegram-send.conf $HOME/.config/telegram-send.conf
