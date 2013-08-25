#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh

cd $FLUME_BASE
piddir=$FLUME_BASE/pids
logdir=$FLUME_BASE/logs
mkdir -p $piddir
mkdir -p $logdir

logfile=$logdir/flume-agent.out
pidfile=$piddir/flume-agent.pid

if [ -f $pidfile ]; then
    if kill -0 `cat $pidfile` >/dev/null 2>&1; then
        echo "flume agent already running with pid `cat $pidfile`. Stop it first."
        exit 1
    fi
fi

echo "starting flume agent"
nohup $FLUME_HOME/bin/flume-ng agent -c $FLUME_HOME/conf -f $FLUME_HOME/conf/flume-conf.properties -n agent > $logfile 2>&1 < /dev/null &
echo $! > $pidfile
sleep 1

