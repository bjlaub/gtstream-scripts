#!/bin/bash

basedir=`dirname $0`/..

TIMEOUT=5

workdir=$basedir/workload_tmp
pidfile=$workdir/workload_generator.pid

if [ -f $pidfile ]; then
    tokill=`cat $pidfile`
    if kill -0 $tokill >/dev/null 2>&1; then
        echo "stopping workload generator"
        kill $tokill
        sleep $TIMEOUT
        if kill -0 $tokill > /dev/null 2>&1; then
            echo "workload generator did not stop gracefully after $TIMEOUT seconds: killing with kill -9"
            kill -9 $tokill
        fi
    else
        echo "no workload generator to stop"
    fi
else
    echo "no workload generator to stop"
fi

