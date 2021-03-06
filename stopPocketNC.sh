#!/bin/bash

pgrep -f "/home/pocketnc/pocketnc/Settings/dummy.sh" | while read -r pid ; do
  echo "Killing subprocess dummy.sh $pid"
  kill $pid
done

halcmd -R

linuxcnc_pids=$(pgrep linuxcnc)
waitCount=0

while [ -n "$linuxcnc_pids" ] && (( $waitCount < 600 )); do 
  linuxcnc_pids=$(pgrep linuxcnc)
  sleep .1;
  let waitCount++
done

pgrep linuxcnc | while read -r pid ; do
  echo "Timeout expired, force killing LinuxCNC process $pid"
  kill -9 $pid
done

pgrep hss_sensors | while read -r pid ; do
  echo "Timeout expired, force killing hss_sensors HAL component $pid"
  kill -9 $pid
done
