# Network Reference

## URL Progression

A running list of how URLs progress from port to domain to subdomain.

```bash
# DSM
http://192.168.1.209:6049
https://192.168.1.209:6050

http://site.com:6049
https://site.com:6050

http://dsm.site.com
https://dsm.site.com

# Portainer
# http://192.168.1.209:9443
https://192.168.1.209:9443

# NGINX
http://192.168.1.209:8181
https://192.168.1.209:8181

http://site.com:8181
https://site.com:8181

http://proxy.site.com
https://proxy.site.com


# Pi-hole
http://10.2.0.100/admin

# SearXNG
http://192.168.1.209:8484

# Plex
http://192.168.1.209:32400
https://192.168.1.209:32400

http://site.com:32400
https://site.com:32400

http://plex.site.com
https://plex.site.com
```

## Initial NAS Firewall Rules

These ports should be open for the majority of the setup steps. These rules assume you are following the examples exactly. 

1. DSM > Control Panel > Security > Firewall
2. Enable Firewall = True
3. Enable Firewall Notifications = True
4. Firewall Profile = Default > Edit Rules - dialog opens
5. Create > Ports > Custom Port

```bash
6049 TCP    # NAS HTTP 5000
6050 TCP    # NAS HTTPS 5001
49200 TCP   # NAS SSH 22

9443 TCP    # Portainer web UI
8484 TCP    # SearXNG web UI
32400 TCP   # Plex web UI

80 TCP      # Let's Encrypt   
443 TCP     # Let's Encrypt 

4443 TCP    # nginx-proxy HTTPS
8080 TCP    # nginx-proxy HTTP
8181 TCP    # nginx-proxy web UI

8753 UDP    # Pi-hole DNS traffic
8753 TCP    # Pi-hole DNS traffic
8780 TCP    # Pi-hole Web UI
8743 TCP    # Pi-hole Web UI
```

## Final NAS Firewall Rules

```bash
# The last / bottom rule should
# always = Deny All
```

## Cloudflare DNS Records

```bash
# DNS records for site.com
# 102.19.146.13 = router's public IPv4
# Proxy Status = Disabled until SSL cert is obtained
A @           102.19.146.13
CNAME www     @
CNAME dsm     @
CNAME proxy   @ 
CNAME plex    @
CNAME search  @
CNAME port    @
CNAME pi      @
CNAME vault   @
```

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
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443

# Port forwarding to NGINX 
80  TCP 192.168.1.209 8080
443 TCP 192.168.1.209 4443

# Port forwarding final rules
# 80  TCP 192.168.1.209 ???
# 443 TCP 192.168.1.209 ???
```

## NGINX Proxy Hosts

```bash
proxy.site.com    http  192.168.1.209 8181
dsm.site.com      https 192.168.1.209 6050
port.site.com     https 192.168.1.209 9443
plex.site.com     https 192.168.1.209 32400

search.site.com   https 192.168.1.209 7780
```

## Docker nas_network

```bash
172.29.7.0/24     # Subnet
172.29.7.1        # Gateway 
172.29.7.2        # NGINX Proxy Manager
172.29.7.3        # NGINX MariaDB
172.29.7.4        # Pi-hole server
172.29.7.5        # Unbound server
172.29.7.6        # Portainer
  7680:8000 TCP   # Portainer edge agents
  7643:9443 TCP   # Portainer web UI
172.29.7.7        # SearXNG
  7780:8080 TCP   # SearXNG web UI
# 172.29.7.8      # SearXNG redis

# NAS port : Container port
# For NAS ports
# First 2/3 digits = last digits of IP - 71 72 73...
# Last 2 digits = protocol - 7680 7643
```


## Networks + Ports

```bash
# Ports are sometimes referenced as local:container
# If you need to change a port, it's the local (first) port

# NAS static IP
192.168.1.209

# SSH > ip addr
127.0.0.1/8       # lo inet
192.168.1.209/24  # eth0 inet

# DSM > Control Panel > Login Portal > DSM tab
6049 TCP    # NAS HTTP 5000
6050 TCP    # NAS HTTPS 5001

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200 TCP   # NAS SSH 

# Let's Encrypt
80 TCP    
443 TCP

# Portainer
9443:9443 TCP     # Web UI
8000              # Internal exposed tunnel
9001              # Internal Portainer agents listen

# NGINX 
3306:3306 TCP     # Internal nginx-mariadb
4443:443 TCP      # nginx-proxy HTTPS
8080:80 TCP       # nginx-proxy HTTP
8181:81 TCP       # nginx-proxy web UI

# Servers
32400 TCP         # Plex Media Server web UI
8484:8080 TCP     # SearXNG web UI

# Pi-hole
172.29.0.0/24     # Subnet
172.29.0.1        # Gateway    
172.29.0.2        # Pi-hole server
172.29.0.3        # Unbound server

8753:53 UDP       # DNS traffic
8753:53 TCP       # DNS traffic
8780:80 TCP       # Web UI
8743:443 TCP      # Web UI
```


## References

At several points you'll change a default port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

