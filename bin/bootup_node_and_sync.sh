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
bootup_wait $flavor $host

# give sshd some time to come up
echo "waiting 30 seconds for sshd startup..."
sleep 30

ip=`get_ip $host`
reset_ssh $ip
$basedir/bin/sync_node.sh $filesdir $host

