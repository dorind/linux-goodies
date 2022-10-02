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

if [ $(id -u) -eq 0 ]; then
    echo "Please run script without root privileges"
    exit 1
fi

CURRENT_USER=${SUDO_USER:-$(whoami)}

cfg_xfce_thunar() {
    # quit thunar before attempting to change settings
    thunar -q
    
    # set default view
    xfconf-query -n --channel thunar --property "/default-view" -t "string" -s "ThunarDetailsView"
    # set buttons in path
    xfconf-query -n --channel thunar --property "/last-location-bar" -t "string" -s "ThunarLocationButtons"
    # set small icons in side pane
    xfconf-query -n --channel thunar --property "/shortcuts-icon-size" -t "string" -s "THUNAR_ICON_SIZE_24"
    # remember positions
    xfconf-query -n --channel thunar --property "/misc-remember-geometry" -t "bool" -s "true"
    # show full path in title
    xfconf-query -n --channel thunar --property "/misc-full-path-in-title" -t "bool" -s "true"
    # always show tabs
    #xfconf-query -n --channel thunar --property "/misc-always-show-tabs" -t "bool" -s "true"

    # start thunar, because why not?
    #thunar &
}

cfg_gtk_bookmarks() {
    BFS="/home/$CURRENT_USER/.config/gtk-3.0"
    mkdir -p $BFS
    BFS="$BFS/bookmarks"
    echo "file:///home/$CURRENT_USER/Documents/" >> $BFS
    echo "file:///home/$CURRENT_USER/Downloads/" >> $BFS
    echo "file:///home/$CURRENT_USER/Pictures/" >> $BFS
    echo "file:///home/$CURRENT_USER/Videos/" >> $BFS
}

cfg_gtk_bookmarks &&
    cfg_xfce_thunar   


