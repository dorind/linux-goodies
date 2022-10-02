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
# homepage: https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)
VERSION=""

PKG_DEB="git wget autoconf automake libtool curl make g++ unzip zlib1g zlib1g-dev"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    if [ ! -z "$VERSION" ]; then
        URL_PATH="/protocolbuffers/protobuf/releases/download/v$VERSION/protobuf-all-$VERSION.tar.gz";
    else
        URL_PATH=$(wget -qO- https://github.com/protocolbuffers/protobuf/releases/latest | grep -Eo \"\/protocolbuffers\/protobuf\/releases\/download\/v[0-9]+\.[0-9]+\.[0-9]+\/protobuf\-all\-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz\" | tr -d '"')
    fi
    URL_DL="https://www.github.com$URL_PATH"
    NAME=$(basename $URL_PATH)
    CLEANUP_LIST="$CLEANUP_LIST $NAME"
    echo "$SNAME fetching source from $URL_DL"
    sudo -u $CURRENT_USER wget $URL_DL &&
        sudo -u $CURRENT_USER tar -zxf $NAME &&
        DIR_NAME=$(basename $(tar -tf $NAME | head -n 1)) &&
        CLEANUP_LIST="$CLEANUP_LIST $DIR_NAME" &&
        cd $DIR_NAME
}

make_install() {
    echo "$SNAME make install..."
    sudo -u $CURRENT_USER ./autogen.sh &&
        sudo -u $CURRENT_USER ./configure --with-system-zlib &&
        sudo -u $CURRENT_USER make -j$(nproc) &&
        sudo -u $CURRENT_USER make check -j$(nproc) &&
        make install &&
        ldconfig
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then exit 0; fi
    echo "cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_protobuf() {
    install_deps &&
        fetch_src &&
        make_install &&
        cleanup $@
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
        "--version="*) VERSION=$(echo $s | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+");;
    esac
done

install_protobuf $@


