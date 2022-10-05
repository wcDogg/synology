# Install Pi-hole and Unbound on Synology NAS

A Synology-specific version of [chriscrowe/docker-pihole-unbound](https://github.com/chriscrowe/docker-pihole-unbound/tree/main/two-container)


## Install

```bash
# Escalate to root
sudo -i
password

# Go here and make these dirs
cd /volume1/docker
mkdir -p pi-hole/etc-pihole
mkdir -p pi-hole/etc-dnsmasq.d
# mkdir -p pi-hole/etc-unbound

# Create .env file
cd pi-hole
nano .env

# Add these lines to .env
TZ="America/New_York"
WEBPASSWORD="oectBU0UaOCga82KnoA5"

# Get docker-compose.yml
curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/docker-compose.yml -o docker-compose.yml

# # Get unbound.conf
# cd etc-unbound

# curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/etc-unbound/unbound.conf -o unbound.conf

# Docker up
cd ..
docker-compose up -d
```

## TODO: Log Permissions

```bash
# Go here
DSM > Docker > Containers > Unbound > Details > Logs

# Note this error
[1664924122] unbound[1:0] error: Could not open logfile /dev/null: Permission denied
```

## Sign In

1. http://192.168.1.209:7480/admin
2. PW = what you set in .env file
3. Go to Settings > DNS. Note that:
   1. Upstream DNS Servers = 172.29.7.5 (Unbound)
   2. Interface Settings = Respond only on eth0


## Test Internally from SSH Shell

At this point, all of these should work: 

```bash
# Unbound Docker container
ping 172.29.7.5
nslookup pi-hole.net 172.29.7.5
dig pi-hole.net @172.29.7.5 -p 53
# Unbound NAS port
nslookup -port=7453 pi-hole.net 192.168.1.209
dig pi-hole.net @192.168.1.209 -p 7453

# Pi-hole Docker Container
ping 172.29.7.4
nslookup -port=53 pi-hole.net 172.29.7.4
dig pi-hole.net @172.29.7.4 -p 53
# Pi-hole NAS port
nslookup -port=7553 pi-hole.net 192.168.1.209
dig pi-hole.net @192.168.1.209 -p 7553
```

## XX - Synology DNS

1. DSM > Control Panel > Network > General
2. Manually Configure DNS Server = True
   1. Preferred = Pi-hole IP = 172.29.7.4
   2. Remove Alt = blank
3. Apply

The following should now work - no port or server needed.

```bash
nslookup pi-hole.net
```

## Test Externally from a Separate Command Line

```bash
nslookup pi-hole.net 192.168.1.209

nslookup pi-hole.net pi.wcd.black

# Unbound
nslookup -port=7453 pi-hole.net 192.168.1.209
nslookup pi-hole.net 172.29.7.5

# Pi-hole + Unbound
nslookup -port=7553 pi-hole.net 192.168.1.209
nslookup pi-hole.net 172.29.7.4


```

