#!/bin/bash

start=`date +%s`
total=1000
batch=100
url="http://www.domain1.com"
logfile="./wget-benchmark-$total-$batch-`date +%T`.log"
interface="eth1"

incoming_bytes1=`ifconfig $interface | awk '/RX bytes/' | awk -F "RX bytes:" '{print $2}' | awk '{print $1}'`
outgoing_bytes1=`ifconfig $interface | awk '/TX bytes/' | awk -F "TX bytes:" '{print $2}' | awk '{print $1}'`

seq $total | xargs -P $batch -I NONE /usr/bin/wget -a $logfile -rp -nv $url

number_of_wgets=`ps aux | grep /usr/bin/wget | grep -v grep -c`
sleep 2
while [ $number_of_wgets -ne 0 ]; do 
  echo "Number of wgets: $number_of_wgets"
  sleep 2 
  number_of_wgets=`ps aux | grep /usr/bin/wget | grep -v grep -c`
done

echo "getting stats from log: $logfile"
times=`grep Downloaded $logfile | awk '{print $6}' | awk -F s '{sum+=$1} END { if (NR>0) print sum / NR }'`
errors=`grep ERROR $logfile | awk -F ERROR '{print $2}' | sort | uniq -c`
incoming_bytes2=`ifconfig $interface | awk '/RX bytes/' | awk -F "RX bytes:" '{print $2}' | awk '{print $1}'`
outgoing_bytes2=`ifconfig $interface | awk '/TX bytes/' | awk -F "TX bytes:" '{print $2}' | awk '{print $1}'`
incoming_bytes=$((incoming_bytes2 - $incoming_bytes1))
outgoing_bytes=$(($outgoing_bytes2 - $outgoing_bytes1))

echo "----------------------------------------"
echo "times:  $times"
echo "errors: $errors"
echo "RX: $((incoming_bytes / 1024)) KB, TX: $((outgoing_bytes / 1024)) KB"
end=`date +%s`
runtime=$((end-start))
echo "total runtime: $runtime"
