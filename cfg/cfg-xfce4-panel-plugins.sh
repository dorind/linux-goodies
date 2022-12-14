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

CFG_TIMEZONE=$(cat /etc/timezone)

cfg_xfce_plugins() {
    pkill xfce4-panel
    
    xfconf-query -n -a --channel xfce4-panel --property "/panels" -t "int" -s 1
    
    # configure top panel
    xfconf-query -n --channel xfce4-panel --property "/panels/panel-1/length" -t "int" -s 100
    xfconf-query -n --channel xfce4-panel --property "/panels/panel-1/size" -t "int" -s 24
    xfconf-query -n --channel xfce4-panel --property "/panels/panel-1/position" -t "string" -s "p=6;x=0;y=0"
    xfconf-query -n --channel xfce4-panel --property "/panels/panel-1/position-locked" -t "bool" -s "true"
    xfconf-query -n --channel xfce4-panel --property "/panels/panel-1/background-style" -t "int" -s "1"

    # configure top panel plugin refs
    xfconf-query --create --channel xfce4-panel --property "/panels/panel-1/plugin-ids" \
        --type int --type int --type int --type int --type int \
        --type int --type int --type int --type int --type int \
        --type int --type int --type int --type int --type int \
        --type int --type int --type int --type int \
        --set 1    --set 2    --set 3    --set 4    --set 5 \
        --set 6    --set 7    --set 8    --set 9    --set 10 \
        --set 11   --set 12   --set 13   --set 14   --set 15 \
        --set 16   --set 17   --set 18   --set 19

    # set and configure top panel plugins
    
    # plugin: application menu
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-1" -t "string" -s "applicationsmenu"
    # hide application menu title
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-1/show-button-title" -t "bool" -s "false"

    # plugin: tasklist
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-2" -t "string" -s "tasklist"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-2/flat-buttons" -t "bool" -s "true"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-2/grouping" -t "int" -s "1"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-2/show-handle" -t "bool" -s "false"
    
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-3" -t "string" -s "separator"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-3/expand" -t "bool" -s "true"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-3/style" -t "int" -s "0"
    
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-4" -t "string" -s "separator"
    
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-5" -t "string" -s "separator"
    
    # plugin: datetime
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-6" -t "string" -s "datetime"
        DTF="$HOME/.config/xfce4/panel/datetime-6.rc"
        echo "layout=2" > $DTF
        echo "date_font=Sans 14" >> $DTF
        echo "time_font=Sans Bold 14" >> $DTF
        echo "date_format=%a, %b %e" >> $DTF
        echo "time_format=%H:%M" >> $DTF
        echo "" >> $DTF
        
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-7" -t "string" -s "separator"
    
    # plugin: clock
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8" -t "string" -s "clock"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/digital-format" -t "string" -s ""
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/flash-separators" -t "bool" -s "true"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/mode" -t "int" -s 4
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/show-meridiem" -t "bool" -s "false"
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/timezone" -t "string" -s $CFG_TIMEZONE
        xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-8/tooltip-format" -t "string" -s ""
    
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-9" -t "string" -s "separator"
    
    # plugin: weather
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-10" -t "string" -s "weather"
        WF="$HOME/.config/xfce4/panel/weather-10.rc"
        echo "msl=100" >> $WF
        echo "timezone=$CFG_TIMEZONE" >> $WF
        echo "cache_file_max_age=172800" >> $WF
        echo "power_saving=true" >> $WF
        echo "units_temperature=0" >> $WF
        echo "units_pressure=0" >> $WF
        echo "units_windspeed=0" >> $WF
        echo "units_precipitation=0" >> $WF
        echo "units_altitude=0" >> $WF
        echo "model_apparent_temperature=0" >> $WF
        echo "round=true" >> $WF
        echo "single_row=true" >> $WF
        echo "tooltip_style=1" >> $WF
        echo "forecast_layout=0" >> $WF
        echo "forecast_days=5" >> $WF
        echo "scrollbox_animate=false" >> $WF
        echo "theme_dir=/usr/share/xfce4/weather/icons/liquid" >> $WF
        echo "show_scrollbox=true" >> $WF
        echo "scrollbox_lines=1" >> $WF
        echo "scrollbox_font=Sans 16" >> $WF
        echo "scrollbox_color=#000000000000" >> $WF
        echo "scrollbox_use_color=false" >> $WF
        echo "label0=3" >> $WF
        echo "label1=9" >> $WF
        echo "label2=17" >> $WF
        echo "" >> $WF

    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-11" -t "string" -s "systray"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-12" -t "string" -s "pulseaudio"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-13" -t "string" -s "screenshooter"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-14" -t "string" -s "xkb"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-15" -t "string" -s "xfce4-timer-plugin"
        TF="$HOME/.config/xfce4/panel/XfceTimer.rc"
        echo "[G0]" > $TF
        echo "timername=1h" >> $TF
        echo "time=3600" >> $TF
        echo "timercommand=" >> $TF
        echo "timerinfo=1h 0m 0s" >> $TF
        echo "is_countdown=true" >> $TF
        echo "" >> $TF
        echo "[G1]" >> $TF
        echo "timername=30m" >> $TF
        echo "time=1800" >> $TF
        echo "timercommand=" >> $TF
        echo "timerinfo=30m 0s" >> $TF
        echo "is_countdown=true" >> $TF
        echo "" >> $TF
        echo "[G2]" >> $TF
        echo "timername=15m" >> $TF
        echo "time=900" >> $TF
        echo "timercommand=" >> $TF
        echo "timerinfo=15m 0s" >> $TF
        echo "is_countdown=true" >> $TF
        echo "" >> $TF
        echo "[G3]" >> $TF
        echo "timername=5m" >> $TF
        echo "time=300" >> $TF
        echo "timercommand=" >> $TF
        echo "timerinfo=1m 0s" >> $TF
        echo "is_countdown=true" >> $TF
        echo "" >> $TF
        echo "[others]" >> $TF
        echo "nowin_if_alarm=false" >> $TF
        echo "selecting_starts=false" >> $TF
        echo "use_global_command=false" >> $TF
        echo "global_command=" >> $TF
        echo "repeat_alarm=false" >> $TF
        echo "repetitions=1" >> $TF
        echo "repeat_interval=10" >> $TF
        echo "" >> $TF

    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-16" -t "string" -s "separator"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-17" -t "string" -s "actions"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-18" -t "string" -s "separator"
    xfconf-query -n --channel xfce4-panel --property "/plugins/plugin-19" -t "string" -s "notification-plugin"

    xfce4-panel &
}

cfg_xfce_plugins


