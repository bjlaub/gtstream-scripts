#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname]"
    exit 1
fi

set -x
syncdir=`readlink -f $basedir`
exec scp -i $KEY -r $syncdir $USER@`get_ip $1`:~
