## Zabbix Agent Docker Image

**Zabbix agent is running in foreground, and in Docker Container.** 

## ENV variables

#### ZABBIX_SERVER
Default: `ZABBIX_SERVER=127.0.0.1`  
Change it to match your server

#### METADATA
Default: `METADATA=zabbix_docker`  
Used for auth-registration

#### HOST
Default: `${METADATA}-${MACHINEID}`  
Auto-generated based on ${METADATA} if not set

## Usage
```
docker run -d --privileged \
  --net=host \
	-v /proc:/docker/proc:ro \
	-v /sys:/docker/sys \
	-v /dev:/docker/dev \
	-v /var/run/docker.sock:/var/run/docker.sock  \
	--env ZABBIX_SERVER=<zabbix_server_ip> \
	--env METADATA=<zabbix_slave_ip> \  
	--env HOST=<zabbix_slave_ip> \
	shuailong/docker-zabbix-agent:2.4.7
```