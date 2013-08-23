#!/bin/bash

# bootup all required nodes for a cluster
# this includes:
#  - Hadoop master
#  - Hbase master
#  - Zookeeper quorum (1 or 3 nodes)

# this script is intended to run *before* starting any other nodes in the
# cluster. It adds the assigned IP addresses to conf/gtstream-env.sh


basedir=`dirname $0/..`
. $basedir/bin/common.sh
. $basedir/conf/cloud-properties.sh

# need at least one zk quorum node defined
if [ -z $ZOOKEEPER_QUORUM_1_HOSTNAME ]; then
    echo "no zookeeper quorum defined! Set ZOOKEEPER_QUORUM_1_HOSTNAME"
    exit 1
fi

# bootup Hadoop master
bootup_wait $HADOOP_MASTER_FLAVOR $HADOOP_MASTER_HOSTNAME
# figure out the assigned IP address
HADOOP_MASTER=`get_ip $HADOOP_MASTER_HOSTNAME`

# bootup HBase master
bootup_wait $HBASE_MASTER_FLAVOR $HBASE_MASTER_HOSTNAME
HBASE_MASTER=`get_ip $HBASE_MASTER_HOSTNAME`

# bootup Zookeeper quorum
bootup_wait $ZOOKEEPER_QUORUM_FLAVOR $ZOOKEEPER_QUORUM_1_HOSTNAME
ZOOKEEPER_QUORUM_1=`get_ip $ZOOKEEPER_QUORUM_1_HOSTNAME`

if [ ! -z $ZOOKEEPER_QUORUM_2_HOSTNAME ]; then
    bootup_wait $ZOOKEEPER_QUORUM_FLAVOR $ZOOKEEPER_QUORUM_2_HOSTNAME
    ZOOKEEPER_QUORUM_2=`get_ip $ZOOKEEPER_QUORUM_2_HOSTNAME`
fi
if [ ! -z $ZOOKEEPER_QUORUM_3_HOSTNAME ]; then
    bootup_wait $ZOOKEEPER_QUORUM_FLAVOR $ZOOKEEPER_QUORUM_3_HOSTNAME
    ZOOKEEPER_QUORUM_3=`get_ip $ZOOKEEPER_QUORUM_3_HOSTNAME`
fi

# finally, add all IPs and hostnames into gtstream-env.sh
conf=$basedir/conf/gtstream-env.sh
cat >> $conf << EOF
## added by `hostname` // $0 @ `date`
HADOOP_MASTER=$HADOOP_MASTER
HADOOP_MASTER_HOSTNAME=$HADOOP_MASTER_HOSTNAME
HBASE_MASTER=$HBASE_MASTER
HBASE_MASTER_HOSTNAME=$HBASE_MASTER_HOSTNAME
ZOOKEEPER_QUORUM_1=$ZOOKEEPER_QUORUM_1
ZOOKEEPER_QUORUM_1_HOSTNAME=$ZOOKEEPER_QUORUM_1_HOSTNAME
EOF
if [ ! -z $ZOOKEEPER_QUORUM_2_HOSTNAME ]; then
    echo "ZOOKEEPER_QUORUM_2=$ZOOKEEPER_QUORUM_2" >> $conf
    echo "ZOOKEEPER_QUORUM_2_HOSTNAME=$ZOOKEEPER_QUORUM_2_HOSTNAME" >> $conf
fi
if [ ! -z $ZOOKEEPER_QUORUM_3_HOSTNAME ]; then
    echo "ZOOKEEPER_QUORUM_3=$ZOOKEEPER_QUORUM_3" >> $conf
    echo "ZOOKEEPER_QUORUM_3_HOSTNAME=$ZOOKEEPER_QUORUM_3_HOSTNAME" >> $conf
fi


