#!/bin/bash

LABEL="$1"; REF="$2"

. ./config.sh

# functions
error() {
	telegram-send "Error⚠️: $@"
	exit 1
}

success() {
	telegram-send "Success: $@"
	exit 0
}

inform() {
	telegram-send --format html $@"
}

usage() {
	inform " ./build.sh 
		--compiler   sets the compiler to be used
		--device     sets the device for kernel build
		--silence    Silence shell output of Kbuild"
	exit 2
}

process_build () {
    # Used by compiler
    export CC_FOR_BUILD=clang
    export LOCALVERSION="-${FULLNAME}"
    # Remove defconfig localversion to prevent overriding
    sed -i -r "s/(CONFIG_LOCALVERSION=).*/\1/" "${KERNEL_DIR}/arch/arm64/configs/${DEFCONFIG}"

       # Build Start
	BUILD_START=$(date +"%s")

	inform "
		*************Build Triggered*************
		Date: <code>$(date +"%Y-%m-%d %H:%M")</code>
		Build Type: <code>$BUILD_TYPE</code>
		Device: <code>$DEVICENAME</code>
		Codename: <code>$CODENAME</code>
	"

    make O=out ARCH=arm64 ${DEFCONFIG}
    make -j$(nproc --all) O=out \
        ARCH=arm64 \
      #  CC="${CLANG}" \
      #  CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE="${CROSS_COMPILE}" \
   #     CROSS_COMPILE_ARM32=arm-linux-androideabi- \
        KBUILD_COMPILER_STRING="$(${CLANG} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')" \
    
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

   telegram-send --file *-signed.zip
   
echo "Building ${FULLNAME} ..."
process_build
BUILD_SUCCESS=$?

success "build completed in $(($DIFF / 60)).$(($DIFF % 60)) mins"

if [ ${BUILD_SUCCESS} -eq 0 ]; then
    echo "Done!"
    # Save for use by later build stages
    git log -1 > "${REPO_ROOT}/$(git rev-parse HEAD).txt"
    # Some stats
    ccache --show-stats
else
      error 'while building!'
fi

cd "${REPO_ROOT}"
exit ${BUILD_SUCCESS}
