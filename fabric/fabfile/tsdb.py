from fabric.api import task, roles, run
from paths import *

@task
def create_table():
    run('env COMPRESSION=NONE HBASE_HOME=%s %s/src/create_table.sh' % (HBASE_HOME, OPENTSDB_HOME))


# TODO: consider a different role for tsd's instead of hbase-regions?
@task
@roles('hbase-regions')
def start_tsd():
    run('%s/start_tsd.sh --auto-metric' % OPENTSDB_HOME)

@task
@roles('hbase-regions')
def stop_tsd():
    run('%s/stop_tsd.sh' % OPENTSDB_HOME)

