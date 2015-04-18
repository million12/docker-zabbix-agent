## Zabbix Agent Docker Image
This is a [million12/zabbix-agent](https://registry.hub.docker.com/u/million12/zabbix-agent/) docker image with Zabbix Agent. It's based on CentOS-7/Supervisor 

## ENV variables

#### ZABBIX_SERVER
Default: `ZABBIX_SERVER=127.0.0.1`  
Change it to match your server

## Usage
### Basic 
`docker run \`  
`-d \`  
`-p 10050:10050 \`  
`million12/zabbix-agent`

### Mount custom config, set server ip
`docker run \`  
`-d \`  
`-p 10050:10050 \`  
`-v /my-zabbix-agent-config.conf:/etc/zabbix_agentd.conf \`  
`--env="ZABBIX_SERVER=my.ip" \`  
`million12/zabbix-agent `  

#### CoreOS 
`docker run \`  
`-d \`  
`-p 10050:10050 \`  
`-v /proc:/coreos/proc \`  
`-v /sys:/coreos/sys \`  
`-v /dev:/coreos/dev \`  
`-v /var/run/docker.sock:/coreos/var/run/docker.sock \`  
`-v /my-zabbix-agent-config.conf:/etc/zabbix_agentd.conf \`  
`--env="ZABBIX_SERVER=my.ip" \`  
`million12/zabbix-agent `
    
## Author

Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
