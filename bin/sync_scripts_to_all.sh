#!/bin/bash

basedir=`dirname $0/..`
. $basedir/bin/common.sh

set -x
for host in `$basedir/bin/list_servers_short.sh | xargs`; do
    scp -i $KEY -r $basedir $USER@`get_ip $host`:~
done

