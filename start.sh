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
if [[ $ZABBIX_SERVER != "127.0.0.1" ]]; then
  log "Changing Zabbix Server IP to user provided."
  sed -i 's/Server=127.0.0.1/Server='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
fi
log "Startting agent..."
start_agent