# Install VaultWarden on Synology NAS


## Install

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volume
mkdir vaultwarden

# Get compose file
cd vaultwarden

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/vaultwarden/docker-compose.yml -o docker-compose.yml

# Review compose file
# No changes needed
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## View Site

You will not be able to create an account until an SSL certificate is added, but the Log In screen should be available: 

* http://192.168.1.209:7880


## References

* [dockerhub: vaultwarden](https://hub.docker.com/r/vaultwarden/server)
* [GitHub: vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
* [GitHub: vaultwarden Docker Compose](https://github.com/dani-garcia/vaultwarden/wiki/Using-Docker-Compose)
* https://www.youtube.com/watch?v=fQOqqJv1zCI

