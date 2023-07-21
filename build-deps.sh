#!/bin/bash

. ./sync.sh

echo "Cloning dependencies ..."

# ./sync.sh https://github.com/skyhuppa/kernel_land.git "data/kernel" "${REF}" &
gut https://github.com/skyhuppa/Kernel_Infinix_HotS3_X573_TestBuild.git -b Test_Build data/kernel
# ./sync.sh https://github.com/skyhuppa/android_kernel_motorola_msm8937-2.git "data/kernel" "${REF}" &
gut https://github.com/skyhuppa/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git -b lineage-19.0 data/gcc
# ./sync.sh https://github.com/skyhuppa/gcc.git "data/gcc" &
gut https://github.com/skyhuppa/proton-clang.git -b master data/clang
gut https://github.com/skyhuppa/AnyKernel3.git -b master "data/anykernel" maste

echo "Done!"
