#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

set -x
syncdir=`readlink -f $basedir`
for host in `$basedir/bin/list_servers_short.sh | xargs`; do
    scp -i $KEY -r $syncdir $USER@`get_ip $host`:~
done

