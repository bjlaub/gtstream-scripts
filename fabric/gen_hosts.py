import os
import novaclient.client

server_prefix = 'gtstream'

user = os.environ.get('OS_USERNAME')
password = os.environ.get('OS_PASSWORD')
auth_url = os.environ.get('OS_AUTH_URL')
tenant_id = os.environ.get('OS_TENANT_ID')
tenant_name = os.environ.get('OS_TENANT_NAME')


client = novaclient.client.Client(2, user, password, tenant_name, auth_url, service_type='compute')
all_hosts = client.servers.list(search_opts={'name': server_prefix})

preamble = """
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

"""

hosts = [preamble]

for h in all_hosts:
    #{u'novanetwork': [{u'version': 4, u'addr': u'10.0.16.164'}]}
    addrs = h.addresses['novanetwork']
    line = '%s %s %s.novalocal' % (addrs[0]['addr'], h.name, h.name)
    hosts.append(line)

print '\n'.join(hosts)

