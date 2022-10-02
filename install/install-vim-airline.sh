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
# homepage: https://github.com/vim-airline/vim-airline
#

#
# check your ~/.vimrc
# filetype plugin on
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
USER_HOME="/home/$CURRENT_USER"
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)

PKG_DEB="git"

GIT_SRC="https://github.com/vim-airline/vim-airline.git"
GIT_SRC_BRANCH="master"
INSTALL_DIR="$USER_HOME/.vim/pack/dist/start/vim-airline"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME fetching source..."
        sudo -u $CURRENT_USER git clone --recursive $GIT_SRC $INSTALL_DIR
}

git_checkout_latest() {
    # switch to branch
    git checkout $GIT_SRC_BRANCH &&
        # list git tags
        #   find tag formatted as X.Y, where X, Y are numbers
        #       sort naturally i.e. human versioning
        #           return last item from sorted list of versions
        sudo -u $CURRENT_USER git checkout tags/$(git tag -l | grep -Eo v[0-9]+\.[0-9]+ | sort -V | tail -n 1)
}

checkout_latest_ver() {
    echo "$SNAME checking out latest version"
    # switch to vim-airline repository
    cd $INSTALL_DIR &&
        # checkout latest vim-airline release
        git_checkout_latest
}

install_vim_airline() {
    install_deps &&
        fetch_src &&
        checkout_latest_ver
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_vim_airline $@



