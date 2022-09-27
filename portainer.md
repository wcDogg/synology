# Portainer


## Install

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volume
mkdir portainer

# Get compose file
cd portainer

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/portainer/docker-compose.yml -o docker-compose.yml

# Review compose file
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Sign In

Portainer generates a self-signed SSL so you can sign in at an HTTP URL. Weirdly, it will still be insecure?

1. https://192.168.1.209:9443
2. Follow screen to create a new user
3. Select 'Get Started' to use local environment


## References

* https://docs.portainer.io/start/install/server/docker/linux
* https://www.portainer.io/
* https://www.youtube.com/watch?v=bLHWxtrU8Tg
* https://www.wundertech.net/how-to-install-portainer-on-a-synology-nas

