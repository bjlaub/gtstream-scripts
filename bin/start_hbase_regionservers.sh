#!/bin/bash

basedir=`dirname $0`/..

if [ $# -lt 2 ]; then
    echo "usage: $0 [start_num] [end_num]"
    exit 1
fi

flavor=ne.medium
sleep_time=60
start=$1
end=$2

for i in `seq $start $end`; do
    $basedir/bin/spinup_hbase_regionserver.sh $flavor gtstream-hbase-region${i} ../../files
    echo "sleeping $sleep_time seconds"
    sleep $sleep_time
done

