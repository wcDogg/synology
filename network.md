# Network Reference

```bash
# DSM
http://192.168.1.209:6049

# NGINX
http://192.168.15.2:81

# Plex


```

## Initial Firewall Rules

These ports should be open for the majority of the setup steps. These rules assume you are following the examples exactly. 

1. DSM > Control Panel > Security > Firewall
2. Enable Firewall = True
3. Enable Firewall Notifications = True
4. Firewall Profile = Default > Edit Rules - dialog opens
5. Create > Ports > Custom Port
6. OK. OK. OK. Confirmation msg.
7. IMPORTANT: Always ensure the Deny All rule is last - at bottom of list.

```bash
# DSM > Control Panel > Login Portal > DSM tab
6049/TCP    # NAS HTTP
6050/TCP    # NAS HTTPS, Synology Photos

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200/TCP   # NAS SSH 

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200/TCP   # NAS SSH 

# Let's Encrypt
80/TCP    
443/TCP

# NGINX 
3306 TCP     # nginx-mariadb
443 TCP      # nginx-proxy HTTPS
80 TCP       # nginx-proxy HTTP
81 TCP       # nginx-proxy web UI

# The last / bottom rule should
# always = Deny All
```

## Final Firewall Rules

```bash
# Servers
32400/TCP   # Plex Media Server
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

# Local -> Container
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

## References

At several points you'll change a default port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

