#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh

# add ourselves to a running hadoop cluster
# you should only run this ONCE per slave node, because it will add *this* 
# node's IP address to conf/slaves on the given master

my_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
echo $my_ip | ssh $HADOOP_MASTER "cat >> /opt/hadoop/$HADOOP_VERSION/conf/slaves"

# start hadoop daemons on this node
$HADOOP_HOME/bin/hadoop-daemon.sh start datanode
$HADOOP_HOME/bin/hadoop-daemon.sh start tasktracker
