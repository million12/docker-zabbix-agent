## Zabbix Agent Docker Image

[![Circle CI](https://circleci.com/gh/million12/docker-zabbix-agent/tree/master.svg?style=svg&circle-token=c12c61948ad16f75903de19a2001d982cd17809d)](https://circleci.com/gh/million12/docker-zabbix-agent/tree/master)
[![GitHub Open Issues](https://img.shields.io/github/issues/million12/docker-zabbix-agent.svg)](https://github.com/million12/docker-zabbix-agent/issues)
[![GitHub Stars](https://img.shields.io/github/stars/million12/docker-zabbix-agent.svg)](https://github.com/million12/docker-zabbix-agent)
[![GitHub Forks](https://img.shields.io/github/forks/million12/docker-zabbix-agent.svg)](https://github.com/million12/docker-zabbix-agent)  
[![Stars on Docker Hub](https://img.shields.io/docker/stars/million12/zabbix-agent.svg)](https://hub.docker.com/r/million12/zabbix-agent)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/million12/zabbix-agent.svg)](https://hub.docker.com/r/million12/zabbix-agent)  
[![Docker Layers](https://badge.imagelayers.io/million12/zabbix-agent:latest.svg)](https://hub.docker.com/r/million12/zabbix-agent)


 [![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/million12/docker-zabbix-agent/tree/master)

This is a [million12/zabbix-agent](https://registry.hub.docker.com/u/million12/zabbix-agent/) docker image with Zabbix Agent. It's based on CentOS-7 official image.  

The Zabbix agent has been patched to read system informations from these directories:  

`/data/proc` mapped from `/proc` on the real host  
`/data/dev` mapped from `/dev` on the real host  
`/data/sys` mapped from `/sys` on the real host  

**Zabbix agent is running in foreground.**

## Build the image

    docker build -t million12/zabbix-agent .

## ENV variables

`ZABBIX_SERVER` - Zabbix Server address  
`HOSTNAME` - hostname  
`HOST_METADATA` - the metadata value shared by all servers on the same cluster. This value will match the autoregistration action  
`CONFIG_FILE` - config file path. (Used if custom file and path needed)

## Usage
### Basic
	docker run \
	-d \
	-p 10050:10050 \
	million12/zabbix-agent

### Mount custom config, set server ip
	docker run \
	-d \
	-p 10050:10050 \
	-v /my-zabbix-agent-config.conf:/etc/zabbix_agentd.conf \
	-e ZABBIX_SERVER=zabbix_server.ip \
    -e HOSTNAME=my.zabbix \
    -e CONFIG_FILE=/etc/zabbix_agentd.conf \
	million12/zabbix-agent

#### Read data from Host OS
	docker run \
	-d \
	-p 10050:10050 \
	-v /proc:/data/proc \
	-v /sys:/data/sys \
	-v /dev:/data/dev \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /my-zabbix-agent-config.conf:/etc/zabbix_agentd.conf \
	--env="ZABBIX_SERVER=zabbix_server.ip" \
	million12/zabbix-agent

## Author  
Author: Przemyslaw Ozgo (<linux@ozgo.info>)  
This work is also inspired by [bhuisgen's](https://github.com/bhuisgen) work on his [docker images](https://github.com/bhuisgen/docker-zabbix-coreos). Many thanks!

---

**Sponsored by [Prototype Brewery](http://prototypebrewery.io/)** - the new prototyping tool for building highly-interactive prototypes of your website or web app. Built on top of [Neos CMS](https://www.neos.io/) and [Zurb Foundation](http://foundation.zurb.com/) framework.
