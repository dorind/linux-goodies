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
# homepage: https://golang.org/
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)
GOLANG_URL="https://golang.org"
GOLANG_INSTALL_LOCATION="/usr/local"

PKG_DEB="wget"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_install() {
    echo "$SNAME checking for latest golang version"
    URL_DL=$(wget -qO- $GOLANG_URL/dl/ | grep -Eo \"/dl/go[0-9]*\.[0-9]*\.[0-9]*\.linux-amd64\.tar\.gz\" | tr -d '"' | head -n 1)
    if [ -z "$URL_DL" ]; then
        echo "$SNAME Error parsing download URL, take a look at fetch_install()"
        exit 1
    fi
    URL_DL=$GOLANG_URL$URL_DL
    GOLANG_VER_LATEST=$(basename $URL_DL)
    echo "Downloading $GOLANG_VER_LATEST from from $URL_DL"
    # download
    sudo -u $CURRENT_USER wget $URL_DL &&
        # extract sources
        echo "$SNAME extracting $GOLANG_VER_LATEST to $GOLANG_INSTALL_LOCATION" &&
        CLEANUP_LIST="$GOLANG_VER_LATEST" &&
        tar -C $GOLANG_INSTALL_LOCATION -xzf $GOLANG_VER_LATEST
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
    echo "$SNAME adding golang to your PATH in $SHRC"
    # export paths
    echo "" >> $SHRC
    echo "# golang" >> $SHRC
    echo "export PATH=\$PATH:$GOLANG_INSTALL_LOCATION/go/bin" >> $SHRC
    echo "" >> $SHRC
    echo "$SNAME reloading $SHRC"
    su $CURRENT_USER
    . $SHRC
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then return 0; fi
    echo "cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_golang() {
    install_deps &&
        fetch_install &&
        cleanup $@ &&
        exports
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_golang $@


