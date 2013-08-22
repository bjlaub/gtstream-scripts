#!/bin/bash

# we have to run this one as root
if [[ `whoami` != "root" ]]; then
    echo "you must run this script as root"
    exit 1
fi


## source config variables
. gtstream_common.sh


mkdir -p ~/files


## Setup static hosts
echo "### Setting up /etc/hosts"
if [ ! -z $HADOOP_MASTER_HOSTNAME ]; then
    echo "$HADOOP_MASTER $HADOOP_MASTER_HOSTNAME ${HADOOP_MASTER_HOSTNAME}.novalocal" >> /etc/hosts
fi
if [ ! -z $HBASE_MASTER_HOSTNAME ]; then
    echo "$HBASE_MASTER $HBASE_MASTER_HOSTNAME ${HBASE_MASTER_HOSTNAME}.novalocal" >> /etc/hosts
fi


## Setup passwordless ssh
echo "### Setting up SSH keys"

mkdir -p ~/.ssh
chmod 700 ~/.ssh

cat > ~/.ssh/config << EOF
Host *
    StrictHostKeyChecking no
EOF
chown $USER:$GROUP ~/.ssh/config

cat > ~/.ssh/id_rsa << EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAoIs1LsEO/OBk4a0jZAd1Cwz41h/2AMdXa0Wwrmdo9KGP8lIm
E1HMG1kt8CABXCNTD1Uxmxg7mifUBTKkdS4VoumRY2MfuIiCVE4xwuTS9rOm2ndu
yQGhoyKIevJastRAYfJ3ijvUZt2S6WdaWisZZYS0URuCzSrBLIclop0FaPMpuxJ4
GQA4vd0lz8yYcza0s/GKGkof9JZfgdtO7S3wzVSkq2F3NSaj/CkOVdLk6G2Wnq2m
7WbBM4kCaQByIESJ4lLyNuSZ23S8BOBWuHGqy8FyQS+0BQLRsPvZQq0xc6ed/ufc
CpgwGo0m63PvGwZ58dB2LbA6mKHBCk8jqVVqKQIDAQABAoIBADsINPwGHR663B1n
bpX/b/gqQu1pPym2Itzc+USH3b3mEmoF7t43u5dqyUt8WUOp8Ya3ys++r1vVvU5T
+sjjsyz+OWmULzvJZjLdtcp2HWR9VqMKO4BJy0eTESA0MUmEZlAdufroWQeh/b05
Na3mHyaHD06rkQMj73gSEbKjjjOycNBmwZB0jWdLgWyCtigdzgGKoSMtfKkJn8hK
FLcn/FF2zwv6eTX1DngZcc0LDSR/XKsZp8w26GGtu1UKbEtOa+Nqm97AevXjnMp8
5aoKIHbXky0iy80gv+S4y+nLdHBxSZyHnDe1rC+yjCVbGfRwImnqVHGx0C3MFcjR
bNyNRAkCgYEAzdYZ3Oo2RngP32gY9C1AZjPiFd9xBSgaowl222cZW/FiWEmPd//4
bmmBDfoOBFQiidGwpy7h3MONPwYL1ayVANjFwYh3akrCw+o6PKDqrxcFENpMwR0R
2E2mpt/gAgU8M+RnNARlhuaim/fsNTUPYnbP/5vWRWMGw8ATRLGipbMCgYEAx6ta
3zkB2P2o+m1aFI16gGTmhqGnU19xYWMa0jpUMwZHaB8sxVlGjaYeeS69DnoG68zF
uiRN0Juvu3QPxXXuIuKvrlGz5cAs2iU2MdB7H04Sbc1my47kG/DJAVJB05VeEi/n
+HMhWJmYMVWR46yI5d6DS7cSmkHG46gx0yIrOrMCgYBOPiR2pVEcWGcwNRHHP6xL
LU2zoswDecsmTmKv4/Dv0kHf7ZZrtxFoZxJ3jaXmX1UBroPICToyAOOgIVw+TOwW
9k+10XoTHXgLoO2iPkj3ZXi3f0PN5I7z+hBvPoqYOgU4dIoGa+Vr8h+9yfAwCYtf
kmpeb45zscDQiCLK6fs5oQKBgCKCdEdGdBJL7SuzQLFyrmyIg+ta/y+CvHbniRgy
qqDTAf51/OfzASW0Q2oQcO6SmqWgk8ATTDu03M+aRKuNMWZoJZMMXfpkl5vweIht
jwofFUJTEOQ3wyctG6CV1fi6xTKBgydGxsmoakyEjJ18EYEhTzID5zwwCC8Kv+nM
6wnPAoGAcn7qg1zHXtzLwxMgdyFW5btgMt25H6wxV+8pkxUWLFkKbZXihj+CLkJK
yRgk9yfXUzGYMxGZ7N9p9muIUbje8KY8WOWpudOQImBMReDNEVkvJ4p8Wp7NxMcQ
DFTCS/m1ifjGWSAHpX+7DhGWp0FqI0bMQQHSOLYO1Onxm1MOkrk=
-----END RSA PRIVATE KEY-----
EOF
chmod 600 ~/.ssh/id_rsa
chown $USER:$GROUP ~/.ssh/id_rsa

cat > ~/.ssh/id_rsa.pub << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgizUuwQ784GThrSNkB3ULDPjWH/YAx1drRbCuZ2j0oY/yUiYTUcwbWS3wIAFcI1MPVTGbGDuaJ9QFMqR1LhWi6ZFjYx+4iIJUTjHC5NL2s6bad27JAaGjIoh68lqy1EBh8neKO9Rm3ZLpZ1paKxllhLRRG4LNKsEshyWinQVo8ym7EngZADi93SXPzJhzNrSz8YoaSh/0ll+B207tLfDNVKSrYXc1JqP8KQ5V0uTobZaerabtZsEziQJpAHIgRIniUvI25JnbdLwE4Fa4carLwXJBL7QFAtGw+9lCrTFzp53+59wKmDAajSbrc+8bBnnx0HYtsDqYocEKTyOpVWop root@gtstream-new-pd3
EOF
chown $USER:$GROUP ~/.ssh/id_rsa.pub

cat >> ~/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgizUuwQ784GThrSNkB3ULDPjWH/YAx1drRbCuZ2j0oY/yUiYTUcwbWS3wIAFcI1MPVTGbGDuaJ9QFMqR1LhWi6ZFjYx+4iIJUTjHC5NL2s6bad27JAaGjIoh68lqy1EBh8neKO9Rm3ZLpZ1paKxllhLRRG4LNKsEshyWinQVo8ym7EngZADi93SXPzJhzNrSz8YoaSh/0ll+B207tLfDNVKSrYXc1JqP8KQ5V0uTobZaerabtZsEziQJpAHIgRIniUvI25JnbdLwE4Fa4carLwXJBL7QFAtGw+9lCrTFzp53+59wKmDAajSbrc+8bBnnx0HYtsDqYocEKTyOpVWop root@gtstream-new-pd3
EOF
chown $USER:$GROUP ~/.ssh/authorized_keys


## Disable ipv6
echo "### Disabling ipv6 stack"
cat >>/etc/sysctl.conf <<EOF
# IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sysctl -p


## Install Java
echo "### Installing JDK"
if [ ! -f ~/files/$JDK_TARBALL ]; then
    # grab JDK from somewhere... where??
    # TODO: for now, just assume it exists in ~
    mv ~/$JDK_TARBALL ~/files
fi

mkdir -p /opt/jdk
tar -C /opt/jdk -xzf ~/files/$JDK_TARBALL
chmod -R go+rwX /opt/jdk

cat >> /etc/bash.bashrc << EOF
export JAVA_HOME=$JAVA_HOME
export PATH=\$PATH:\$JAVA_HOME/bin
EOF


## Install Hadoop
echo "### Installing Hadoop"
if [ ! -f ~/files/$HADOOP_TARBALL ]; then
    wget $HADOOP_URL
    mv $HADOOP_TARBALL ~/files
fi

mkdir -p /opt/hadoop
tar -C /opt/hadoop -xzf ~/files/$HADOOP_TARBALL
chmod -R go+rwX /opt/hadoop

cat >> /etc/bash.bashrc << EOF
# note: do NOT export HADOOP_HOME anymore...
export PATH=\$PATH:$HADOOP_HOME/bin
EOF

# this is the base directory where hadoop *data* files live (e.g. namenode and datanodes)
mkdir -p $HADOOP_BASE
chmod go+rwX $HADOOP_BASE

# configure hadoop

cat >> /opt/hadoop/$HADOOP_VERSION/conf/hadoop-env.sh << EOF
export JAVA_HOME=${JAVA_HOME}
EOF

cat > /opt/hadoop/$HADOOP_VERSION/conf/core-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://$HADOOP_MASTER:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>$HADOOP_BASE/tmp</value>
    </property>
</configuration>
EOF

cat > /opt/hadoop/$HADOOP_VERSION/conf/hdfs-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.name.dir</name>
        <value>$HADOOP_BASE/name</value>
    </property>
    <property>
        <name>dfs.data.dir</name>
        <value>$HADOOP_BASE/data</value>
    </property>
</configuration>
EOF

cat > /opt/hadoop/$HADOOP_VERSION/conf/mapred-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapred.job.tracker</name>
        <value>$HADOOP_MASTER:9001</value>
    </property>
</configuration>
EOF


## Install Zookeeper
## TODO: scrap this, and just have HBase manage a zookeeper quorum, which is simpler
echo "### Installing Zookeeper"
if [ ! -f ~/files/$ZOOKEEPER_TARBALL ]; then
    wget $ZOOKEEPER_URL
    mv $ZOOKEEPER_TARBALL ~/files
fi

mkdir -p /opt/zookeeper
tar -C /opt/zookeeper -xzf ~/files/$ZOOKEEPER_TARBALL
chmod -R go+rwX /opt/zookeeper

cat > /opt/zookeeper/$ZOOKEEPER_VERSION/conf/zoo.cfg << EOF
tickTime=2000
initLimit=10
syncLimit=5
clientPort=2181
dataDir=$ZOOKEEPER_BASE
EOF

mkdir -p $ZOOKEEPER_BASE
chmod go+rwX $ZOOKEEPER_BASE

cat >> /etc/bash.bashrc << EOF
export PATH=\$PATH:$ZOOKEEPER_HOME/bin
EOF


## Install HBase
echo "### Installing HBase"
if [ ! -f ~/files/$HBASE_TARBALL ]; then
    wget $HBASE_URL
    mv $HBASE_TARBALL ~/files
fi

mkdir -p /opt/hbase
tar -C /opt/hbase -xzf ~/files/$HBASE_TARBALL
chmod -R go+rwX /opt/hbase

# configure hbase
cat >> /opt/hbase/$HBASE_VERSION/conf/hbase-env.sh << EOF
export JAVA_HOME=$JAVA_HOME
export HBASE_MANAGES_ZK=true
EOF

# determine zookeeper quorum
# currently only allow for 1-3 nodes
ZK_QUORUM=
if [ ! -z $ZOOKEEPER_QUORUM_1 ]; then
    ZK_QUORUM="$ZOOKEEPER_QUORUM_1"
fi
if [ ! -z $ZOOKEEPER_QUORUM_2 ]; then
    ZK_QUORUM="${ZK_QUORUM},${ZOOKEEPER_QUORUM_2}"
fi
if [ ! -z $ZOOKEEPER_QUORUM_3 ]; then
    ZK_QUORUM="${ZK_QUORUM},${ZOOKEEPER_QUORUM_3}"
fi

cat > /opt/hbase/$HBASE_VERSION/conf/hbase-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>hbase.master</name>
        <value>$HBASE_MASTER_HOSTNAME:60000</value>
    </property>
    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://$HADOOP_MASTER:9000/$HBASE_HDFS_BASE</value>
    </property>
    <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.clientPort</name>
        <value>2222</value>
    </property>
    <property>
        <name>hbase.zookeeper.quorum</name>
        <value>$ZK_QUORUM</value>
    </property>
    <property>
        <name>hbase.zookeper.property.dataDir</name>
        <value>$ZOOKEEPER_BASE</value>
    </property>
</configuration>
EOF

cat >> /etc/bash.bashrc << EOF
export PATH=\$PATH:$HBASE_HOME/bin
EOF


## Install Flume
echo "### Installing Flume"
if [ ! -f ~/files/$FLUME_TARBALL ]; then
    wget $FLUME_URL
    mv $FLUME_TARBALL ~/files
fi

mkdir -p /opt/flume
tar -C /opt/flume -xzf ~/files/$FLUME_TARBALL
chmod -R go+rwX /opt/flume

# configure flume
# TODO

cat >> /etc/bash.bashrc << EOF
export PATH=\$PATH:$FLUME_HOME/bin
EOF

