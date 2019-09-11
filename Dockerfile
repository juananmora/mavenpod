FROM registry.global.ccc.srvb.can.paas.cloudcenter.corp/ccc-alm/cloud_maven:1.5.1

RUN echo "Europe/Madrid" > /etc/timezone
RUN ln -f -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

ARG GIT_TOKEN
RUN rm -Rf /var/lib/apt/lists/*
RUN rm -Rf /etc/apt/sources.list.d/openjdk.list

RUN apt-get update && apt-get install -y apt-transport-https
COPY files/nodesource.list /etc/apt/sources.list.d/nodesource.list
RUN https_proxy="http://proxyapps.gsnet.corp:80" curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y npm

COPY san-c3-maven-commons /opt/san-c3-maven-commons

RUN mkdir -p /home/jenkins/.m2
COPY files/settings.xml /home/jenkins/.m2/settings.xml

RUN chown -R 1000:1000 /home/jenkins && chown -R 1000:1000 /home/jenkins/.m2

