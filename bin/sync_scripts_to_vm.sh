#!/bin/bash

basedir=`dirname $0/..`
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname]"
    exit 1
fi

set -x
exec scp -i $KEY -r $basedir $USER@`get_ip $1`:~
