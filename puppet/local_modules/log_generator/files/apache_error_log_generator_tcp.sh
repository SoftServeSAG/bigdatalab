#!/bin/bash
 
if (( $# < 1 )); then
    echo "Usage:"
    echo "apache_error_log_generator_tcp.sh <Agent Hostname> <Agent TCP Port Number> <Rows Limit>"
    echo "or"
    echo "apache_error_log_generator_tcp.sh <Agent Hostname> <Agent TCP Port Number> <Rows Limit> [Sleep From] [Sleep To]"
    exit
fi

hostname=$1
port=$2
rows=$3
fromSec=$4
toSec=$5

while true; do
    ruby apache_error_log_generator.rb $rows | nc $hostname $port
    if (( fromSec>=0 && toSec>fromSec )); then
      sleep_for=$((fromSec+(RANDOM*(toSec-fromSec)/32767)))
      sleep $sleep_for
    fi
done
