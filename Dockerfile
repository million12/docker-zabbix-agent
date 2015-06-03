FROM centos:centos7
MAINTAINER Przemyslaw Ozgo linux@ozgo.info

COPY foreground.patch /foreground.patch

ENV ZABBIX_VERSION=2.4.5

RUN \
  yum clean all && yum makecache && \
  yum update --nogpgcheck -y && \
  yum install --nogpgcheck -y svn automake gcc make && \
  svn co svn://svn.zabbix.com/tags/${ZABBIX_VERSION} /usr/local/src/zabbix && \
  cd /usr/local/src/zabbix && \
  svn patch /foreground.patch && \
  ./bootstrap.sh && \
  ./configure --enable-agent && \
  make install && \
  rpm -e --nodeps make gcc && \
  yum remove -y svn automake && \
  useradd -G wheel zabbix && \
  rm -rf  /usr/local/src/zabbix && \
  yum clean all

COPY start.sh /start.sh

ENV ZABBIX_SERVER=127.0.0.1

CMD /start.sh

EXPOSE 10050
