# Network Reference

## URL Progression

A running list of how URLs progress from port to domain to subdomain.

```bash
# DSM
http://192.168.1.209:6049
http://wcd.black:6049
https://wcd.black:6050
http://dsm.wcd.black


# NGINX
http://192.168.1.209:8181
http://wcd.black:8181
# https://wcd.black:4443
http://proxy.wcd.black


# Plex
http://192.168.1.209:32400
http://wcd.black:32400
# https://wcd.black:32400
http://plex.wcd.black
```

## Initial NAS Firewall Rules

These ports should be open for the majority of the setup steps. These rules assume you are following the examples exactly. 

1. DSM > Control Panel > Security > Firewall
2. Enable Firewall = True
3. Enable Firewall Notifications = True
4. Firewall Profile = Default > Edit Rules - dialog opens
5. Create > Ports > Custom Port

```bash
# DSM > Control Panel > Login Portal > DSM tab
# DSM > Control Panel > External Access > Advanced tab
6049/TCP    # NAS HTTP 5000
6050/TCP    # NAS HTTPS 5001

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200/TCP   # NAS SSH 

# Let's Encrypt
80/TCP    
443/TCP

# NGINX 
3306 TCP   # nginx-mariadb
4443 TCP   # nginx-proxy HTTPS
8080 TCP   # nginx-proxy HTTP
8181 TCP   # nginx-proxy web UI

# The last / bottom rule should
# always = Deny All
```

## Final NAS Firewall Rules

```bash
# Servers
32400/TCP   # Plex Media Server
```

## Cloudflare DNS Records

```bash
# DNS records for site.com
# 102.19.146.13 = router's public IPv4
# Proxy Status = Disabled until SSL cert is obtained
A @     102.19.146.13  Proxy Status = Disabled 
A www   102.19.146.13  Proxy Status = Disabled 
A dsm   102.19.146.13  Proxy Status = Disabled
A proxy 102.19.146.13  Proxy Status = Disabled 
A plex  102.19.146.13  Proxy Status = Disabled 
```

## Fios G3100 Router

* Port Check: https://www.portchecktool.com/

```bash
# NAS static IP
# Advanced > Network Settings > IPv4 Address Distribution
192.168.1.209

# Point TLD at NAS static IP
# Advanced > Network Settings > DNS Server
wcd.black -> 192.168.1.209

# Port forwarding during NAS config
# Advanced > Security & Firewall > Port Forwarding
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443

# Port forwarding during NGINX config
80  TCP 192.168.1.209 8080
443 TCP 192.168.1.209 4443

# Port forwarding final rules
80  TCP 192.168.1.209 
443 TCP 192.168.1.209 
```

## Networks + Ports

```bash
# NAS static IP
192.168.1.209
# SSH > ip addr
192.168.1.209/24  # eth0 inet

# DSM > Control Panel > Login Portal > DSM tab
6049/TCP    # NAS HTTP
6050/TCP    # NAS HTTPS, Synology Photos

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200/TCP   # NAS SSH 

# Let's Encrypt
80/TCP    
443/TCP

# NGINX 
npm_bridge        # Network name
192.168.14.0/24   # Subnet
192.168.14.1      # Gateway
192.168.14.2/32   # IP range (single IP)

npm_network       # Network name
192.168.15.0/24   # Subnet
192.168.15.1      # Gateway
192.168.15.2/32   # IP range (single IP)

# Local (editable) -> Container
3306 3306 TCP     # nginx-mariadb
4443 443 TCP      # nginx-proxy HTTPS
8080 80 TCP       # nginx-proxy HTTP
8181 81 TCP       # nginx-proxy web UI

# Servers
32400/TCP   # Plex Media Server

# SSH > ip addr
127.0.0.1/8       # lo inet
192.168.1.209/24  # eth0 inet
```

## Scratch

```bash
NAS
nslookup
> server

# Default server: 192.168.1.1
# Address: 192.168.1.1#53

nslookup
> server 192.168.1.217

# Default server: 192.168.1.217
# Address: 192.168.1.217#53
```


## References

At several points you'll change a default port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

