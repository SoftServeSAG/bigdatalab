#!/bin/bash
 
if (( $# < 1 )); then
    echo "Usage:"
    echo "iostat_log_generator_tcp.sh <Agent Hostname> <Agent TCP Port Number>"
	  exit
fi

hostname=$1
port=$2

while true; do
  iostat -x -t -k 1 1 | nc $hostname $port
  sleep 1
done
