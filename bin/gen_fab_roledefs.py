import os
import pprint
import novaclient.client

server_prefix = 'gtstream'

user = os.environ.get('OS_USERNAME')
password = os.environ.get('OS_PASSWORD')
auth_url = os.environ.get('OS_AUTH_URL')
tenant_id = os.environ.get('OS_TENANT_ID')
tenant_name = os.environ.get('OS_TENANT_NAME')


client = novaclient.client.Client(2, user, password, tenant_name, auth_url, service_type='compute')

all_hosts = client.servers.list(search_opts={'name': server_prefix})

def find_hosts(hosts, prefix):
    found = []
    for h in hosts:
        if h.name.startswith(prefix):
            found.append(h.name)
    return found

all_servers = find_hosts(all_hosts, server_prefix)

hadoop_all = find_hosts(all_hosts, server_prefix + '-hadoop')
hadoop_master = find_hosts(all_hosts, server_prefix + '-hadoop-master')
hadoop_slaves = find_hosts(all_hosts, server_prefix + '-hadoop-slave')

hbase_all = find_hosts(all_hosts, server_prefix + '-hbase')
hbase_master = find_hosts(all_hosts, server_prefix + '-hbase-master')
hbase_regions = find_hosts(all_hosts, server_prefix + '-hbase-region')

zookeepers = find_hosts(all_hosts, server_prefix + '-zk')

roledefs = {
    'all': all_servers,
    
    'hadoop-all': hadoop_all,
    'hadoop-master': hadoop_master,
    'hadoop-slaves': hadoop_slaves,

    'hbase-all': hbase_all,
    'hbase-master': hbase_master,
    'hbase_regions': hbase_regions,

    'zookeepers': zookeepers,
}

for r in sorted(roledefs):
    v = roledefs[r]
    print "env.roledefs['%s'] = %s" % (r, pprint.pformat(v, indent=4))
