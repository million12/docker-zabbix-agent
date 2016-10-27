#!/bin/sh
set -eu
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
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@"; else echo; fi
}

### Update config file based on environment variables
update_config() {
    log "Updating configuration file..."
    if [ ! -z "$ZABBIX_SERVER" ]; then
      log "Changing Zabbix Server IP to ${bold}${white}${ZABBIX_SERVER}${reset}"
      sed -i 's/^[# ]*Server=.*$/Server='$ZABBIX_SERVER'/g' ${TARGET_CONFIG_FILE}
    fi
    if [ ! -z "$HOSTNAME" ]; then
      log "Changing Zabbix Hostname to ${bold}${white}${HOSTNAME}${reset}."
      sed -i 's/^[# ]*Hostname=.*$/Hostname='$HOSTNAME'/g' ${TARGET_CONFIG_FILE}
    fi
    if [ ! -z "$HOST_METADATA" ]; then
      log "Changing Zabbix Host Metadata to ${bold}${white}${HOST_METADATA}${reset}."
      sed -i 's/^[# ]*HostMetadata=.*$/HostMetadata='$HOST_METADATA'/g' ${TARGET_CONFIG_FILE}
    fi
    log "Config updated"
}
print_config() {
  log "Current Zabbix Agent config:"
  printf '=%.0s' {1..100} && echo
  cat ${CONFIG_FILE}
  echo ""
  printf '=%.0s' {1..100} && echo
}
start() {
    log "Starting Zabbix Agent using configuration file: ${CONFIG_FILE}"
    print_config
    zabbix_agentd -f -c ${CONFIG_FILE}
}

# Use the default config file if not set by an environment variable
if [ -z "$CONFIG_FILE" ]; then
  SRC_CONFIG_FILE="/usr/local/etc/zabbix_agentd.conf"
else
  SRC_CONFIG_FILE="$CONFIG_FILE"
fi

# This is the actual config file used, containing changes implied by environment variables
TARGET_CONFIG_FILE=$(mktemp)
log "Loading config: ${SRC_CONFIG_FILE}"
cp "$SRC_CONFIG_FILE" "$TARGET_CONFIG_FILE"

update_config
start








# start_agent() {
#   zabbix_agentd -f -c ${CONFIG_FILE}
# }
# if [[ $ZABBIX_SERVER != "127.0.0.1" ]]; then
#   log "Changing Zabbix Server IP to ${bold}${white}${ZABBIX_SERVER}${reset}."
#   sed -i 's/Server=127.0.0.1/Server='$ZABBIX_SERVER'/g' ${CONFIG_FILE}
# fi
# log "Startting agent..."
# log `start_agent`
