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
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
start_agent() {
  zabbix_agentd -f -c ${CONFIG_FILE}
}

if [ -z "$METADATA" ]; then
    echo "Host metadata is missing"
    exit 1
fi

if [ -z "$HOST" ]; then
    MACHINEID=$(cat /etc/machine-id)
    HOST="$METADATA-$MACHINEID"
fi

if [[ $ZABBIX_SERVER != "127.0.0.1" ]]; then
  log "Changing Zabbix Server IP to ${bold}${white}${ZABBIX_SERVER}${reset}."
  sed -i 's/^Server=127.0.0.1/Server='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
  sed -i 's/^ServerActive=127.0.0.1/ServerActive='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
  sed -i "s/^Hostname\=.*/Hostname\=$HOST/" ${CONFIG_FILE}
  sed -i "s/^HostMetadata\=.*/HostMetadata\=$METADATA/" ${CONFIG_FILE}
fi

log "Startting agent..."
log `start_agent`
