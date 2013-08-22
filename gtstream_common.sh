#!/bin/bash

export PS1="(gtstream)$PS1"

USER=ubuntu
GROUP=ubuntu


JDK_VERSION=jdk1.7.0_25
JDK_TARBALL=jdk-7u25-linux-x64.gz
JAVA_HOME=/opt/jdk/$JDK_VERSION


HADOOP_VERSION=hadoop-1.2.1
HADOOP_TARBALL=${HADOOP_VERSION}.tar.gz
HADOOP_URL=http://www.gtlib.gatech.edu/pub/apache/hadoop/common/$HADOOP_VERSION/$HADOOP_TARBALL
HADOOP_HOME=/opt/hadoop/$HADOOP_VERSION
HADOOP_BASE=/mnt/hadoop
# IP address for the master hadoop server
HADOOP_MASTER=10.0.16.103
HADOOP_MASTER_HOSTNAME=gtstream-ng-hadoop-master

ZOOKEEPER_VERSION=zookeeper-3.4.5
ZOOKEEPER_TARBALL=${ZOOKEEPER_VERSION}.tar.gz
ZOOKEEPER_URL=http://www.gtlib.gatech.edu/pub/apache/zookeeper/$ZOOKEEPER_VERSION/$ZOOKEEPER_TARBALL
ZOOKEEPER_HOME=/opt/zookeeper/$ZOOKEEPER_VERSION
ZOOKEEPER_BASE=/mnt/zookeeper
# zookeeper quorum nodes
# ZOOKEEPER_QUORUM_1 is required
# for additional nodes (currently up to 3), set ZOOKEEPER_QUORUM_2 and ZOOKEEPER_QUORUM_3
ZOOKEEPER_QUORUM_1=10.0.16.152

HBASE_VERSION=hbase-0.94.10
HBASE_TARBALL=${HBASE_VERSION}.tar.gz
HBASE_URL=http://www.gtlib.gatech.edu/pub/apache/hbase/$HBASE_VERSION/$HBASE_TARBALL
HBASE_HOME=/opt/hbase/$HBASE_VERSION
HBASE_HDFS_BASE=/hbase
# IP address for the master hbase server
HBASE_MASTER=10.0.16.161
# This gets appended to /etc/hosts
# regionservers need to be able to locate the master via the hostname published to zookeeper,
# which turns out not to be an IP address... womp :(
HBASE_MASTER_HOSTNAME=gtstream-ng-hbase-master