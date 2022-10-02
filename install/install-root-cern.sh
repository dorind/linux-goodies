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
# homepage: https://root.cern.ch
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)
ROOT_URL_DL_BASE="https://root.cern.ch/download/"
ROOT_URL_DL_LIST=$ROOT_URL_DL_BASE
ROOT_VER_LATEST="root"

PKG_DEB="wget git build-essential manpages-dev llvm cmake"
PKG_DEB="$PKG_DEB libx11-dev libxpm-dev libxft-dev libxext-dev libtiff5-dev"
PKG_DEB="$PKG_DEB libgif-dev libgsl-dev libpython-dev libkrb5-dev libxml2-dev"
PKG_DEB="$PKG_DEB libssl-dev default-libmysqlclient-dev libpq-dev libqt4-opengl-dev"
PKG_DEB="$PKG_DEB libgl2ps-dev libpcre-ocaml-dev libgraphviz-dev libdpm-dev"
PKG_DEB="$PKG_DEB unixodbc-dev libsqlite3-dev libfftw3-dev libcfitsio-dev dcap-dev"
PKG_DEB="$PKG_DEB libldap2-dev libavahi-compat-libdnssd-dev"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME checking for latest ROOT version"
    ROOT_VER_LATEST=$(wget -qO- $ROOT_URL_DL_LIST | grep -Eo \"root_v[0-9]+\.[0-9]+\.[0-9]+\.source\.tar\.gz\" | uniq | tr -d '"' | sort -V | tail -n 1)
    echo "$SNAME latest ROOT version: $ROOT_VER_LATEST"
    URL_DL=$ROOT_URL_DL_BASE$ROOT_VER_LATEST
    echo "Downloading ROOT from $URL_DL"
    # download
    sudo -u $CURRENT_USER wget $URL_DL &&
        # extract sources
        echo "$SNAME extracting sources..." &&
        CLEANUP_LIST="$CLEANUP_LIST $ROOT_VER_LATEST" &&
        sudo -u $CURRENT_USER tar -zxf $ROOT_VER_LATEST &&
        # switch to build dir
        cd root*/build
}

make_install() {
    # configure
    echo "$SNAME configuring..."
    sudo -u $CURRENT_USER cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/opt/root -Dgnuinstall=ON &&
        # build
        echo "$SNAME building..." &&
        sudo -u $CURRENT_USER make -j$(nproc) &&
        # install
        echo "$SNAME installing..." &&
        make install &&
        # refresh dynamic linker
        ldconfig
}

exports() {
    SHRC="/home/$CURRENT_USER"
    if [ "$(which bash)" != "" ]; then
        SHRC="$SHRC/.bashrc"
    elif [ "$(which zsh)" != "" ]; then
        SHRC="$SHRC/.zshrc"
    else
        echo "$SNAME unhandled case, bailing out!"
        exit 1
    fi
    echo "$SNAME adding ROOT to your PATH in $SHRC"
    # export paths
    echo "export ROOTSYS=/usr/opt/root" >> $SHRC
    echo "export PATH=\$PATH:\$ROOTSYS/bin" >> $SHRC
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ROOTSYS/lib/root" >> $SHRC
    echo "$SNAME reloading $SHRC"
    su $CURRENT_USER
    . $SHRC
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then exit 0; fi
    echo "cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_root() {
    install_deps &&
        fetch_src &&
        make_install &&
        exports &&
        cleanup $@
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_root $@


