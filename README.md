# Android Kernel Github Action Builder
A generic auto-build repo for Android kernels using various Continuous Integration services

## Credit
*  ViRb3--> Files taken from [https://github.com/ViRb3/android-kernel-ci]

## Features
* OnePlus 5T ARM64 preset
* RedFlare kernel by Tresk
* Automatic versioning

## Usage
Run a new pipeline, optionally defining variables
### Variables
* `AKCI_REF` - git tag or branch to build from
* `AKCI_LABEL` - label to use for kernel. If not defined, kernel will be labeled with short git commit hash
* `AKCI_CCACHE` - whether to use ccache. Define to enable, default: `undefined`
### Examples
* *no variables* 
    * builds from latest `HEAD` commit `320408e0`
    * produces `Redflare-Kernel-SNAPSHOT-320408e0.zip`
* REF="alpha"
    * builds from latest tag or branch `alpha` commit `73a05b11`
    * produces `Redflare-Kernel-SNAPSHOT-73a05b11.zip`
* LABEL="1.0"
    * builds from latest `HEAD` commit `320408e0`
    * produces `Redflare-Kernel-1.0.zip`
* REF="alpha" LABEL="1.0"
    * builds from latest tag or branch `alpha` commit `73a05b11`
    * produces `Redflare-Kernel-1.0.zip`

## Configuring
Check `config.sh` and `build-deps.sh`

## Notes
### How to use
Do not flash the artifacts, extract them and use lmage.gz-dtb or use Android Image Kitchen to unpack boot.img replce lmage.gz-dtb
### Github Actions
Release can be added, but ZIPs are uploaded to [transfer.sh](https://transfer.sh) and stored for 14 days.
