from fabric.api import task, roles, run
from paths import *

HBASE_BIN = '%s/bin' % HBASE_HOME

@task
@roles('hbase-master')
def start():
    run('%s/start-hbase.sh' % HBASE_BIN)

@task
@roles('hbase-master')
def stop():
    run('%s/stop-hbase.sh' % HBASE_BIN)


