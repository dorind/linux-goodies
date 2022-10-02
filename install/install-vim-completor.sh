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
# homepage: https://github.com/maralla/completor.vim
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

GIT_SRC="https://github.com/maralla/completor.vim.git"
GIT_SRC_BRANCH="master"
INSTALL_DIR="$USER_HOME/.vim/pack/completor/start/completor.vim"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_src() {
    echo "$SNAME fetching source..."
        sudo -u $CURRENT_USER git clone --recursive $GIT_SRC $INSTALL_DIR
}

cfg_completor_vim() {
    VIMRC="$USER_HOME/.vimrc"
    sudo -u $CURRENT_USER echo "\"completor vim" >> $VIMRC
    
    # clang autocompletion
    BIN_CLANG=$(command -v clang)
    if [ ! -x "$BIN_CLANG" ]; then
        echo "$SNAME clang not found"
        echo "\"let g:completor_clang_binary = '/path/to/clang'" >> $VIMRC
    else
        echo "$SNAME enabling clang"
        echo "let g:completor_clang_binary = '$BIN_CLANG'" >> $VIMRC
    fi
    
    # golang autocompletion
    # $ go get -u github.com/nsf/gocode
    # add to your PATH
    BIN_GOCODE=$(command -v gocode)
    if [ ! -x "$BIN_GOCODE" ]; then
        echo "$SNAME gocode not found"
        echo "\"let g:completor_gocode_binary = '/path/to/gocode'" >> $VIMRC
    else
        echo "$SNAME enabling gocode"
        echo "let g:completor_gocode_binary = '$BIN_GOCODE'" >> $VIMRC
    fi
    
    # nodejs autocompletion
    # $ sudo apt-get install -y nodejs
    BIN_NODE=$(command -v node)
    if [ ! -x "$BIN_NODE" ]; then
        echo "$SNAME node not found"
        echo "\"let g:completor_node_binary = '/path/to/node'" >> $VIMRC
    else
        echo "$SNAME enabling node"
        echo "let g:completor_node_binary = '$BIN_NODE'" >> $VIMRC
    fi
    
    # rust
    # $ rustup toolchain add nightly && cargo +nightly install racer
    # add racer to your path
    BIN_RACER=$(command -v racer)
    if [ ! -x "$BIN_RACER" ]; then
        echo "$SNAME racer not found"
        echo "\"let g:completor_racer_binary = '/path/to/racer'" >> $VIMRC
    else
        echo "$SNAME enabling rust"
        echo "let g:completor_racer_binary = '$BIN_RACER'" >> $VIMRC
    fi
    
    echo "" >> $VIMRC
}

install_completor_vim() {
    install_deps &&
        fetch_src &&
        cfg_completor_vim
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
        "--config") cfg_completor_vim; exit 0;;
    esac
done

install_completor_vim $@


