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
# shortcut              action
#
# SUPER-D               show desktop
# SHIFT-SUPER-DOWN      tile windows down 
# SHIFT-SUPER-UP        tile windows up
# SUPER-1               workspace 1
# SUPER-2               workspace 2
# SUPER-3               workspace 3
# SUPER-4               workspace 4
# SUPER-LEFT            tile window left
# SUPER-RIGHT           tile window right
# SUPER-UP              maximize/restore window
#
# SUPER-E               thunar file manager
# SUPER-T               xfce terminal
# SUPER-R               xfce appfinder
# CTRL-ESC              xfce settings manager
# SHIFT-CTRL-ALT-!      flameshot capture screenshot
# SHIFT-CTRL-ALT-$      flameshot gui mode
# PrtScn                flameshot copy to clipboard
# SHIFT-CTRL-ESC        gnome system monitor
#

if [ $(id -u) -eq 0 ]; then
    echo "Please run script without root privileges"
    exit 1
fi

DIR_SS="/home/"$USER"/Pictures/Screenshots"
mkdir -p $DIR_SS

cfg_xfce_shortcuts() {
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>d" -t string -s "show_desktop_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Shift><Super>Down" -t string -s "tile_down_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Shift><Super>Up" -t string -s "tile_up_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>1" -t string -s "workspace_1_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>2" -t string -s "workspace_2_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>3" -t string -s "workspace_3_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>4" -t string -s "workspace_4_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>Left" -t string -s "tile_left_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>Right" -t string -s "tile_right_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/<Super>Up" -t string -s "maximize_window_key"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Super>e" -t string -s "thunar"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Super>t" -t string -s "xfce4-terminal"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Super>r" -t string -s "xfce4-appfinder"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Ctrl>Escape" -t string -s "xfce4-settings-manager"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Shift><Ctrl><Alt>exclam" -t string -s "flameshot full -p '$DIR_SS'"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Shift><Ctrl><Alt>dollar" -t string -s "flameshot gui"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/Print" -t string -s "flameshot full -c"
    xfconf-query -n --channel xfce4-keyboard-shortcuts --property "/commands/custom/<Shift><Ctrl>Escape" -t string -s "gnome-system-monitor"
}

cfg_xfce_shortcuts


