# Install Pi-hole and Unbound on Synology NAS

A Synology-specific version of [chriscrowe/docker-pihole-unbound](https://github.com/chriscrowe/docker-pihole-unbound/tree/main/two-container)


## Install

```bash
# Escalate to root
sudo -i
password

# From / create Unbound log directory
mkdir -p /var/log/unbound
chown unbound:unbound /var/log/unbound

# Go here
cd /volume1/docker

# Create volumes
mkdir -p pi-hole/etc-pihole
mkdir -p pi-hole/etc-dnsmasq.d
mkdir -p pi-hole/etc-unbound

# Create .env file
cd pi-hole
nano .env

# Add these lines to .env
TZ="America/New_York"
WEBPASSWORD="oectBU0UaOCga82KnoA5"

# Get docker-compose.yml
curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/docker-compose.yml -o docker-compose.yml

# Get unbound.conf
cd etc-unbound

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/etc-unbound/unbound.conf -o unbound.conf

# Docker up
cd ..
docker-compose up -d
```

## Fix

```bash
[1664918574] unbound[1:0] error: Could not open logfile /dev/null: Permission denied

mkdir -p /var/log/unbound
chown unbound:unbound /var/log/unbound

touch /var/log/unbound
chown unbound:unbound /var/log/unbound
```


## Sign In

1. http://192.168.1.209:7480/admin
2. Default PW = oectBU0UaOCga82KnoA5
3. Go to Settings > DNS. Note that:
   1. Upstream DNS Servers = 172.29.7.5 (Unbound)
   2. Interface Settings = Respond only on eth0


## Test Internally from SSH Shell

```bash
# Status = NOERROR 

# Unbound
dig pi-hole.net @192.168.1.209 -p 7453

# Pi-hole + Unbound
dig pi-hole.net @192.168.1.209 -p 7553
```

## Test Externally from a Separate Command Line

```bash
# Unbound
nslookup -port=7453 pi-hole.net 192.168.1.209

# Pi-hole + Unbound
nslookup -port=7553 pi-hole.net 192.168.1.209
```

