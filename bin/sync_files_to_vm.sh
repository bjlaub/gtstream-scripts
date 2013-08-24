#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 2 ]; then
    echo "usage: $0 [files_dir] [vm_hostname]"
    exit 1
fi

filesdir=$1
vm=$2

set -x
exec scp -i $KEY -r $filesdir $USER@`get_ip $vm`:~
