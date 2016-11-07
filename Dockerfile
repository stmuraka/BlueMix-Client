FROM ubuntu:trusty

WORKDIR /root

RUN apt-get update \
 && apt-get -y install \
    ca-certificates \
 && apt-get autoremove \
 && apt-get autoclean

# Install Docker client binary
ADD https://get.docker.com/builds/Linux/x86_64/docker-1.10.3  /usr/bin/docker
RUN chmod 755 /usr/bin/docker

# Install CF binary
ADD https://cli.run.pivotal.io/stable?release=debian64&version=6.17.0&source=github-rel ./cf-cli-installer_6.17.0_x86-64.deb
RUN dpkg -i ./cf-cli-installer_6.17.0_x86-64.deb

# Install IC Plugin
RUN apt-get install -y ca-certificates \
 && echo "y" | cf install-plugin http://plugins.ng.bluemix.net/downloads/cf-plugins/ibm-containers/ibm-containers-linux_x64

ENV BM_ENV="" \
    BM_USER="" \
    BM_ORG="" \
    BM_SPACE=""

# Copy login script
COPY login.sh /root/
