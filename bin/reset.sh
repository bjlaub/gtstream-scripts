#!/bin/bash

# this is the # of lines to remove from the end of /etc/bash.bashrc
# annoyingly, must match the number of echos *into* /etc/bash.bashrc in the installer script
# probably would be safe to just continuously append to bashrc, but whatever...
LAST_BASHRC_LINES=7

# similar thing for /etc/hosts
LAST_HOSTS_LINES=2

# similar thing for /etc/sysctl.conf
LAST_SYSCTL_LINES=4

if [[ `whoami` != "root" ]]; then
    echo "you must run this script as root"
    exit 1
fi

echo -n "reset gtstream software - are you sure? [y/n]: "
read choice
while [[ $choice != "y" && $choice != "n" ]]; do
    echo -n "reset gtstream software - are you sure? [y/n]: "
    read choice
done

if [[ $choice == "n" ]]; then
    echo "aborted."
    exit 1
fi

exit 123

set -x
# delete all software and prepare to re-run gtstream_installer.sh

# remove ssh keys and config
rm ~/.ssh/config
rm ~/.ssh/id_rsa*

# remove bashrc stuff
head -n -${LAST_BASHRC_LINES} /etc/bash.bashrc >.bashrcnew
mv -f .bashrcnew /etc/bash.bashrc

# remove /etc/hosts stuff
head -n -${LAST_HOSTS_LINES} /etc/hosts >.hostsnew
mv -f .hostsnew /etc/hosts

# remove /etc/sysctl.conf stuff
head -n -${LAST_SYSCTL_LINES} /etc/sysctl.conf >.sysctlnew
mv -f .sysctlnew /etc/sysctl.conf
sysctl -p

# reset password authentication state for ssh
# note that we can't actually reset passwords once they've been set by the installer!
if [[ $GTSTREAM_ENABLE_PASSWORDS == "true" ]]; then
    sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    restart ssh
fi

# remove software
rm -rf /opt/*

# remove stuff in /mnt
rm -rf /mnt/*

# TODO: if paths weren't completely set up right, hadoop/hbase may leave some stuff
# hanging around in /var or /tmp, but oh well...

