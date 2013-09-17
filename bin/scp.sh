#!/bin/bash

basedir=`dirname $`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname] [local_path] [dest_path]"
    exit 1
fi

host=$1
local=$2
dest=$3
exec scp -i $KEY $local $USER@`get_ip $host`:$dest
