This is a set of scripts used for deploying a GTStream benchmark on an OpenStack cloud.

Currently these are highly personalized to my settings, but should be easy to extend/reconfigure.

Author: Brian Laub - blaub6@gatech.edu

Known Issues
============
Before using, be aware of some known issues (mostly due to my laziness):
 - the user name and path "/home/ubuntu" is hardcoded all over the place :(
 - several other paths are hardcoded (e.g. looking in "~/files" for required JVM package)
 - OpenStack dependencies: this has never been tested (nor do I have any intention to in 
   the near future) on AWS.

Intro
=====
GTStream (https://github.com/chengweiwang/GTStream) is designed as a large-scale log-streaming
benchmark. This project adds some scripts that attempt to make it easier to deploy a benchmark
test on an OpenStack cloud.

Currently, these scripts use newer versions of software used by GTStream, including:
 - Hadoop 1.2.1
 - HBase 0.94.10
 - Flume 1.4.0

Getting Started
===============
Deploying requires Hadoop, HBase, and Flume. You can set these up in any configuration you
like, but the scripts included here attempt to make it a bit easier to scale up a cloud
deployment of these packages.

To get started, first edit the following two files to adjust settings:
 - `conf/cloud-properties.sh`: set certain VM properties to use, such as ssh keyname, path
   to ssh private key, login user, VM image, security groups, etc.
 - `conf/gtstream-env.sh`: environment variables used by install scripts. Set things like
   software versions, URLs to download packages from, install paths, configuration files, etc.

You can build up a minimal set of "required" servers by running:

    bin/bootup_required_nodes.sh

which will start:
 - a Hadoop Master
 - an HBase Master
 - a Zookeeper quorum (at least one server)

Installing Software on Instances
================================
Once an instance has been booted, you need to copy a JVM to "~/files" on that instance,
and you need a copy of these scripts. Two included scripts can be used to do this.
Here's a short example:
 1. download an Oracle JVM to a directory called "files" somewhere. Note that you may not
    be able to use `wget` from the Oracle website due to licensing stuff:
        mkdir /tmp/files && cd /tmp/files
        wget [some_jvm_url]
 2. clone the scripts:
        git clone [this_repos_url] /tmp/gtstream-scripts && cd /tmp/gtstream-scripts
 3. bootup some nodes (see "Getting Started" above):
        bin/bootup_required_nodes.sh
        - or -
        bin/bootup_node_and_wait.sh [flavor] [hostname]
 4. copy JVM and scripts:
        bin/sync_files_to_all.sh
        bin/sync_scripts_to_all.sh
        
Once you've got it all sync'd up, ssh into your VM and run:
    cd gtstream-scripts
    sudo bin/install.sh

Starting Software
=================
To start Hadoop on the master, run:
    start-all.sh
Note you may want to remove `localhost` from `HADOOP_HOME/conf/slaves` if you don't want the
master to run a tasktracker/datanode.

To start HBase on the master, run:
    start-hbase.sh
Note you probably *don't* want to remove `localhost` from `HBASE_HOME/conf/regionservers`, because
localhost will likely be the regionserver for `-ROOT-`.

Scaling
=======
To add Hadoop slaves (a datanode and a tasktracker), bootup a VM using `bin/bootup_node_and_wait.sh`
and follow the install procedure above. Then login and run:
    bin/add_self_to_hadoop.sh

To add HBase regionservers, do the same and login and run:
    bin/add_self_to_hbase.sh

GTStream Benchmarking
=====================
By default, Flume is configured to tail a single logfile using the `exec` source, and to push
data directly into HBase.

You can (and probably will want to) customize this to a more intricate setup (e.g., with log
aggregation, and using something more stable than `exec` source).

