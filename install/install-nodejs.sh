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
# homepage: https://github.com/nodesource/distributions/blob/master/README.md
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)
SCRIPT_URL="https://github.com/nodesource/distributions/blob/master/README.md"

PKG_DEB="wget build-essential"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

# bail, exec_cmd_nobail and exec_cmd shamelessly stolen from 
# https://deb.nodesource.com/setup_14.x
bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

fetch_install() {
    echo "$SNAME checking for latest nodejs version"
    URL_DL=$(wget -qO- $SCRIPT_URL | grep -Eo https:\/\/deb\.nodesource\.com\/setup_[0-9]+.x | sort -V | tail -n1)
    if [ -z "$URL_DL" ]; then
        echo "$SNAME Error parsing download URL, take a look at fetch_install()"
        exit 1
    fi
    echo "$SNAME latest version $URL_DL"
    exec_cmd "wget -qO- $URL_DL | bash -" &&
        apt-get install -y nodejs
}

install_nodejs() {
    install_deps &&
        fetch_install
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_nodejs


