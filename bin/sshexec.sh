#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname] [command...]"
    exit 1
fi

host=$1
shift
ssh -t -i $KEY $USER@`get_ip $host` $@

