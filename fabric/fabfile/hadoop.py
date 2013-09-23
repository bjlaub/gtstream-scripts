from fabric.api import task, roles, run
from paths import *

HADOOP_BIN = '%s/bin' % HADOOP_HOME

@task
@roles('hadoop-master')
def start():
    run('%s/start-all.sh' % HADOOP_BIN)

@task
@roles('hadoop-master')
def stop():
    run('%s/stop-all.sh' % HADOOP_BIN)

@task
@roles('hadoop-master')
def dfsadmin(*args):
    cmd = '%s/hadoop dfsadmin %s' % (HADOOP_BIN, ' '.join(args))
    run(cmd)

