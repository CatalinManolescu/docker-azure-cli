ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN adduser --disabled-password --gecos "" --uid 1001 vsts_azpcontainer

RUN apt-get update && apt-get upgrade\
    && apt-get install --no-install-recommends \
       apt-utils build-essential locales software-properties-common\
       bash bash-completion ca-certificates lsb-release gnupg \
       wget curl apt-transport-https lsb-release git \
       libffi-dev libssl-dev libyaml-dev python3-dev python3-setuptools python3-pip python3-venv python3-yaml \
       openssh-client psmisc unzip rsync vim less jq gettext xclip xsel \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/apt/lists.d/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean

ARG NODE_MAJOR=20

RUN apt-get update \
    && mkdir -p /etc/apt/keyrings \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az aks install-cli \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarnpkg.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarnpkg.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install nodejs yarn \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/apt/lists.d/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean

RUN locale-gen en_US.UTF-8

USER vsts_azpcontainer

SHELL ["/bin/bash", "-c"]
WORKDIR /home/vsts_azpcontainer
ENV PATH="$PATH:/home/vsts_azpcontainer/.local/bin"

RUN python3 -m pip install --user --upgrade pip \
    && python3 -m pip --version \
    && python3 -m pip install --user virtualenv \
    && python3 -m venv aztools \
    && find . -name activate \
    && source ./aztools/bin/activate

USER root

LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"

CMD [ "node" ]