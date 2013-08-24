#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh

function get_ip() {
    vm=$1
    nova list --name $vm | grep -v BUILD | grep novanetwork | awk '{print $8}' | cut -d'=' -f2
}

function bootup() {
    flavor=$1
    host=$2
    echo "`date` -- booting VM '$host' with flavor $flavor"
    set -x
    nova boot --image $IMAGE --key_name $KEY_NAME --security_groups $SECURITY_GROUPS --flavor $flavor $host
    set +x
}

function bootup_wait() {
    flavor=$1
    host=$2
    echo "`date` -- booting VM '$host' with flavor $flavor"
    set -x
    nova boot --image $IMAGE --key_name $KEY_NAME --security_groups $SECURITY_GROUPS --flavor $flavor --poll $host
    set +x
}

function reset_ssh() {
    ip=$1
    set -x
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
    set +x
}

