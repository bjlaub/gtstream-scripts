#!/bin/bash

basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh

# add ourselves to a running hbase cluster
# you should only run this ONCE per regionserver, because it will add *this* 
# node's IP address to conf/regionservers on the given master

my_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
echo $my_ip | ssh $HBASE_MASTER "cat >> /opt/hbase/$HBASE_VERSION/conf/regionservers"

# start hbase daemon on this node
hbase-daemon.sh start regionserver
