#!/bin/bash

basedir=`dirname $0`/..

export GTSTREAM_INSTALL_SKIP_APT=1
export GTSTREAM_INSTALL_SKIP_OPENTSDB=1

$basedir/bin/install.sh
