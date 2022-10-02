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
# homepage: http://liteide.org/en/ https://github.com/visualfc/liteide
#

CURRENT_USER=${SUDO_USER:-$(whoami)}
DIR_INIT=$(pwd)
CLEANUP_LIST=""
SNAME=$(basename $0)
LITEIDE_INSTALL_LOCATION="/usr/local"
LITEIDE_INSTALL_BIN=""
ICON_PATH="/usr/share/icons/hicolor/scalable/apps/liteide.svg"
ICON_REMOTE="https://raw.githubusercontent.com/dorind/nix-goodies/master/res/icons/liteide.svg"

PKG_DEB="wget qt5-default"

install_deps() {
    echo "$SNAME installing dependencies: $PKG_DEB"
    apt-get install -y $PKG_DEB
}

fetch_install() {
    URL_PATH=$(wget -qO- https://github.com/visualfc/liteide/releases/latest | grep -Eo \"\/visualfc\/liteide\/releases\/download\/x[0-9]+\.[0-9]\/liteidex[0-9]+\.[0-9]\.linux64\-qt5\.[0-9]+\.[0-9]+\.tar\.gz\" | tr -d '"')
    URL_DL="https://www.github.com$URL_PATH"
    NAME=$(basename $URL_PATH)
    CLEANUP_LIST="$NAME"
    echo "$SNAME fetching latest version from $URL_DL"
    sudo -u $CURRENT_USER wget $URL_DL &&
        tar -C $LITEIDE_INSTALL_LOCATION -xzf $NAME &&
        LITEIDE_INSTALL_BIN=$LITEIDE_INSTALL_LOCATION/liteide/bin
}

setup_app() {
    FDESK="/usr/local/share/applications" &&
        mkdir -p $FDESK &&
        FDESK="$FDESK/liteide.desktop"
    echo "$SNAME creating desktop entry $FDESK"
    wget -O $ICON_PATH $ICON_REMOTE || true
    echo "[Desktop Entry]" >> $FDESK
    echo "Name=LiteIDE" >> $FDESK
    echo "Comment=Code Editing" >> $FDESK
    echo "GenericName=Text Editor" >> $FDESK
    echo "Exec=$LITEIDE_INSTALL_BIN/liteide" >> $FDESK
    echo "Icon=$ICON_PATH" >> $FDESK
    echo "Type=Application" >> $FDESK
    echo "StartupNotify=false" >> $FDESK
    echo "Categories=Utility;TextEditor;Development;IDE;" >> $FDESK
    echo "Keywords=liteide;" >> $FDESK
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
    echo "$SNAME adding LiteIDE to your PATH in $SHRC"
    # export paths
    echo "" >> $SHRC
    echo "# liteide" >> $SHRC
    echo "export PATH=\$PATH:$LITEIDE_INSTALL_BIN" >> $SHRC
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

install_liteide() {
    install_deps &&
        fetch_install &&
        cleanup $@ &&
        setup_app &&
        exports
}

for s in "$@"
do
    case $s in
        "--PKG_DEB") echo $PKG_DEB; exit 0;;
    esac
done

install_liteide $@


