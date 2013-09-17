#!/bin/bash

basedir=`dirname $`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname] [remote_path] [local_path]"
    exit 1
fi

host=$1
remote=$2
local=$3
exec scp -i $KEY $USER@`get_ip $host`:$remote $local
