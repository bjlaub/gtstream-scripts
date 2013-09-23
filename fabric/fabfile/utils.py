import os
from fabric.api import task, run, put, cd, execute, runs_once, local, env, sudo
from paths import *

@task
def gen_graphml(nodes):
    print env.roledefs['hbase-regions']



@task
def dpg_master():
    return run('echo abcdefgh')

@task
def dpg_master_local():
    return local('echo ffffffff', capture=True)

@task
def dpg_slave(master_contact):
    run('echo starting dpg slave; using master_contact: %s' % master_contact)

@task
@runs_once
def vscope_query(nodes):
    master = execute(dpg_master)
    # build up node list here...
    host_list = nodes.split(',')
    execute(dpg_slave, master, hosts=host_list)

@task
@runs_once
def vscope_query_local(nodes):
    master = execute(dpg_master_local)
    print master

@task
def testtask():
    return run('echo foo123')

@task
@runs_once
def testtask2():
    result = execute(testtask)
    print result


####
# these are actually useful - don't delete!
####

@task(alias='ls')
def list_path(path):
    run('ls %s' % path)


@task(alias='upload')
def upload_file(local, remote):
    put(local, remote)


@task
def deploy_cercs(local, remote='/home/ubuntu'):
    fname = os.path.basename(local)
    put(local, remote)
    with cd(remote):
        run('tar -xzf %s' % fname)


@task
def jps():
    run('%s/bin/jps' % JAVA_HOME)


@task
def push_hosts(hosts_file):
    put(hosts_file, '/tmp/.new_hosts')
    sudo('cp /tmp/.new_hosts /etc/hosts')

