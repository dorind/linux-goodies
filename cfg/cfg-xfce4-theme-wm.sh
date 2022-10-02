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

SNAME=$(basename $0)
REQ_PKG_DEB="arc-theme obsidian-icon-theme"

if [ $(id -u) -eq 0 ]; then
    echo "$SNAME Error: Please run script without root privileges"
    exit 1
fi

# check if required packages are installed
MISSING_PKG=""
for pkg in $REQ_PKG_DEB
do
    RESULT=$(dpkg -l | grep "$pkg")
    if [ -z "$RESULT" ]; then
        MISSING_PKG="$MISSING_PKG $pkg"
    fi
done

if [ ! -z "$MISSING_PKG" ]; then
    echo "$SNAME Error: Missing required package(s): $MISSING_PKG"
    exit 1
fi

cfg_xfce_theme_wm() {
    # set theme
    xfconf-query --channel xsettings --property "/Net/ThemeName" -s "Arc"
    # set icons
    xfconf-query --channel xsettings --property "/Net/IconThemeName" -s "Obsidian-Aqua-SemiLight"
    # set wm theme
    xfconf-query --channel xfwm4 --property "/general/theme" -s "Arc-Dark"
    # align window title to left
    xfconf-query --channel xfwm4 --property "/general/title_alignment" -s "left"
    # center screen new windows
    xfconf-query --channel xfwm4 --property "/general/placement_ratio" -s 60
    # enable compositor
    xfconf-query --channel xfwm4 --property "/general/use_compositing" -s "true"
    # enable zoom with SUPER-MOUSE WHEEL
    xfconf-query --channel xfwm4 --property "/general/easy_click" -s "Super"
    xfconf-query --channel xfwm4 --property "/general/zoom_desktop" -s "true"
    # window title bar buttons: close to the left, minimize to the right
    xfconf-query --channel xfwm4 --property "/general/button_layout" -s "C|H"
    # no session save
    xfconf-query -n --channel xfce4-session --property "/general/SaveOnExit" -t "bool" -s "false"
}

cfg_xfce_theme_wm


