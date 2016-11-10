FROM ubuntu:xenial

RUN apt-get update \
 && apt-get -y install \
    ca-certificates \
    curl \
 && apt-get autoremove \
 && apt-get autoclean

# Install Docker client binary
WORKDIR /usr/bin
ENV DOCKER_RELEASE_URL="https://github.com/docker/docker/releases/latest" \
    DOCKER_BIN_URL="https://get.docker.com/builds/Linux/x86_64"
RUN export DOCKER_VERSION=$(basename `curl -sSL -o /dev/null -w %{url_effective} ${DOCKER_RELEASE_URL} | tr -d 'v'`) \
 &&  curl ${DOCKER_BIN_URL}/docker-${DOCKER_VERSION}.tgz | tar -xvz --strip 1 \
 &&  chmod 755 /usr/bin/docker*


# Install CF binary
WORKDIR /root
ENV CF_RELEASE_URL="https://github.com/cloudfoundry/cli/releases/latest" \
    CF_BIN_URL="https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases"
RUN export CF_VERSION=$(basename `curl -sSL -o /dev/null -w %{url_effective} ${CF_RELEASE_URL}`) \
 && curl -O ${CF_BIN_URL}/${CF_VERSION}/cf-cli-installer_${CF_VERSION#v}_x86-64.deb \
 && dpkg -i ./cf-cli-installer_${CF_VERSION#v}_x86-64.deb


# Install BlueMix CLI
ENV BLUEMIX_CLI_URL="http://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli"
RUN export BM_CLI_LATEST=$(curl -sSL ${BLUEMIX_CLI_URL}/ | grep 'amd64' | grep 'tar.gz' | grep 'Bluemix_CLI_[0-9]' | tail -n 1 | sed -e 's/^.*href="//' -e 's/">.*//') \
 && curl ${BLUEMIX_CLI_URL}/${BM_CLI_LATEST} | tar -xvz \
 && cd Bluemix_CLI \
 && ./install_bluemix_cli \
 && bluemix config --usage-stats-collect false

# Check for Bluemix repo, if not add it
ENV BLUEMIX_PLUGIN_REPO_NAME="Bluemix" \
    BLUEMIX_PLUGIN_REPO_URL="https://plugins.ng.bluemix.net"
RUN if [ $(bluemix plugin repos | grep ${BLUEMIX_PLUGIN_REPO_NAME} | wc -l) -ne 1 ]; then bluemix plugin repo-add ${BLUEMIX_PLUGIN_REPO_NAME} ${BLUEMIX_PLUGIN_REPO_URL}; fi

# Install BlueMix Plugins
COPY installBlueMixPlugins.sh /root/
RUN ./installBlueMixPlugins.sh
# RUN export plugins=( $(bluemix plugin repo-plugins | awk '{print $1}') ); \
#     for p in "${plugins[@]}"; do \
#     { \
#         [ "${p}" == "Name" ] \
#             && { plugins=("${plugins[@]:1}"); break; } \
#             || plugins=("${plugins[@]:1}"); \
#     }; \
#     done; \
#     for plugin in "${plugins[@]}"; do \
#         bluemix plugin install ${plugin} -r ${BLUEMIX_PLUGIN_REPO_NAME}; \
#     done; \
#     bluemix plugin list;

ENV BM_ENV="" \
    BM_USER="" \
    BM_ORG="" \
    BM_SPACE=""

# Copy login script
COPY login.sh /root/
RUN echo ". ./login.sh" >> ~/.bashrc
CMD /bin/bash
