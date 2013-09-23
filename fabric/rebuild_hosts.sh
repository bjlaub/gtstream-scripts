#!/bin/bash

set -x
python gen_hosts.py >.hosts_new
sudo cp .hosts_new /etc/hosts
python gen_fab_roledefs.py >fabfile/roledefs.py
