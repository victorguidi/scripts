#!/bin/sh
# This script is used to monitor the total memory usage, and if the memory usage is at 90% or more, it will send an notification.

#total memory usage
memtotal=$(free -m | grep Mem | awk '{print $2}')

#used memory
memused=$(free -m | grep Mem | awk '{print $3}')

#free memory
memfree=$(free -m | grep Mem | awk '{print $4}')

#percentage of used memory
mempercent=$(echo "scale=2; $memused/$memtotal*100" | bc)

if [ `echo "$mempercent > 90" | bc` -eq 1 ]; then
    notify-send "Memory usage is at $mempercent%. There is only $memfree MB free memory left."
    else
        notify-send "$mempercent% of usage."
fi
