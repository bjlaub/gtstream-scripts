#!/bin/bash

# we have to run this one as root
if [[ `whoami` != "root" ]]; then
    echo "you must run this script as root"
    exit 1
fi


## source config variables
basedir=`dirname $0`/..
. $basedir/conf/gtstream-env.sh


mkdir -p ~/files


## setup a useful vimrc for root and ubuntu
for vimrc in /root/.vimrc /home/ubuntu/.vimrc; do
    cat > $vimrc << EOF
set shiftwidth=4
set softtabstop=4
set et
set autoindent
EOF
done
chown ubuntu:ubuntu /home/ubuntu/.vimrc


## Setup passwords if requested
if [[ $GTSTREAM_ENABLE_PASSWORDS == "true" ]]; then
    echo "### Resetting passwords for root and ubuntu"
    # enable password logon for ssh
    sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    restart ssh

    cat << EOF | chpasswd
root:$GTSTREAM_ROOT_PASSWORD
ubuntu:$GTSTREAM_UBUNTU_PASSWORD
EOF

fi

## Setup static hosts
echo "### Setting up /etc/hosts"
if [ ! -z $HADOOP_MASTER_HOSTNAME ]; then
    echo "$HADOOP_MASTER $HADOOP_MASTER_HOSTNAME ${HADOOP_MASTER_HOSTNAME}${CLOUD_FQDN_SUFFIX}" >> /etc/hosts
fi
if [ ! -z $HBASE_MASTER_HOSTNAME ]; then
    echo "$HBASE_MASTER $HBASE_MASTER_HOSTNAME ${HBASE_MASTER_HOSTNAME}${CLOUD_FQDN_SUFFIX}" >> /etc/hosts
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

echo -en $GTSTREAM_SSH_PRIV_KEY > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
chown $USER:$GROUP ~/.ssh/id_rsa

echo -en $GTSTREAM_SSH_PUB_KEY > ~/.ssh/id_rsa.pub
chown $USER:$GROUP ~/.ssh/id_rsa.pub

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
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


## Install some stuff from apt
if [ $GTSTREAM_INSTALL_SKIP_APT -eq 1 ]; then
    echo "### Skipping update/install apt packages"
else
    echo "### Updating/Installing apt packages"
    apt-get update
    if [ ! -z "$GTSTREAM_APT_PACKAGES" ]; then
        apt-get install -y $GTSTREAM_APT_PACKAGES
    fi
fi


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
        <value>2181</value>
    </property>
    <property>
        <name>hbase.zookeeper.quorum</name>
        <value>$ZK_QUORUM</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.dataDir</name>
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
cat > /opt/flume/$FLUME_VERSION/conf/flume-conf.properties << EOF
# configure this flume agent to watch a logfile and put it into hbase
# this is a pretty simplistic example, and attempts to emulate the old
# "tail -f" behaviour from FlumeOG, which is somewhat unreliable
agent.sources = tailSingleFileSource
agent.channels = memoryChannel
agent.sinks = hbaseSink

# configure source
agent.sources.tailSingleFileSource.type = exec
agent.sources.tailSingleFileSource.channels = memoryChannel
agent.sources.tailSingleFileSource.command = tail -F $GTSTREAM_LOGFILE

# configure channel
agent.channels.memoryChannel.type = memory
agent.channels.memoryChannel.capacity = 10000

# configure sink
agent.sinks.hbaseSink.type = org.apache.flume.sink.hbase.AsyncHBaseSink
agent.sinks.hbaseSink.channel = memoryChannel
agent.sinks.hbaseSink.table = $FLUME_HBASE_TABLE
agent.sinks.hbaseSink.columnFamily = $FLUME_HBASE_COLUMNFAMILY
EOF

cat > /opt/flume/$FLUME_VERSION/conf/flume-env.sh << EOF
JAVA_HOME=${JAVA_HOME}
# add hbase-site config to flume's classpath
FLUME_CLASSPATH=${HBASE_HOME}/conf/hbase-site.xml
EOF

cat >> /etc/bash.bashrc << EOF
export PATH=\$PATH:$FLUME_HOME/bin
EOF


# TODO: might be unnecessary
## Install Apache Ant
echo "### Installing Ant"
if [ ! -f ~/files/$ANT_TARBALL ]; then
    wget $ANT_URL
    mv $ANT_TARBALL ~/files
fi

mkdir -p /opt/ant
tar -C /opt/ant -xzf ~/files/$ANT_TARBALL
chmod -R go+rwX /opt/ant

cat >> /etc/bash.bashrc << EOF
export PATH=\$PATH:$ANT_HOME/bin
EOF


## Install OpenTSDB
if [ $GTSTREAM_INSTALL_SKIP_OPENTSDB -eq 1 ]; then
    echo "### Skipping install of OpenTSDB"
else
    echo "### Installing OpenTSDB"
    if [ ! -f ~/files/$OPENTSDB_TARBALL ]; then
        wget $OPENTSDB_URL
        mv $OPENTSDB_TARBALL ~/files
    fi

    mkdir -p /opt/opentsdb
    tar -C /opt/opentsdb -xzf ~/files/$OPENTSDB_TARBALL
    chmod -R go+rwX /opt/opentsdb

    $basedir/bin/build_opentsdb.sh $OPENTSDB_HOME

    # TODO: can't run this until hbase is started...
    ##env COMPRESSION=NONE HBASE_HOME=$HBASE_HOME $OPENTSDB_HOME/src/create_table.sh

    cat > $OPENTSDB_HOME/start_tsd.sh << EOF
    tsdtmp=\${TMPDIR-'/tmp'}/tsd    # For best performance, make sure
    mkdir -p "\$tsdtmp"             # your temporary directory uses tmpfs
    $OPENTSDB_HOME/build/tsdb tsd --port=4242 --staticroot=$OPENTSDB_HOME/build/staticroot --cachedir="\$tsdtmp"
EOF
fi


echo "### Prepare GTStream directories"
mkdir -p $GTSTREAM_BASE
mkdir -p $GTSTREAM_LOGS
chmod -R go+rwX $GTSTREAM_BASE
chmod -R go+rwX $GTSTREAM_LOGS


echo 
echo "$0 completed on `hostname` @ `date`"

