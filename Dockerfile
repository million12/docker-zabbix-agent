FROM ubuntu:14.04
MAINTAINER shuailong shuailong@tenxcloud.com

COPY foreground.patch /foreground.patch

ENV ZABBIX_VERSION=2.4.7

RUN \
  apt-get update && \
  apt-get install  -y pkg-config subversion automake gcc make && \
  svn co svn://svn.zabbix.com/tags/${ZABBIX_VERSION} /usr/local/src/zabbix && \
  cd /usr/local/src/zabbix && \
  svn patch /foreground.patch && \
  ./bootstrap.sh && \
  ./configure --enable-agent && \
  make install && \
  apt-get remove -y make gcc subversion automake && \
  groupadd zabbix && \
  useradd -g zabbix zabbix && \
  rm -rf  /usr/local/src/zabbix && \
  apt-get autoremove -y

COPY start.sh /start.sh

ENV ZABBIX_SERVER=127.0.0.1

CMD /start.sh

EXPOSE 10050