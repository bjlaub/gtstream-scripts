#!/bin/bash

. `dirname $0`/../conf/cloud-properties.sh
nova list --name $VM_HOSTNAME_PREFIX | grep $VM_HOSTNAME_PREFIX | awk '{print $4}'
