#!/bin/bash

basedir=`dirname $0/..`
. $basedir/conf/cloud-properties.sh

function get_ip() {
    vm=$1
    nova list --name $vm | grep -v BUILD | grep novanetwork | awk '{print $8}' | cut -d'=' -f2
}

function bootup() {
    flavor=$1
    host=$2
    nova boot --image $IMAGE --key_name $KEY_NAME --security_groups $SECURITY_GROUPS --flavor $flavor $host
}

function bootup_wait() {
    flavor=$1
    host=$2
    nova boot --image $IMAGE --key_name $KEY_NAME --security_groups $SECURITY_GROUPS --flavor $flavor --poll $host
}

