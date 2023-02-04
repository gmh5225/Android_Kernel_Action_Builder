#!/bin/bash

echo "Cloning dependencies ..."

mkdir "data"

PIDS=""
./sync.sh https://github.com/skyhuppa/android_kernel_xiaomi_sm7325.git "data/kernel" "${REF}" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/mvaisakh/gcc-arm.git "data/gcc" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/skyhuppa/proton-clang.git "data/clang" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/skyhuppa/AnyKernel3.git "data/anykernel" "master" &
PIDS="${PIDS} $!"

for p in $PIDS; do
    wait $p || exit "$?"
done

echo "Done!"
