#!/bin/bash

export PS1="(gtstream)$PS1"

USER=ubuntu
GROUP=ubuntu
# gets appended to statically assigned hostnames
# see, for example, HADOOP_MASTER and HADOOP_MASTER_HOSTNAME
# a line in /etc/hosts will appear as:
#   $HADOOP_MASTER  $HADOOP_MASTER_HOSTNAME  ${HADOOP_MASTER_HOSTNAME}${CLOUD_FQDN_SUFFIX}
CLOUD_FQDN_SUFFIX=.novalocal


JDK_VERSION=jdk1.7.0_25
JDK_TARBALL=jdk-7u25-linux-x64.gz
JAVA_HOME=/opt/jdk/$JDK_VERSION


HADOOP_VERSION=hadoop-1.2.1
HADOOP_TARBALL=${HADOOP_VERSION}.tar.gz
HADOOP_URL=http://www.gtlib.gatech.edu/pub/apache/hadoop/common/$HADOOP_VERSION/$HADOOP_TARBALL
HADOOP_HOME=/opt/hadoop/$HADOOP_VERSION
HADOOP_BASE=/mnt/hadoop
# IP address/hostname for the master hadoop server
#HADOOP_MASTER=
#HADOOP_MASTER_HOSTNAME=


ZOOKEEPER_VERSION=zookeeper-3.4.5
ZOOKEEPER_TARBALL=${ZOOKEEPER_VERSION}.tar.gz
ZOOKEEPER_URL=http://www.gtlib.gatech.edu/pub/apache/zookeeper/$ZOOKEEPER_VERSION/$ZOOKEEPER_TARBALL
ZOOKEEPER_HOME=/opt/zookeeper/$ZOOKEEPER_VERSION
ZOOKEEPER_BASE=/mnt/zookeeper
# zookeeper quorum nodes
# ZOOKEEPER_QUORUM_1 is required
# for additional nodes (currently up to 3), set ZOOKEEPER_QUORUM_2 and ZOOKEEPER_QUORUM_3
#ZOOKEEPER_QUORUM_1=
#ZOOKEEPER_QUORUM_1_HOSTNAME=
#ZOOKEEPER_QUORUM_2=
#ZOOKEEPER_QUORUM_2_HOSTNAME=
#ZOOKEEPER_QUORUM_3=
#ZOOKEEPER_QUORUM_3_HOSTNAME=


HBASE_VERSION=hbase-0.94.10
HBASE_TARBALL=${HBASE_VERSION}.tar.gz
HBASE_URL=http://www.gtlib.gatech.edu/pub/apache/hbase/$HBASE_VERSION/$HBASE_TARBALL
HBASE_HOME=/opt/hbase/$HBASE_VERSION
HBASE_HDFS_BASE=/hbase
# IP address/hostname for the master hbase server
#HBASE_MASTER=
#HBASE_MASTER_HOSTNAME=


FLUME_VERSION_SHORT=1.4.0
FLUME_VERSION=apache-flume-${FLUME_VERSION_SHORT}-bin
FLUME_TARBALL=${FLUME_VERSION}.tar.gz
FLUME_URL=http://www.gtlib.gatech.edu/pub/apache/flume/$FLUME_VERSION_SHORT/$FLUME_TARBALL
FLUME_HOME=/opt/flume/$FLUME_VERSION
FLUME_BASE=/mnt/flume
FLUME_HBASE_TABLE=test
FLUME_HBASE_COLUMNFAMILY=log


# this is the path to a "workload" file for the gtstream benchmark
# should be a single logfile that is appended to on each machine
# that's part of the test
GTSTREAM_LOGFILE=/mnt/gtstream/logs/logfile.log


# set this to "true" to reset passwords on an instance during install
# do NOT do this on a public cloud! (e.g. AWS)
GTSTREAM_ENABLE_PASSWORDS=true
# set the password for the root user
GTSTREAM_ROOT_PASSWORD="P@ssw0rd1!"
# set the password for the ubuntu user
GTSTREAM_UBUNTU_PASSWORD="L0gM3In"



## added by jedi000 // ./bootup_required_nodes.sh @ Fri Aug 23 10:59:33 EDT 2013
HADOOP_MASTER=10.0.16.100
HADOOP_MASTER_HOSTNAME=gtstream-ng-hadoop-master
HBASE_MASTER=10.0.16.102
HBASE_MASTER_HOSTNAME=gtstream-ng-hbase-master
ZOOKEEPER_QUORUM_1=10.0.16.103
ZOOKEEPER_QUORUM_1_HOSTNAME=gtstream-ng-zk1
