#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [command...]"
    exit 1
fi

allhosts=""
for host in `$basedir/bin/list_servers_short.sh | xargs`; do
    allhosts="$allhosts `get_ip $host`"
done

for hostip in $allhosts; do
    ssh -t -i $KEY $USER@$hostip $@
done

