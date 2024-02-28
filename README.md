# Azure CLI Docker Image

Docker image with Azure CLI, python and other tools that can be also used with Azure Devops agents.

## Build

Build with docker and tag latest

```bash
docker buildx build --platform linux/amd64,linux/arm64 --build-arg UBUNTU_VERSION=22.04 --build-arg NODE_MAJOR=20 -t catalinm/azure-cli --push .
```

Build with docker and specific tag

```bash
# or create with specific tag
UBUNTU_VERSION=22.04
NODE_MAJOR=20
docker buildx build --platform linux/amd64,linux/arm64 --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg ${NODE_MAJOR} -t catalinm/azure-cli:ubuntu${UBUNTU_VERSION}-node${NODE_MAJOR} --push .
```

## Usage

### Local

```bash
# run latest image
docker pull catalinm/azure-cli
docker run --rm -it --user vsts_azpcontainer --name azure-cli catalinm/azure-cli bash

# run specific image
docker run --rm -it --user vsts_azpcontainer --name azure-cli catalinm/azure-cli:ubuntu22.04-node20 bash
```

#### Run image and attach local scripts

```bash
# go to your project directory and run
docker run --rm -it --user vsts_azpcontainer --name azure-cli -v $PWD:/home/vsts_azpcontainer/workspace catalinm/azure-cli bash
```