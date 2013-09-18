#!/usr/bin/env python

import sys
import subprocess
import tempfile
import shutil


def generate_ssh_keypair():
    outdir = tempfile.mkdtemp()
    try:
        cmd = "ssh-keygen -t rsa -b 2048 -N '' -f %s/id_rsa" % outdir
        rc = subprocess.call(cmd, shell=True)
        if rc != 0:
            raise RuntimeError("error generating ssh keys: rc=%d" % rc)

        priv_key = ['GTSTREAM_SSH_PRIV_KEY="\\']
        pub_key = ['GTSTREAM_SSH_PUB_KEY="']
        with open("%s/id_rsa" % outdir, 'r') as f:
            for line in f:
                priv_key.append(line.strip() + '\\n\\')
        with open("%s/id_rsa.pub" % outdir, 'r') as f:
            pub_key.append(f.read().strip())

        priv_key.append('"')
        pub_key.append('"')

        return '\n'.join(priv_key), ''.join(pub_key)

    finally:
        shutil.rmtree(outdir)


def generate_environ(template="conf/gtstream-env.sh.in", outfile="conf/gtstream-env.sh", values=None):
    if values is None:
        values = locals()

    with open(template, 'r') as f:
        template_data = f.read()

    with open(outfile, 'w') as f:
        f.write(template_data % values)
    print "wrote %s" % outfile


def main(argv):
    ssh_private_key, ssh_public_key = generate_ssh_keypair()
    
    rootpw = 'P@ssw0rd1!'
    userpw = 'L0gM3In'
    enablepw = True

    ssh_enable_passwords = 'GTSTREAM_ENABLE_PASSWORDS=false'
    ssh_root_password = ssh_user_password = ''
    if enablepw:
        ssh_enable_passwords = 'GTSTREAM_ENABLE_PASSWORDS=true'
        ssh_root_password = 'GTSTREAM_ROOT_PASSWORD=\"%s\"' % rootpw
        ssh_user_password = 'GTSTREAM_UBUNTU_PASSWORD=\"%s\"' % userpw

    generate_environ(values=locals())


if __name__ == '__main__':
    main(sys.argv[1:])

