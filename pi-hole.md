# Install Pi-hole and Unbound on Synology NAS

For other devices to use Pi-hole, we must expose its container on the LAN so that the router sees it as a device, just as it sees the NAS. This is done with a Docker macvlan network named `pi_macvlan`. 

Pi-hole also needs a bridge network to communicate with other NAS services - this is what `nas_network` is for.


## Interface Name

Confirm the name of the interface connecting the NAS and LAN - typically `eth0`.

```bash
# Run this + look for interface where inet = NAS static IP
ifconfig
```

## Available IPs

Look at your router and identify 4 sequential IP addresses not in use. 

```bash
# Router LAN
192.168.1.0/24  # Subnet
192.198.1.1     # Default Gateway

# I have IPs 216 - 219 available
# In the Docker command below we use the second IP
192.168.1.217/30 

# The /30 gives us 2 usable IPs on the LAN, but occupies 4 IPs
192.168.1.216     # Network = Pi-hole will default to this
192.168.1.217     # Gateway = Unbound will default to this
192.168.1.218     # First + Last
192.168.1.219     # Broadcast
```

## Create Docker macvlan

```bash
# Escalate
sudo -i
password

# macvlan
docker network create -d macvlan -o parent=eth0 --subnet=192.168.1.0/24 --gateway=192.168.1.1 --ip-range=192.168.1.217/30 pi_macvlan
```

## Install Pi-hole

```bash
# Escalate
sudo -i
password

# Go here and make these dirs
cd /volume1/docker
mkdir -p pi-hole/etc-pihole
mkdir -p pi-hole/etc-dnsmasq.d

# Create .env file
cd pi-hole
nano .env

# Add these lines to .env
TZ="America/New_York"
WEBPASSWORD="oectBU0UaOCga82KnoA5"

# Get docker-compose.yml
curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/pi-hole/docker-compose.yml -o docker-compose.yml

# Docker up
cd ..
docker-compose up -d
```

## Add Containers to pi_macvlan

The `docker-compose.yml` adds Pi-hole and Unbound to `nas_network`. Additionally, both need to be manually added to `pi_macvlan`.

1. DSM > Docker > Networks
2. Highlight `pi_macvlan` and click the Manage button
3. Order matters: 
   1. Click Add and select the unbound container
   2. Click Add and select the pi-hole container
   3. Net result is that pi-hole is listed first :)


## Test Resolvers

At this point both Pi-hole and Unbound can resolve DNS requests via `pi_macvlan`. Test externally from a new shell:

```bash
# Pi-hole
nslookup -port=53 pi-hole.net 192.168.1.216

# Unbound
nslookup -port=53 pi-hole.net 192.168.1.217
```

## Tell NAS to use Pi-hole

1. DSM > Control Panel > Network > General
2. Manually Configure DNS Server = True
   1. Preferred = Pi-hole nas_network IP = 172.29.7.4
   2. Remove Alt = blank
3. Apply

Test internally from an SSH shell:

```bash
# This should be resolved by 
# Server Address 172.29.7.4#53 
nslookup pi-hole.net
```

## Sign In 

At this point, Pi-hole is accessible at:

* pi_macvlan - http://192.168.1.216/admin 
* nas_network - http://192.168.1.209:7480/admin   

Sign in to the pi_macvlan address using the password you supplied in `.env`. 

For pi_macvlan, if you get 'Site cannot be reached' try http://192.168.1.217/admin. If this works, the containers were added to the `pi_macvlan` network in the wrong order. Go to Docker > Networks, remove the containers from `pi_macvlan`, then add them again as described above. 


## Tell Pi-hole to use Unbound

1. Pi-hole > Settings > DNS tab
2. Upstream DNS Servers 
   1. Uncheck all boxes for existing services - probably just Google.
   2. Check the Custom 1 and Custom 2 boxes
   3. Fill each with: 192.168.1.217 (Unbound pi_macvlan IP)
3. Interface Settings = Allow only local requests
4. Scroll down and click Save
5. Settings > System tab > Restart DNS Resolver button (bottom right)

```bash
# Test from external shell
nslookup -port=53 pi-hole.net 192.168.1.216
```

## Implement Pi-hole

Because I don't have a redundant Pi-hole, it's best if I implement Pi-hole per-device - vs on my router. 

Start by pulling up a Pi-hole test site:

* https://fuzzthepiguy.tech/adtest/
* https://canyoublockit.com/

On a Windows PC the process is: 

1. Start > Settings > Network & Internet > Ethernet
2. DNS Server Assignment > Edit
3. Change from Automatic (DHCP) to Manual
4. IPv4 = On
   1. Preferred DNS = 192.168.1.216
   2. DNS over HTTPS = Off
5. IPv6 = Off
6. Save

I needed to reboot for changes to take effect. 


## TODO: Log Permissions

```bash
# Go here
DSM > Docker > Containers > Unbound > Details > Logs

# Note this error
[1664924122] unbound[1:0] error: Could not open logfile /dev/null: Permission denied
```

