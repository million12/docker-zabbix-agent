#!/bin/sh
set -eu
# Agent ConfigFile
CONFIG_FILE="/usr/local/etc/zabbix_agentd.conf"
# Set TERM
export TERM=xterm
# Bash Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`
separator=$(echo && printf '=%.0s' {1..100} && echo)
# Logging Finctions
log() {
  if [ "$@" ]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
start_agent() {
  zabbix_agentd -f -c ${CONFIG_FILE}
}

if [ -z "$HOST" ]; then
    log "Environment Variable $HOST not set"
    exit 1
fi

if [ $ZABBIX_SERVER != "127.0.0.1" ]; then
  log "Changing Zabbix Server IP to ${bold}${white}${ZABBIX_SERVER}${reset}."
  sed -i 's/^Server=127.0.0.1/Server='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
  sed -i 's/^ServerActive=127.0.0.1/ServerActive='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
  sed -i 's/^Hostname\=.*/Hostname\='$HOST'/' ${CONFIG_FILE}
  sed -i 's/^HostMetadata\=.*/HostMetadata\='$METADATA'/' ${CONFIG_FILE}
	cat >> "${CONFIG_FILE}" <<EOF
AllowRoot=1
LoadModulePath=/usr/local/lib/zabbix
LoadModule=zabbix_module_docker.so
UserParameter=docker.memusage[*],cat /docker/sys/fs/cgroup/memory/docker/$2/memory.usage_in_bytes
UserParameter=docker.memlimit[*],cat /docker/sys/fs/cgroup/memory/docker/$2/memory.limit_in_bytes
UserParameter=docker.cpusystem[*],cat /docker/proc/stat | grep 'cpu ' | awk '{print $$2+$$3+$$4+$$5+$$6+$$7+$$8}'
UserParameter=docker.cpuusage[*],cat /docker/sys/fs/cgroup/cpuacct/docker/$2/cpuacct.usage

UserParameter=docker.cpurate[*],CONTAINERID=$2;SYS_CPU_TOTAL_1=$(cat /proc/stat | grep 'cpu ' | awk '{print $$2+$$3+$$4+$$5+$$6+$$7+$$8}');CGROUP_USAGE_1=$(cat /docker/sys/fs/cgroup/cpuacct/docker/${CONTAINERID}/cpuacct.usage);sleep 1;SYS_CPU_TOTAL_2=$(cat /docker/proc/stat | grep 'cpu ' | awk '{print $$2+$$3+$$4+$$5+$$6+$$7+$$8}');CGROUP_USAGE_2=$(cat /docker/sys/fs/cgroup/cpuacct/docker/${CONTAINERID}/cpuacct.usage);CGROUP_USAGE=`expr $CGROUP_USAGE_2 - $CGROUP_USAGE_1`;Total=`expr $SYS_CPU_TOTAL_2 - $SYS_CPU_TOTAL_1`;CPU_NUM=`cat /docker/proc/stat | grep cpu[0-9] -c`;TICKS=`getconf CLK_TCK`;CGROUP_RATE=`expr $CGROUP_USAGE*$CPU_NUM/$Total/1000000000*${TICKS}|bc -l`;echo $CGROUP_RATE
EOF
fi

log "Startting agent..."
log `start_agent`
