# Install SearXNG

* This container does not use Caddy - we're using NPM for SSL
* This container does not use redis - it causes the SearXNG container's CPU usage to spike into the red every few seconds.

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
nano docker-compose.yml

# Review settings file
nano settings.yml

# Docker up
docker-compose up -d
```

## Access

* http://192.168.1.209:7780
   

## TODO

* Fix `ERROR:searx.shared: uwsgi.ini configuration error, add this line to your uwsgi.ini`


## References

* [SearXNG GitHub](https://github.com/searxng)
* https://github.com/searxng/searxng-docker/blob/master/docker-compose.yaml
* https://docs.searxng.org/admin/engines/settings.html
* https://github.com/searxng/searxng/blob/master/searx/settings.yml
* https://docs.searxng.org/admin/installation-uwsgi.html
* https://github.com/searxng/searxng/blob/master/dockerfiles/uwsgi.ini
* https://github.com/searxng/searxng/blob/master/searx/languages.py

