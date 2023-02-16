#!/bin/bash

LABEL="$1"; REF="$2"
. ./config.sh

menucommand="${1:-menuconfig}"
MAKE_ARGS="${@:2}"

if [[ "${menucommand}" =~ "*config" ]]; then
MAKE_ARGS="$*"
menucommand="menuconfig"

fi

POST_DEFCONFIG_CMDS="menuconfig ${menucommand} && ${POST_DEFCONFIG_CMDS}"

process_build () {
    # Used by compiler
    # export CC_FOR_BUILD=clang
    export LOCALVERSION="-${FULLNAME}"
    export menuconfig
    export MAKEFLAGS="-j$(nproc) ${MAKEFLAGS}"
    # Remove defconfig localversion to prevent overriding
    sed -i -r "s/(CONFIG_LOCALVERSION=).*/\1/" "${KERNEL_DIR}/arch/arm64/configs/${DEFCONFIG}"
    sed -i '13d;14d;15d;16d;17d' $KERNEL_DIR/scripts/depmod.sh

# Clean source prior building. 1 is NO(default) | 0 is YES
INCREMENTAL='1'

# Silence the compilation
# 1 is YES(default) | 0 is NO
    SILENCE='1'

   make O=work ARCH=arm64 ${DEFCONFIG}
#   make -j$(nproc)  O=work
   MAKE_ARGS=( "$@" ) 
         LLVM=1     \
         LLVM_IAS=1  \
         HOSTLD=ld.lld  \
         ARCH=arm64     \   
         CC="${CLANG}"   \
         CC_COMPAT="$CC_COMPAT"   \           
         CROSS_COMPILE_COMPAT="$CC_32"   \
       # LD_LIBRARY_PATH="${REPO_ROOT}/data/clang/lib"  \
         KBUILD_COMPILER_STRING="$(${clang} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')" 
      
    BUILD_SUCCESS=$?
    
    if [ ${BUILD_SUCCESS} -eq 0 ]; then
        mkdir -p "${ANYKERNEL_IMAGE_DIR}"
        cp -f "${KERNEL_DIR}/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
        cd "${ANYKERNEL_DIR}"
        zip -r9 "${REPO_ROOT}/${FULLNAME}.zip" * -x README
        cd -
    fi
    
    rm -rf "${KERNEL_DIR}/out"
    rm "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
    return ${BUILD_SUCCESS}
}

cd "${KERNEL_DIR}"

# Ensure the kernel has a label
if [ -z "${LABEL}" ]; then
    LABEL="TESTBUILD-$(git rev-parse --short HEAD)"
fi
FULLNAME="${KERNEL_NAME}-${LABEL}"

echo "Building ${FULLNAME} ..."
process_build
BUILD_SUCCESS=$?

if [ ${BUILD_SUCCESS} -eq 0 ]; then
    echo "Done!"
    # Save for use by later build stages
    git log -1 > "${REPO_ROOT}/$(git rev-parse HEAD).txt"
    # Some stats
    ccache --show-stats
else
    echo "Error while building!"
fi

cd "${REPO_ROOT}"
exit ${BUILD_SUCCESS}
