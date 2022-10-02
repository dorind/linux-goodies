#!/bin/sh

#
# Author Dorin-Tfeia Duminică. All rights reserved.
# Redistribution(s) and/or use(s) and/or representation(s) in source
# and/or binary and/or other form(s) with or without modification(s) are
# permitted only with explicit written consent of the Author during the
# period in which the Author is in possession of the written consent.
# Any direct and/or indirect unauthorized use(s) and/or reproduction(s)
# and/or representation(s) in part or in whole without explicit written
# consent from the Author shall cease and the material shall be deleted
# permanently or the support on which the material resides in part or in
# whole shall be destroyed effective immediately without notice and/or
# request from or by the Author Dorin-Tfeia Duminică. 
# The Author shall remain the sole copyright holder, rights holder,
# beneficiery, controller, regardless of the law(s) of the state(s) in
# which part(s) of the material created and/or developed and/or
# transited and/or is being stored and/or the Author resides.
# The Author assumes zero liability for any and all potential damages
# incurred directly and/or indirectly in any way and/or and/or shape
# and/or form by use and/or misuse including, but not limited to,
# known issue(s) of or with the material created and/or developed by the
# Author with and/or without intention of any type and/or nature.
# Copyright(c) Dorin-Tfeia Duminică. All rights reserved.
#

#
# homepage: https://opencv.org/
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)

# debian packages
# python 2
PKG_DEB="python-opencv python-opencv-apps python-dev python-numpy"

# python 3
PKG_DEB="$PKG_DEB python3-opencv python3-opencv-apps python3-dev python3-numpy"

# misc
PKG_DEB="$PKG_DEB build-essential cmake git pkg-config libgtk-3-dev libopenjp2-7-dev libqt5gstreamer-dev x264 v4l-utils"
PKG_DEB="$PKG_DEB zlib1g-dev libtbb2 libtbb-dev libdc1394-22-dev"

# ffmpeg libs
PKG_DEB="$PKG_DEB libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libavresample-dev"
PKG_DEB="$PKG_DEB libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev"
PKG_DEB="$PKG_DEB gfortran openexr libatlas-base-dev"

# opencl
PKG_DEB="$PKG_DEB beignet-opencl-icd"

# Library of linear algebra
PKG_DEB="$PKG_DEB liblapacke liblapacke-dev libeigen3-dev libopenblas-base libopenblas-dev"

# protobuf
if [ -z "$(ls -1 /usr/lib/x86_64-linux-gnu/ | grep libprotobuf)" ]; then
    # protobuf is missing
	PKG_DEB="$PKG_DEB libprotobuf-dev protobuf-compiler"
fi

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME fetching sources..."
    sudo -u $CURRENT_USER mkdir -p ./opencv_build &&
        cd opencv_build &&
        CLEANUP_LIST=$(pwd) &&
        sudo -u $CURRENT_USER git clone https://github.com/opencv/opencv.git &&
        sudo -u $CURRENT_USER git clone https://github.com/opencv/opencv_contrib.git &&
        sudo -u $CURRENT_USER mkdir ./opencv/build
}

git_checkout_latest() {
    # list git tags
    #   find tag formatted as X.Y.Z, where X, Y, Z are numbers
    #       sort naturally i.e. human versioning
    #           return last item from sorted list of versions
    sudo -u $CURRENT_USER git checkout tags/$(git tag -l | grep -Eo [0-9]+\.[0-9]+\.[0-9]+ | sort -V | tail -n 1)
}

checkout_latest_ver() {
    echo "$SNAME checking out latest version..."
    # switch to opencv repository
    cd opencv &&
        # checkout latest opencv release
        git_checkout_latest &&
        # switch to opencv contrib repository
        cd ../opencv_contrib &&
        # checkout latest opencv_contrib release
        git_checkout_latest &&
        # switch to opencv build directory
        cd ../opencv/build
}

make_install() {
    echo "$SNAME make install..."
    sudo -u $CURRENT_USER cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_TBB=ON \
        -D WITH_V4L=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON .. &&
        sudo -u $CURRENT_USER make -j$(nproc) &&
        make install
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then return 0; fi
    echo "cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_opencv() {
    install_deps &&
        fetch_src &&
        checkout_latest_ver &&
        make_install &&
        cleanup $@
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_opencv $@


