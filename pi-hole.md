# Install Pi-hole and Unbound on Synology NAS


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
# Set a strong password!!!
cd ..
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Sign In

1. http://192.168.1.209:7480/admin
2. Default PW = StrongPWhere - but you should have changed it in the compose file!
3. Go to Settings > DNS. Note that:
   1. Upstream DNS Servers = 172.29.7.5 (Unbound)
   2. Interface Settings = Respond only on eth0


## Test Internally from SSH Shell

```bash
192.168.1.209 -p 7553
192.168.1.209 -p 7453
172.29.7.4
172.29.7.5

# Pi-hole
# Status should = SERVFAIL
dig sigfail.verteiltesysteme.net @192.168.1.209 -p 7553

# Status should = NOERROR 
dig sigok.verteiltesysteme.net @192.168.1.209 -p 7553

# Status should = NOERROR 
dig pi-hole.net @192.168.1.209 -p 7553


# Unbound
```


