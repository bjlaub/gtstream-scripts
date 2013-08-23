#!/bin/bash

. common.sh

if [ $# -lt 1 ]; then
    echo "usage: $0 [vm_hostname]"
    exit 1
fi

exec ssh -i $KEY $USER@`get_ip $1`

