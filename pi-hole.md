# Pi-hole and Unbound


## Install

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volumes
mkdir -p pi-hole/unbound
mkdir -p pi-hole/etc-pihole
mkdir -p pi-hole/etc-dnsmasq.d

# Get compose file
cd pi-hole

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/docker-compose.yml -o docker-compose.yml

# Get conf file
cd unbound

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/unbound/unbound.conf -o unbound.conf

# Review compose file
cd ..
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Sign In

1. http://10.2.0.100/admin
2. Temp PW = changeme

