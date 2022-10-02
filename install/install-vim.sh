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
# homepage: https://www.vim.org https://github.com/vim/vim
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)

PKG_DEB="git make cmake build-essential libncurses5-dev libatk1.0-dev"
PKG_DEB="$PKG_DEB libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1"
PKG_DEB="$PKG_DEB liblua5.1-dev libperl-dev"

GIT_SRC="https://github.com/vim/vim.git"
GIT_SRC_BRANCH="master"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME fetching source..."
    sudo -u $CURRENT_USER mkdir ./vim_build &&
        cd vim_build &&
        CLEANUP_LIST=$(pwd) &&
        sudo -u $CURRENT_USER git clone --recursive $GIT_SRC
}

git_checkout_latest() {
    # switch to branch
    git checkout $GIT_SRC_BRANCH &&
        # list git tags
        #   find tag formatted as X.Y.Z, where X, Y, Z are numbers
        #       sort naturally i.e. human versioning
        #           return last item from sorted list of versions
        sudo -u $CURRENT_USER git checkout tags/$(git tag -l | grep -Eo v[0-9]+\.[0-9]+\.[0-9]+ | sort -V | tail -n 1)
}

checkout_latest_ver() {
    echo "$SNAME checking out latest version"
    # switch to vim repository
    cd vim &&
        # checkout latest vim release
        git_checkout_latest
}

make_install() {
    echo "$SNAME configuring..."
    sudo -u $CURRENT_USER CFLAGS="-march=native -O2" ./configure  \
            --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=no \
            --disable-gtktest \
            --enable-cscope \
            --enable-terminal \
            --with-compiledby="$CURRENT_USER" \
            --prefix=/usr/local &&
        echo "$SNAME building..." &&
        sudo -u $CURRENT_USER make -j$(nproc) VIMRUNTIMEDIR=/usr/local/share/vim/vim$(git tag -l | grep -Eo v[0-9]+\.[0-9]+ | sort -V | tail -n 1 | sed s/v//g | sed s/\\.//g) &&
        make install
}

update_alts() {
    update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
    update-alternatives --set editor /usr/local/bin/vim
    update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
    update-alternatives --set vi /usr/local/bin/vim
}

cleanup() {
    cd $DIR_INIT
    if ! [ "$1" = "--cleanup" ]; then return 0; fi
    echo "$SNAME cleaning up: $CLEANUP_LIST"
    rm -rf $CLEANUP_LIST
}

install_vim() {
    install_deps &&
        fetch_src &&
        checkout_latest_ver &&
        make_install &&
        update_alts &&
        cleanup $@
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_vim $@


