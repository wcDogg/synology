# Network Reference


## NAS Firewall Rules

```bash
# Initial Rules

7080 TCP    # NAS HTTP 5000
7043 TCP    # NAS HTTPS 5001
7022 TCP    # NAS SSH 22

7243 TCP    # nginx-proxy HTTPS
7280 TCP    # nginx-proxy HTTP
7281 TCP    # nginx-proxy web UI

7453 TCP    # pi-hole DNS
7453 UDP    # pi-hole DNS
7480 TCP    # pi-hole web UI HTTP

7680 TCP    # portainer edge agents
7643 TCP    # portainer web UI

7780 TCP    # searxng web UI
7880 TCP    # vaultwarden web UI
32400 TCP   # Plex

# Final Rules

7022 TCP    # NAS SSH 22
```


## Fios G3100 Router

* Port Check: https://www.portchecktool.com/

```bash
# LAN
192.168.1.0/24  # Subnet
192.198.1.1     # Default Gateway

# Static IPs
# Advanced > Network Settings > IPv4 Address Distribution
192.168.1.209   # NAS

# Point TLD at NAS static IP
# Advanced > Network Settings > DNS Server
site.com -> 192.168.1.209

# Port forwarding
# Advanced > Security & Firewall > Port Forwarding
# Origin port - Protocol - NAS IP - NAS port

# Initial port forwarding to NAS during config
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443

# Port forwarding once NAS ports are configured
# 80  TCP 192.168.1.209 7080
# 443 TCP 192.168.1.209 7043

# Final port forwarding to NGINX 
80  TCP 192.168.1.209 7280
443 TCP 192.168.1.209 7243
```

## NAS and Docker nas_network

```bash
# NAS static IP
127.0.0.1/8       # lo inet
192.168.1.209/24  # eth0 inet

# DSM > Control Panel > Login Portal > DSM tab
7080 TCP    # NAS HTTP 5000
7043 TCP    # NAS HTTPS 5001

# DSM > Control Panel > Terminal & SNMP > Terminal tab
7022 TCP    # NAS SSH 22

# Plex
32400 TCP   # Default
# 7032 TCP    # Custom

# Docker nas_network
172.29.7.0/24     # Subnet
172.29.7.1        # Gateway 

172.29.7.2        # nginx-proxy
  7243:443 TCP      # nginx-proxy HTTPS
  7280:80 TCP       # nginx-proxy HTTP
  7281:81 TCP       # nginx-proxy web UI
172.29.7.3        # nginx-mariadb
  7333 TCP          # nginx-mariadb internal
  80 TCP            # Let's Encrypt  
  443 TCP           # Let's Encrypt

172.29.7.4        # pi-hole
  7453:53 TCP       # pi-hole DNS
  7453:53 UDP       # pi-hole DNS
  7480:80 TCP       # pi-hole web UI HTTP
172.29.7.5        # unbound
  7553:53 TCP       # unbound DNS
  7553:53 UDP       # unbound DNS

172.29.7.6        # portainer
  7680:8000 TCP     # portainer edge agents
  7643:9443 TCP     # portainer web UI

172.29.7.7        # searxng
  7780:8080 TCP     # searxng web UI

172.29.7.8        # vaultwarden
  7880:80           # vaultwarden web UI

172.29.7.9        # cloudflare-ddns

# Docker pi_macvlan
# Look at your router and identify 4 sequential IP addresses not in use. 
# I have 192.168.1.216 - 219 available
# In the Docker command to create pi_macvlan,
# we use the second available IP as follows: 
192.168.1.217/30 

# The /30 gives us 2 usable IPs on the LAN, but occupies 4 IPs
192.168.1.216     # Network = Pi-hole will default to this
  7453:53 TCP       # pi-hole DNS
  7453:53 UDP       # pi-hole DNS
  7480:80 TCP       # pi-hole web UI HTTP
192.168.1.217     # Gateway = Unbound will default to this
  7553:53 TCP       # unbound DNS
  7553:53 UDP       # unbound DNS
192.168.1.218     # First + Last
192.168.1.219     # Broadcast
```

## Cloudflare DNS Records

```bash
# DNS records for site.com
# Proxy Status = Disabled until SSL certs are obtained
# Would normally use all A records to avoid 2nd hop,
# but Cloudflare 'flattens' records. 

A @           102.19.146.13  # Router public IPv4
CNAME www     @
CNAME dsm     @
CNAME pi      @
CNAME plex    @
CNAME port    @
CNAME proxy   @ 
CNAME search  @
CNAME vault   @
```

## NGINX Proxy Hosts

```bash
# Get SSL first, then create proxy host
proxy.site.com    http  192.168.1.209 7281
pi.site.com       http  192.168.1.209 7480

# Okay to get SSL while creating proxy host
dsm.site.com      https 192.168.1.209 7043
plex.site.com     https 192.168.1.209 32400
port.site.com     https 192.168.1.209 7643
search.site.com   http  192.168.1.209 7780
vault.site.com    http  192.168.1.209 7880
```

## URL Progression

A running list of how URLs progress from port to domain to subdomain.

```bash
#
# DSM - DONE
# 7080 should redirect to 7043
http://192.168.1.209:7080 -->
https://192.168.1.209:7043

http://site.com:7080 -->
https://site.com:7043

http://dsm.site.com -->
https://dsm.site.com

#
# NPM - DONE
http://192.168.1.209:7281
http://site.com:7281

http://proxy.site.com   # Un-proxied Congrats page
https://proxy.site.com  # Proxied web UI

#
# Pi-hole - DONE
http://192.168.1.216/admin        # pi_macvlan
http://192.168.1.209:7480/admin   # nas_network
https://site.com/admin            # Proxied nas_network

#
# Portainer - DONE
https://192.168.1.209:7643
https://site.com:7643
http://port.site.com
https://port.site.com

#
# Plex - DONE
http://192.168.1.209:32400
http://site.com:32400
http://plex.site.com
https://plex.site.com

#
# Search - DONE
http://192.168.1.209:7780
http://site.com:7780
http://search.site.com
https://serach.site.com

#
# VaultWarden - DONE
http://192.168.1.209:7880
http://site.com:7880
http://vault.site.com
https://vault.site.com
```

## References

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

