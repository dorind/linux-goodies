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

pkg_list_deb() {
    LIST=""
    # find all install-.sh files in current directory
    for isf in $(ls -1 install-*.sh)
    do
        # request all required debian packages
        i=$(/bin/sh $isf "--PKG_DEB")
        # append to list
        LIST="$LIST $i"
    done
    # each install file has it's own required packages
    # filter out duplicates and sort them
    FLIST=$(echo $LIST | sed "s/\ /\\n/g" | sort -V | uniq)
    for i in $FLIST
    do
        # echo each package
        echo $i
    done
}

for s in "$@"
do
    case $s in
        "--DEB") pkg_list_deb;;
    esac
done


