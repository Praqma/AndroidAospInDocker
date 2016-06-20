#!/bin/bash

prebuilts/misc/linux-x86/ccache/ccache -M 50G
source build/envsetup.sh
lunch aosp_flo-userdebug
make installclean
make clean
time make -j3 
