#!/bin/sh
set -eu 
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
warning() {
  echo "${bold}${yellow}[WARNING `date +'%T'`]${reset} ${yellow}$@${reset}";
}
error() {
  echo "${bold}${red}[ERROR `date +'%T'`]${reset} ${red}$@${reset}";
}
print_config() {
  log "Loading Zabbix Agent config /etc/zabbix_agentd.conf"
  printf '=%.0s' {1..100} && echo
  cat /etc/zabbix_agentd.conf
  printf '=%.0s' {1..100} && echo
}

if [[ $ZABBIX_SERVER != "127.0.0.1" ]]; then
  log "Changin Zabbix Server IP to user provided."
  sed -i 's/Server=127.0.0.1/Server='$ZABBIX_SERVER'/g' /etc/zabbix_agentd.conf
fi
# Launch Zabbix Agent
print_config
