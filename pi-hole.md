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
# TODO curl here

# Get conf file
cd unbound
# TODO curl here

# Docker up
cd ..
docker-compose up -d

# Exit sudo -i
exit
```

