# Install SearXNG


## Install

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volumes
mkdir searxng

# Get compose file
cd searxng

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/searxng/docker.compose.yml -o docker-compose.yml

# Review compose file
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Test

1. http://
   

## References

* GitHub: [SearXNG](https://github.com/searxng)
