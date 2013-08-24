#!/bin/bash

. `dirname $0`/../conf/cloud-properties.sh
nova list --name $VM_HOSTNAME_PREFIX
