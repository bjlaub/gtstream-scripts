from fabric.api import task, roles, run
from paths import *

@task
@roles('workloads')
def start_fixed_workload(rate='10'):
    """
    start a workload generator on all workload servers with a fixed rate
    (messages/sec) for each generator
    """
    run('%s/bin/start_workload.sh %s' % (GTSTREAM_SCRIPTS_HOME, rate))


@task
@roles('workloads')
def stop():
    run('%s/bin/stop_workload.sh' % GTSTREAM_SCRIPTS_HOME)

