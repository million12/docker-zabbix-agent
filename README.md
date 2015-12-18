## Zabbix Agent Docker Image

**Zabbix agent is running in foreground, and in Docker Container.** 

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
	-v /sys:/docker/sys \
	-v /dev:/docker/dev \
	-v /var/run/docker.sock:/var/run/docker.sock  \
	--env ZABBIX_SERVER=<zabbix_server_ip> \
	--env METADATA=zabbix_docker \
	--env HOST=<zabbix_agent_ip> \
	shuailong/docker-zabbix-agent:2.4.7
```