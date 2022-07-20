# Pi-hole + Unbound

Pi-hole blocks incoming advertisments & trackers at the netowrk level. Unbound is a recursive DNS that adds a layer of privacy by skipping middlemen resolvers like Google DNS. 

## Vocabulary

**Server** - A dedicated physcial computer that runs services utilized by other computers. 

**Client** - Hardware or software that accesses services. 

**Host** - A computer connected to other computers for which it provides data / services over a network. The logical relationship between two computers on a network. A host must have an IP - so routers and computers are hosts, but  modems, hubs, and switches are not. 

**DNS** - A Domain Name Service server resolves domain names to IP addresses. To reach our NAS, Namecheap resolves our domains to our router, the router resolves the top-level domain to the NAS, and the NAS reverse proxy resolves subdomains to services, containers, etc. 

Pi-hole will be taking over our router's DNS responsibilities - assigning IPs to our network devices. For Internet requests, Pi-hole defaults to Google upstream DNS as the resolver. To skip Google - or any other middleman - we'll be using Unbound which goes directly to the IP's DNSs for resolution. 

**DHCP Server** - A server responsible for assigning IP addresses on a network using the Dynamic Host Configuration Protocol. Currently, our router is handeling this. We can choose to have Pi-hole be our DHCP server.  

## Fios G3100 Reset

In case I mess this up beyond my pay grade, here's how to factory reset our router. 

1. Reset button is on back of router.
2. Use a pointed object to press + hold for 15 seconds.
3. Wait several minutes for router to reboot.

## Resources

Pi-hole

* https://registry.hub.docker.com/r/pihole/pihole/
* https://github.com/pi-hole/docker-pi-hole/
* https://docs.pi-hole.net/
* https://github.com/pi-hole/docker-pi-hole#note-on-capabilities

Unbound

* https://registry.hub.docker.com/r/mvance/unbound/

Digital Aloha

* https://www.youtube.com/watch?v=1yG0p9gU104
* https://www.youtube.com/watch?v=-546g1w_L3w

Wunder Tech 

* https://www.wundertech.net/how-to-setup-pi-hole-on-a-synology-nas!-two-methods
* https://www.youtube.com/watch?v=4Z9Mtpc7Tak
* https://www.wundertech.net/use-unbound-to-enhance-the-privacy-of-pi-hole-on-a-raspberry-pi
* https://www.youtube.com/watch?v=X2J3a-x6nWA


## Examples

```
example.com = Registered domain
pihole.example.com = Subdomain with A record
unbound.example.com = Subdomain with A record
192.xxx.x.xxx = NAS internal static IP
```

## Macvlan + Bridge

After completing this step: 

* We'll have a Docker network on our LAN with a gateway at 192.168.1.217.
* Our router will see this address as a device, just like the NAS.
* This network allows 2 IP addresses - 1 for Pi-hole, 1 for Unbound. 
* The main purpose of a macvlan is to avoid port conflicts between the containers and the NAS. 
* The services run on the container can be access directly by clients on the network witout NAT translation or port forwarding. 

### NAS IP + Adapter

```
NAS
ip address

# Locate adapter where inet = NAS IP 
# Adpater = eth0
# inet 192.168.1.209/24
# The /24 tells us the subnet is 192.168.1
```

### Available IP

In the next steps, we create a macvlan network that allows 2 IP addresses - one for Pi-hole and one for Unbound. We also need to create a bridge network that allows other services on the NAS to communicate with the Pi-hole container. 

* The macvlan must be on the NAS subnet.
* The bridge must be on a different subnet. 

This step is to identify 2 different IP addresses not currently being used or reserved on our LAN. 

I have a Fios G3100 + very little knowledge. For this I looked at Advanced > Network Settings > DNS server. My assigned IPs go up to 209, so this is where I landed: 

```
# NAS
192.168.1.209     = 192.168.81.59   = NAS

192.168.1.0/24    = 192.168.81.0/24  = macvlan subnet
192.168.1.1       = 192.168.81.1     = macvlan gateway
192.168.1.217/30  = 192.168.81.28/30 = macvlan IP range, 2 IP for Pi-hole, Unbound

# /30 translates to these: 
# https://www.colocationamerica.com/ip-calculator
192.168.1.216     = 192.168.81.28 = Network = Pi-hole will default to this
192.168.1.217     = 192.168.81.29 = Gateway = Unbound will default to this
192.168.1.218     = 192.168.81.30 = First + Last
192.168.1.219     = 192.168.81.31 = Broadcast

192.168.12.0/24   = 192.168.82.0/24 = bridge subnet
192.168.12.1      = 192.168.82.1    = bridge gateway
192.168.12.227/32 = 192.168.82.2/32 = bridge IP, 1 IP for Pi-hole
```

### Macvlan via Terminal

```
NAS
sudo -i
password

sudo docker network create -d macvlan -o parent=eth0 --subnet=192.168.1.0/24 --gateway=192.168.1.1 --ip-range=192.168.1.217/30 pihole_unbound_macvlan

# Response is a network ID - a long alpha-numeric string
```

### Bridge via Docker

1. DSM > Docker > Networks > Add
2. Use manual configuration = True
3. Subnet = 192.168.12.0/24
4. IP Range = 192.168.12.227/32
5. Gateway = 192.168.12.1

## Volumes

```
# volume1/docker/pihole
# volume1/docker/pihole/pihole:/etc/pihole
# volume1/docker/pihole/dnsmasq.d:/etc/dnsmasq.d

NAS
mkdir /volume1/docker/pihole
mkdir /volume1/docker/pihole/pihole
mkdir /volume1/docker/pihole/dnsmasq.d
```

## Docker Images

1. DSM > Docker > Registry > Download:
2. pihole/pihle:latest
3. mvance/unbound:latest

## Pi-hole Container

1. DSM > Docker > Images > double-click `pihole/pihole:latest`
2. Networks
   1. pihole_unbound_mcvlan
   2. pihole_bridge
3. General
   1. Container name = pihole
   2. Execute container using high privilege = False
   3. Enable resource limitation = False
   4. Enable auto-restart = True
4. General > Advanced Settings > Environment
   1. ServerIP = 0.0.0.0
   2. TZ = America/New_York
   3. WEBPASSWORD = oectBU0UaOCga82KnoA5
   4. DNSMASQ_LISTENING: local
5. Port Settings - defaults to auto
6. Volumes
   1. /volume1/docker/pihole/pihole : /etc/pihole
   2. /volume1/docker/pihole/dnsmasq.d : /etc/dnsmasq.d

## Synology DNS

1. Control Panel > Network > General
2. Manually Configure DNS Server = True
3. Prefered = bridge IP address = 192.168.12.227

## Test Pi-hole

1. Server is accessible at: http://192.168.1.216
2. Login with WEBPASSWORD works
3. Pi-hole works via macvlan:

```
nslookup
> server 192.168.1.216 
> youtube.com
# Responses should resolve. Default server should = Pi-hole macvlan IP
```
4. Pi-hole works via bridge:

```
NAS
nslookup
> server
> youtube.com
# Responses should resolve. Server should = Pi-hole bridge IP
```

## Unbound

1. DSM > Docker > Images > double-click `mvance/unbound:latest`
2. Network
   1. pihole_unbound_macvlan
3. General
   1. Container name = unbound
   2. Execute container using high privilege = False
   3. Enable resource limitation = False
   4. Enable auto-restart = True
4. Port Settings - defaults to auto
5. Volumes
   1. Only map this volume if using a config file - we are not. 
   1. volume1/docker/unbound : /opt/unbound/etc/unbound

## Test Unbound

```
# Confirm Unbound container is running
# Ping the next IP on the macvlan
PING 192.168.1.217

# Test resolver
nslookup
> server 192.168.1.217
> youtube.com
```

## Pi-hole Settings

1. Pi-hole > Settings > DNS
2. Disable Google upstream
3. Enable Custom 1 upstream = Unbound macvlan IP = 192.168.1.217
4. Save

## Test Pi-hole + Unbound

```
nslookup
> server 192.168.1.216
> youtube.com
```

## Implement Pi-hole

Method I: Chang IP address of a device to the Pi-hole macvlan IP = 192.168.1.216

1. Start > Settings > Network & Internet > DNS Server Assignment
2. Change from Automatic (DHCP) to:
   1. Manual
   2. IPv4 = On
   3. Prefered DNS = 192.168.1.216
   4. IPv6 = Off
   5. Save

Method II: Use DHCP on Fios router to point all DHCP devices to Pi-hole's macvaln IP = 192.168.1.216

* Assign clients on the network the macvlan IP address
* Assign services on the NAs the bridge IP address
* 


## Portainer instructions I didn't use

### Macvlan via Portainer

NOT SURE ABOUT THIS - used Terminal 

Portainer > local > Networks > Add network - Add the configuration:

```
Network = pihole_unbound_macvlan_config
Driver = macvlan
Configuration = Config network before deploying
Parent Network Card  = eth0
IPV4 Subnet = 192.168.1.0/24
IPV4 Gateway = 192.168.1.1
IPV4 IP Range = 192.168.1.217/30 - 2 usable IPs
```

Network > Add network - Use config to add network

```
Network = pihole_unbound_macvlan
Driver = macvlan
Configuration = Create from a configuration
Configuration = pihole_unbound_macvlan_config
Isolated Network = False
Enable Manual Container Attachment = False
```

### Bridge via Portainer

NOT SURE ABOUT THIS - used Docker GUI

Portainer > local > Networks > Add network

```
Network = pihole_bridge
Driver = bridge
IPV4 Subnet = 192.168.12.0/24
IPV4 Gateway = 192.168.12.1
IPV4 IP Range = 192.168.12.227/32 - 1 usable IP
Isolated Network = False
Enable Manual Container Attachment = False
```

### Pi-hole Stack

https://www.youtube.com/watch?v=1yG0p9gU104 

```
version: '2'

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    restart: unless-stopped
    # For DHCP it is recommended to remove these ports and instead add: network_mode: 'host'.
    # Remember, Pi-hole is using macvlan with it's own IP, so these don't conflict with NAS.
    ports:
      - '53:53/tcp'
      - '53:53/udp'
      - '80:80/tcp'
      # Required for Pi-hole as DHCP server
      - '67:67/udp'
    environment:
      ServerIP: '0.0.0.0'
      # ServerIP: '192.168.1.217'
      TZ: 'America/New_York'
      WEBPASSWORD: 'oectBU0UaOCga82KnoA5'
      DNSMASQ_LISTENING: 'local'
    volumes:
      - /volume1/docker/pihole/pihole:/etc/pihole
      - /volume1/docker/pihole/dnsmasq.d:/etc/dnsmasq.d
    cap_add:
      # Required for Pi-hole as DHCP server, recommended otherwise
      - NET_ADMIN  
```

### Unbound Stack

```
version: '2'

services:
  pihole:
    container_name: umbound
    image: mvance/unbound:latest
    restart: unless-stopped
    environment:
    volumes: 
      - /volume1/docker/unbound:/opt/unbound/etc/unbound
    ports:
      - '53:53/tcp'
      - '53:53/udp'

```