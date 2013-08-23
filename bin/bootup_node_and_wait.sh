#!/bin/bash

basedir=`dirname $0/..`
. $basedir/bin/common.sh

if [ $# -lt 2 ]; then
    echo "usage: $0 [nova_flavor_id] [hostname]"
    echo
    echo "Available flavors:"
    nova flavor-list
    exit 1
fi

flavor=$1
host=$2
bootup_wait $flavor $host
