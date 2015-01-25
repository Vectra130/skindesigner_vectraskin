#!/bin/bash
# v1.0 eeebox

#Infos fuer den SkinDesigner

DBUS="/usr/bin/vdr-dbus-send.sh /Plugins/skindesigner plugin.SVDRPCommand string:SCTK"
OUTPUTFLDR=/tmp/skindesigner
mkdir -p $OUTPUTFLDR

#cpu usage
#CPUUSAGE=$(printf "%.0f\n" $(cat /proc/stat | grep '^cpu ' | awk '{ print ($2+$4)*100/($2+$4+$5) }' | sed -e 's/[.]/,/g'))
#CPUUSAGE=$(cat /proc/stat | grep '^cpu ' | awk '{ print ($2+$4)*100/($2+$4+$5) }' | awk -F'.' '{ print $1 }' )
#$DBUS string:"ctCpuUsage = $(( $(echo $CPUUSAGE  | sed -e 's/[,]/./g') + 1 ))"
#[ $CPUUSAGE -gt 100 ] && CPUUSAGE=100
#echo "${CPUUSAGE}.0" > ${OUTPUTFLDR}/cpuusage
#logger -t INFO "CPUUSAGE "$CPUUSAGE

#mem usage
MEMUSAGE=$(free | grep "Mem:" | awk '{ print $3*100/$2 }'  | awk -F'.' '{ print $1 }' )
[ $MEMUSAGE -gt 100 ] && MEMUSAGE=100
$DBUS string:"ctMem = ${MEMUSAGE}"
#echo "${MEMUSAGE}.0" > ${OUTPUTFLDR}/memusage
#logger -t INFO "MEMUSAGE "$MEMUSAGE

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
#CPULOAD=$(cat /proc/loadavg | awk '{ print $1 }')
#CPULOAD=$(echo "$CPULOAD * 100" | bc | awk -F'.' '{ print $1 }')
#[ $CPULOAD -gt 250 ] && CPULOAD=250
#echo "${CPULOAD}.0" > ${OUTPUTFLDR}/cpuusage
