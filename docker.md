# Install Docker on Synology NAS and Create Docker Network


## Install Docker

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

## About Docker nas_network

* The purpose of this network is to avoid port conflicts between the NAS and Docker containers. 
* All Docker containers are added to this network.
* Each container is given a static IP on this network via its `docker-compose.yml`.
* Containers that need to communicate with each other - ie Pi-hole and Unbound - do NOT need a separate bridge. 

**IMPORTANT** All Docker compose files assume this exact network. See [Network Reference: Docker nas_network](network.md) for a running list of containers in this project.


## Create nas_network

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

TODO


## Composerize

[Composerize](https://www.composerize.com/) is a free online tool that converts Docker run commands into Compose files.
