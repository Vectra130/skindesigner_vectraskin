#!/bin/bash

#Infos fuer den SkinDesigner

OUTPUTFLDR=/tmp/skindesigner
mkdir -p $OUTPUTFLDR

#mem usage
MEMUSAGE=$(free | grep "Mem:" | awk '{ print $3*100/$2 }'  | awk -F'.' '{ print $1 }' )
[ $MEMUSAGE -gt 100 ] && MEMUSAGE=100
echo "${MEMUSAGE}.0" > ${OUTPUTFLDR}/memusage

#swap usage
#SWAPUSAGE=$(free | grep "Swap:" | awk '{ print ($2-$4)*100/$2 }'  | awk -F'.' '{ print $1 }' )
#$DBUS string:"ctSwapUsage = $(( $(echo $SWAPUSAGE  | sed -e 's/[,]/./g') + 1 ))"
#logger -t INFO "SWAPUSAGE "$SWAPUSAGE

#cpu temp
CPUTEMP=$(sensors -A coretemp-isa-0000 | grep "Core 0" | awk '{print $3}' | tr -d "+"  | awk -F'.' '{ print $1 }')
[ $CPUTEMP -gt 80 ] && CPUTEMP=80
echo "${CPUTEMP}.0" > ${OUTPUTFLDR}/cpu

#gpu temp
GPUTEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader  | awk -F'.' '{ print $1 }')
[ $GPUTEMP -gt 80 ] && GPUTEMP=80
echo "${GPUTEMP}.0" > ${OUTPUTFLDR}/gpu

#cpuload
CPULOAD=$(cat /proc/loadavg | awk '{ print $1 }')
CPULOAD=$(echo "$CPULOAD * 100" | bc | awk -F'.' '{ print $1 }')
[ $CPULOAD -gt 250 ] && CPULOAD=250
echo "${CPULOAD}.0" > ${OUTPUTFLDR}/cpuusage
