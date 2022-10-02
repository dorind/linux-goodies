#!/bin/sh

#
# Copyright(c) Dorin-Tfeia Duminică. All rights reserved.
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
SWAPFILENAME="/swapfile"
FSTAB="/etc/fstab"
MAX_MULTIPLIER=3

mkswapfile_new_mib() {
    # size is in MiB
    SIZE=$1
    # allocate space
    # try with fallocate, much faster than dd
    fallocate -l $SIZE"M" $SWAPFILENAME ||
        # fallback to good ol' dd
        dd if=/dev/zero of=$SWAPFILENAME bs=1M count=$SIZE &&
        # set permission
        chmod 600 $SWAPFILENAME &&
        # setup swap
        mkswap $SWAPFILENAME &&
        # enable swap
        swapon $SWAPFILENAME &&
        # make changes persistent
        echo "$SWAPFILENAME none swap sw 0 0" >> $FSTAB
}

mkswapfile_new() {
    # fetch amount of ram in MiB
    AVAIL_RAM=$(free -m | grep Mem | awk '{print $2}')
    # set size to multiplier or available ram
    SIZE=${2:-$AVAIL_RAM}
    # is it a multiplier?
    if echo $SIZE | grep -Eq "^x"; then
        # fetch the number part of "x0123"
        MULTIPLIER=$(echo $SIZE | grep -Eo [0-9]+)
        # calculate requested size
        SIZE=$(($AVAIL_RAM * $MULTIPLIER))
        # sanity check
        if [ $MULTIPLIER -gt $MAX_MULTIPLIER ]; then
            echo "$SNAME maximum multiplier($MAX_MULTIPLIER) exceeded"
            echo "    $SIZE MiB swapfile might be a bit too much"
            exit 1
        fi
    fi
    mkswapfile_new_mib $SIZE
}

mkswapfile_rm() {
    # disable swap
    swapoff $SWAPFILENAME &&
        # remove swapfile entry from fstab
        sed -i.bak "/\\$SWAPFILENAME/d" $FSTAB &&
        # remove swap file
        rm $SWAPFILENAME
}

usage() {
    echo "usage:"
    echo "example new:"
    echo "    sudo $SNAME new"
    echo "  for a swapfile equal to amount of RAM"
    echo " or"
    echo "    sudo $SNAME new x2"
    echo "  for a swapfile equal twice the amount of RAM"
    echo ""
    echo "example remove:"
    echo "    sudo $SNAME remove"
    echo ""
}

case $1 in
    "new") mkswapfile_new $@;;
    "remove") mkswapfile_rm;;
    *) usage;;
esac


