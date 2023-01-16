#!/bin/bash

echo "Syncing dependencies ..."

mkdir "data"

PIDS=""
# ./sync.sh https://github.com/skyhuppa/android_kernel_xiaomi_sm7325.git "data/kernel" "${REF}" &
./sync.sh https://github.com/LineageOS/android_kernel_xiaomi_msm8998.git "data/kernel" "${REF}" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/skyhuppa/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git "data/gcc" &
# ./sync.sh https://github.com/mvaisakh/gcc-arm64.git "data/gcc" &
#./sync.sh https://github.com/mvaisakh/gcc-arm.git "data/gcc" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/skyhuppa/proton-clang.git "data/clang" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/skyhuppa/AnyKernel3.git "data/anykernel" "master" &
PIDS="${PIDS} $!"

for p in $PIDS; do
    wait $p || exit "$?"
done

echo "Done!"
