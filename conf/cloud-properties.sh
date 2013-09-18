#!/bin/bash

# set properties used when managing cloud instances, such as ssh keys, security groups, VM hostnames, etc.

# set the ssh key name to use
#KEY_NAME=
# path to private key stored locally
#KEY=

# login user for instances
USER=ubuntu

# instance image to use
IMAGE=ubuntu-12.10-server

# security group to use
#SECURITY_GROUPS=

# used by list_servers.sh and list_servers_short.sh
VM_HOSTNAME_PREFIX=gtstream

# set the hostnames for some required servers
# these must be set here in order to use bin/bootup_required_nodes.sh
# that script will also append them to conf/gtstream-env.sh
# you can set both, but note that names set *here* will take precedence if
# you use bin/bootup_required_nodes.sh (which is recommended)

# hostname for hadoop master
HADOOP_MASTER_HOSTNAME=gtstream-hadoop-master
# OpenStack VM flavor for hadoop master
HADOOP_MASTER_FLAVOR=9  # ne.medium

# hostname for hbase master
HBASE_MASTER_HOSTNAME=gtstream-hbase-master
# OpenStack VM flavor for hbase master
HBASE_MASTER_FLAVOR=9  # ne.medium

# OpenStack VM flavor for all zookeeper quorum nodes
ZOOKEEPER_QUORUM_FLAVOR=9  # ne.medium
# hostnames for ZK quorum servers
# ZOOKEEPER_QUORUM_1_HOSTNAME is required, others are optional
ZOOKEEPER_QUORUM_1_HOSTNAME=gtstream-zk1
#ZOOKEEPER_QUORUM_2_HOSTNAME=
#ZOOKEEPER_QUORUM_3_HOSTNAME=

