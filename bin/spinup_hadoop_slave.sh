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

# bootup the node and install software
echo "booting up node and installing software..."
$basedir/bin/bootup_node_and_sync.sh $flavor $host $filesdir
echo "done"

ip=`get_ip $host`

# add this node as a hadoop slave and start daemons on it
echo "starting hadoop daemons on $host ($ip)"
$basedir/bin/sshexec.sh $host gtstream-scripts/bin/add_self_to_hadoop.sh

echo
echo "New Hadoop slave node started (hostname=$host, ip=$ip)"

