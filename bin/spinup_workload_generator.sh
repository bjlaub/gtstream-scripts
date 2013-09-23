#!/bin/bash

basedir=`dirname $0`/..
. $basedir/bin/common.sh

if [ $# -lt 3 ]; then
    echo "usage: $0 [nova_flavor_id] [hostname] [files_dir]"
    echo
    echo "Available flavors:"
    nova flavor-list
    exit 1
fi

flavor=$1
host=$2
filesdir=$3

echo "booting up node and installing software..."
$basedir/bin/bootup_node_and_sync.sh $flavor $host $filesdir notsdb
echo "done"

ip=`get_ip $host`

# TODO: do we need to do anything w/ ip?

echo
echo "New workload generator node started (hostname=$host, ip=$ip)"

