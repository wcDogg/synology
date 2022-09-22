# Network Reference



```bash
# NAS static IP
192.168.1.209

# DSM > Control Panel > Login Portal > DSM tab
6049/TCP    # NAS HTTP
6050/TCP    # NAS HTTPS, Synology Photos

# DSM > Control Panel > Terminal & SNMP > Terminal tab
49200/TCP   # NAS SSH 

# Servers
32400/TCP   # Plex

# Let's Encrypt
80/TCP    
443/TCP
```

## References

At several points you'll change a default port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)

