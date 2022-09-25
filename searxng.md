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

# Get files
cd searxng

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/searxng/docker.compose.yml -o docker-compose.yml

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/searxng/settings.yml -o settings.yml


# Review compose file
# Server time zone
cd ..
nano docker-compose.yml

# Review settings file
nano ./etc/settings.yml

# Docker up
docker-compose up -d
```

## Access

1. http://192.168.1.209:7780
   

## References

* [SearXNG GitHub](https://github.com/searxng)
* https://docs.searxng.org/admin/engines/settings.html
* https://github.com/searxng/searxng/blob/master/searx/settings.yml
* https://docs.searxng.org/admin/installation-uwsgi.html
* https://github.com/searxng/searxng/blob/master/dockerfiles/uwsgi.ini
