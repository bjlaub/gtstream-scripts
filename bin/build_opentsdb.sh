#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh

export JAVA_HOME=$JAVA_HOME
export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PATH

cd $OPENTSDB_HOME
./build.sh
