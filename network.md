# Network Reference


## Fios G3100 Router

* Port Check: https://www.portchecktool.com/

```bash
# NAS static IP
# Advanced > Network Settings > IPv4 Address Distribution
192.168.1.209

# Computer static IP
192.168.1.208

# Point TLD at NAS static IP
# Advanced > Network Settings > DNS Server
site.com -> 192.168.1.209

# Port forwarding to NAS during config
# Advanced > Security & Firewall > Port Forwarding
# Origin port - Protocol - NAS IP - NAS port
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443

# Port forwarding once NAS is configured
80  TCP 192.168.1.209 7080
443 TCP 192.168.1.209 7043

# Port forwarding to NGINX 
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

172.29.7.4        # pi-hole server
  7453:53/tcp       # pi-hole DNS
  7453:53/udp       # pi-hole DNS
  7480:80/tcp       # pi-hole web UI HTTP
  7443:443/tcp      # pi-hole web UI HTTPS
172.29.7.5        # unbound server
  7553:53/tcp       # DNS traffic
  7553:53/udp       # DNS traffic

172.29.7.6        # portainer
  7680:8000 TCP     # portainer edge agents
  7643:9443 TCP     # portainer web UI

172.29.7.7        # searxng
  7780:8080 TCP     # searxng web UI

172.29.7.8        # vaultwarden
  7880:80           # vaultwarden web UI
```

## Cloudflare DNS Records

```bash
# DNS records for site.com
# Proxy Status = Disabled until SSL cert is obtained

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
dsm.site.com      https 192.168.1.209 7043
# pi.site.com       http 192.168.1.209 7480
plex.site.com     https 192.168.1.209 32400
port.site.com     https 192.168.1.209 7643
# proxy.site.com    http  192.168.1.209 7281
search.site.com   http 192.168.1.209 7780
vault.site.com    http 192.168.1.209 7880
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
# NPM
http://192.168.1.209:7281
http://site.com:7281

http://proxy.site.com - Congrats page, not login? 
# https://proxy.site.com

#
# Pi-hole
http://192.168.1.209:7480/admin
http://site.com:7480/admin

# http://192.168.1.209:7480/admin
# http://site.com:7480/admin

# http://pi.site.com/admin
# https://pi.site.com/admin

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

