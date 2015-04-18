FROM million12/centos-supervisor
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

RUN \
  yum install -y epel-release && \
  yum install -y zabbix22-agent && \
  yum clean all

ENV ZABBIX_SERVER=127.0.0.1

COPY container-files /

EXPOSE 10050

#ENTRYPOINT ["/bootstrap.sh"]