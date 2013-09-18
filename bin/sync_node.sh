#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/cloud-properties.sh
. $basedir/bin/common.sh

if [ $# -lt 2 ]; then
    echo "usage: $0 [files_dir] [vm_hostname]"
    exit 1
fi

filesdir=$1
filesdir_remote=`basename $filesdir`
scriptsdir=`readlink -f $basedir`
scriptsdir_remote=`basename $scriptsdir`
vm=$2

set -x
rsync -e "ssh -i $KEY" -av $filesdir/. $USER@`get_ip $vm`:~/$filesdir_remote
rsync -e "ssh -i $KEY" -av $scriptsdir $USER@`get_ip $vm`:~
#$basedir/bin/sshexec.sh $vm sudo $scriptsdir_remote/bin/install.sh
