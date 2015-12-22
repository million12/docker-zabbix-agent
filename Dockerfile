FROM ubuntu:14.04
MAINTAINER shuailong shuailong@tenxcloud.com

COPY foreground.patch /foreground.patch

ENV ZABBIX_VERSION=2.4.7

RUN \
  apt-get update && \
  apt-get install  -y pkg-config subversion automake gcc make wget bc && \
  svn co svn://svn.zabbix.com/tags/${ZABBIX_VERSION} /usr/local/src/zabbix && \
  cd /usr/local/src/zabbix && \
  svn patch /foreground.patch && \
  ./bootstrap.sh && \
  ./configure --enable-agent && \
  make install
RUN \
  cd /usr/local/src/zabbix && \
  mkdir src/modules/zabbix_module_docker && \
  cd src/modules/zabbix_module_docker && \
  wget https://raw.githubusercontent.com/monitoringartist/Zabbix-Docker-Monitoring/master/src/modules/zabbix_module_docker/zabbix_module_docker.c && \
  wget https://raw.githubusercontent.com/monitoringartist/Zabbix-Docker-Monitoring/master/src/modules/zabbix_module_docker/Makefile && \
  make && \
  mkdir -p /usr/local/lib/zabbix && \
  mv zabbix_module_docker.so /usr/local/lib/zabbix/zabbix_module_docker.so
RUN \
  apt-get remove -y make gcc subversion automake pkg-config && \
  groupadd zabbix && \
  useradd -g zabbix zabbix && \
  rm -rf  /usr/local/src/zabbix && \
  apt-get autoremove -y

COPY start.sh /start.sh

ENV ZABBIX_SERVER=127.0.0.1
ENV METADATA=zabbix_docker
ENV HOST=

EXPOSE 10050

CMD ["sh", "/start.sh"]
