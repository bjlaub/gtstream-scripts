#!/bin/bash

basedir=`dirname $0`/..

if [ $# -lt 1 ]; then
    echo "usage: $0 [rate]"
    echo "[rate] is number of messages/sec generated"
    exit 1
fi

rate=$1

workdir=$basedir/workload_tmp
mkdir -p $workdir
logfile=$workdir/workload_generator.out
pidfile=$workdir/workload_generator.pid

if [ -f $pidfile ]; then
    if kill -0 `cat $pidfile` >/dev/null 2>&1; then
        echo "workload generator already running with pid `cat $pidfile`. Stop it first."
        exit 1
    fi
fi

echo "starting workload generator. Generating $rate messages/sec"
nohup $basedir/bin/workload_generator.py -r $rate -o /mnt/gtstream/logs/logfile.log > $logfile 2>&1 < /dev/null &
echo $! > $pidfile
sleep 1

