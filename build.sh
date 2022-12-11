#!/bin/bash

LABEL="$1"; REF="$2"
. ./config.sh

process_build () {
   # Used by compiler
   # export CC_FOR_BUILD=clang
    export LOCALVERSION="-${FULLNAME}"
   # export DEFCONFIG_PATH="${KERNEL_DIR}/arch/arm64/configs/vendor/lisa-qgki_defconfig"
   # Remove defconfig localversion to prevent overriding
  # sed -i -r "s/(CONFIG_LOCALVERSION=).*/\1/" "${KERNEL_DIR}/arch/arm64/configs/vendor/lisa-qgki_defconfig "
  # sed -i '13d;14d;15d;16d;17d' $KERNEL_DIR/scripts/depmod.sh

   # make O=out ARCH=arm64 vendor/lisa-qgki_defconfig 
    
 #   if [ $COMPILER_NAME = "GCC" ]
 #	then
 #   make O=out ARCH=arm64 vendor/lisa-qgki_defconfig 	
 #   make -j$(nproc --all)        O=out   \
   # MAKE+=(
 #			CROSS_COMPILE_ARM32=arm-eabi- \
 # 			CROSS_COMPILE=aarch64-elf- \
 #			AR=aarch64-elf-ar \
 #			OBJDUMP=aarch64-elf-objdump \
 #			STRIP=aarch64-elf-strip \
 #			NM=aarch64-elf-nm \
 #			OBJCOPY=aarch64-elf-objcopy \
 #			LD=aarch64-elf-$LINKER \
 #                      PATH=${REPO_ROOT}/data/gcc64/bin/aarch64-elf-g++ \
 #                      KBUILD_COMPILER_STRING=$("$GCC64_DIR"/bin/aarch64-elf-gcc --version | head -n 1) \
        
   
    make O=out ARCH=arm64 vendor/lisa-qgki_defconfig	
    make -j$(nproc --all)        O=out   \
  #  MAKE+=(
			CROSS_COMPILE=aarch64-linux-gnu- \
			CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
			CC=clang \
			AR=llvm-ar \
			OBJDUMP=llvm-objdump \
			STRIP=llvm-strip \
			NM=llvm-nm \
			OBJCOPY=llvm-objcopy \
			PATH=${REPO_ROOT}/data/clang/bin \
                        KBUILD_COMPILER_STRING="$(${CLANG} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')" \
          
	  
    BUILD_SUCCESS=$?
    
    if [ ${BUILD_SUCCESS} -eq 0 ]; then
        mkdir -p "${ANYKERNEL_IMAGE_DIR}"
        cp -f "${KERNEL_DIR}/out/arch/arm64/boot/Image" "${ANYKERNEL_IMAGE_DIR}/Image"
        cd "${ANYKERNEL_DIR}"
        zip -r9 "${REPO_ROOT}/${FULLNAME}.zip" * -x README
        cd -
    fi
    
    rm -rf "${KERNEL_DIR}/out"
    rm "${ANYKERNEL_IMAGE_DIR}/Image"
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
