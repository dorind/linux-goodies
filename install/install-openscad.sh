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
# homepage: http://www.openscad.org/ https://github.com/openscad/openscad
#

#
# check examples in /usr/local/share/openscad/examples after installation
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST="build_openscad"
SNAME=$(basename $0)

PKG_DEB="build-essential git lib3mf-dev"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME fetching source..."
    sudo -u $CURRENT_USER git clone https://github.com/openscad/openscad build_openscad && 
        cd build_openscad &&
        sudo -u $CURRENT_USER git submodule update --init
}

git_checkout_latest() {
    echo "$SNAME checking out latest version..."
    # list git tags
    #   find tag formatted as openscad-20X.Y, where X, Y are numbers
    #       sort naturally i.e. human versioning
    #           return last item from sorted list of versions
    sudo -u $CURRENT_USER git checkout tags/$(git tag -l | grep -Eo openscad\-20[0-9]+\.[0-9]+ | sort -V | tail -n 1)
}

fetch_additional_deps() {
    echo "$SNAME fetching additional dependencies..."
    ./scripts/uni-get-dependencies.sh &&
        ./scripts/check-dependencies.sh
}

patch_cpp_ver() {
    echo "$SNAME patching cpp version to 14"
    sudo -u $CURRENT_USER sed -i 's/c++11/c++14/g' openscad.pro
}

make_install() {
    echo "$SNAME make install..."
    sudo -u $CURRENT_USER qmake openscad.pro &&
        sudo -u $CURRENT_USER env CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" make -j$(nproc) &&
        make install
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then exit 0; fi
    echo "cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_openscad() {
    install_deps &&
        fetch_src &&
        git_checkout_latest &&
        fetch_additional_deps &&
        patch_cpp_ver &&
        make_install &&
        cleanup $@
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_openscad $@


