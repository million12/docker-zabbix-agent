## Zabbix Agent Docker Image

**Zabbix agent is running in foreground, and in Docker Container.  It only fetch and generate metrics on the host machine, and not containers on the host machine.  Next step, containers metrics collect shall be added** 

## Prerequisites
You have to create a zabbix server (2.4.7+) first, refer to [Install Zabbix Server In Container](https://hub.docker.com/r/zabbix/zabbix-server-2.4/ "zabbix-server")

## ENV variables

#### ZABBIX_SERVER
Default: `ZABBIX_SERVER=127.0.0.1`

Required: False

Change it to match your server

#### METADATA
Default: `METADATA=zabbix_docker`

Required: False

Used for auth-registration

#### HOST
Required: True

## Usage
```
docker run -d --privileged \
  --net=host \
	-v /proc:/docker/proc:ro \
	-v /sys:/docker/sys:ro \
	-v /dev:/docker/dev:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro  \
	--env ZABBIX_SERVER=<zabbix_server_ip> \
	--env METADATA=zabbix_docker \
	--env HOST=<zabbix_agent_ip> \
	shuailong/docker-zabbix-agent:2.4.7
```

### Debug Mode
```
docker run -it --privileged \
  --net=host \
	-v /proc:/docker/proc:ro \
	-v /sys:/docker/sys:ro \
	-v /dev:/docker/dev:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro  \
	--env ZABBIX_SERVER=<zabbix_server_ip> \
	--env METADATA=zabbix_docker \
	--env HOST=<zabbix_agent_ip> \
	shuailong/docker-zabbix-agent:2.4.7 /bin/bash -c "/bin/sh /start.sh && tail -n 50 /tmp/zabbix_agentd.log"
```  

## Give thanks to
1. [million12](https://github.com/million12/docker-zabbix-agent, "million12")

2. [bhuisgen](https://github.com/bhuisgen/docker-zabbix-coreos, "bhuisgen")