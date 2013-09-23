#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh

TIMEOUT=5

cd $FLUME_BASE
piddir=$FLUME_BASE/pids
pidfile=$piddir/flume-agent.pid

if [ -f $pidfile ]; then
    tokill=`cat $pidfile`
    if kill -0 $tokill >/dev/null 2>&1; then
        echo "stopping flume agent"
        kill $tokill
        sleep $TIMEOUT
        if kill -0 $tokill > /dev/null 2>&1; then
            echo "flume agent did not stop gracefully after $TIMEOUT seconds: killing with kill -9"
            kill -9 $tokill
        fi
    else
        echo "no flume agent to stop"
    fi
else
    echo "no flume agent to stop"
fi

