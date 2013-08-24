#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [files_dir]"
    exit 1
fi

filesdir=$1

set -x
for host in `$basedir/bin/list_servers_short.sh | xargs`; do
    rsync -e "ssh -i $KEY" -av $filesdir $USER@`get_ip $host`:~/`basename $filesdir`
done
