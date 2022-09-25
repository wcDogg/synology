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
```


## References

At several points you'll change a default port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

