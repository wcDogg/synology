# Docker

## Install

1. Install from DSM > Package Center
2. A `/volume1/docker` directory is auto-created


## Check Docker Versions

Synology uses older Docker:

* Use `docker-compose` - not `docker compose`
* Compose files must be `version: '2'`
* You cannot update - the move from 2 to 3 is a paradigm shift

```bash
docker --version
# Docker version 20.10.3, build 55f0773

docker-compose version
# docker-compose version 1.28.5, build 24fb474e
# docker-py version: 4.4.4
# CPython version: 3.7.10
# OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019

sudo docker info
docker ps
```

## Create a Docker Network

* All Docker containers are added to this network.
* Each container is given a static IP on this network via its `docker-compose.yml`.
* Simplifies containers that need to communicate with each other. For example, Pi-hole and Unbound don't need a macvlan or bridge.
* When configuring NGINX proxy hosts, we can reference a container's hostname vs an IP address.

**IMPORTANT** All Docker compose files assume this exact network. See [Network Reference: Docker nas_network](network.md) for a running list of containers in this project.

```bash
# Create Network
docker network create --subnet 172.29.7.0/24 --gateway 172.29.7.1 nas_network

# List
docker network ls

# Details
docker network inspect nas_network
```

## Add Container to Network

```bash
# Add this to start or end of each docker-compose.yml
networks:
  default:
    name: nas_network

# Assign each container a unique IP
services:
  my-container:
    networks:
      default:
        ipv4_address: 172.29.7.8
```

## Stopping and Starting Containers

Here's how to safely edit a container using SearXNG as an example.

```bash
# Escalate
sudo -i

# Look up container name
docker container ls

# Stop container
docker stop searxng

# Remove container
docker rm --force searxng

# !!! IMPORTANT !!!
# Never use 'docker-compose down'
# to destroy a container - it also destroys nas_network

# Go where the files are
cd /volume1/docker/searxng

# Edit a file
nano settings.yml

# Up
docker-compose up -d
```


## Composerize

[Composerize](https://www.composerize.com/) is a free online tool that converts Docker run commands into Compose files.
