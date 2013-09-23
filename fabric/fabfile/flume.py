from fabric.api import task, roles, run
from paths import *

@task
@roles('workloads')
def start():
    run('%s/bin/start_flume_agent.sh' % GTSTREAM_SCRIPTS_HOME)

@task
@roles('workloads')
def stop():
    run('%s/bin/stop_flume_agent.sh' % GTSTREAM_SCRIPTS_HOME)

