# Synology DS920+ with DSM 7

Managed from Windows 11 Pro, which usually doesn't matter, sometimes does.

## Resources

* [WunderTech YouTube](https://www.youtube.com/c/WunderTechTutorials)
* [WunderTech Blog](https://www.wundertech.net/)

## Ports

At several points you'll change a defualt port or define a new port. 

* NAS ports in use: DSM > Info Center > Services tab
* [Synology: DSM Services Ports](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
* [Synology: How do I know if a TCP port is open or closed?](https://kb.synology.com/tr-tr/DSM/tutorial/Whether_TCP_port_is_open_or_closed)


```
# SSH as root. See running services.
netstat -pat | grep LISTEN
```

## Contents

* [Inital Setup](nas-setup.md)
* [SSH](ssh.md)
* [Docker + Portainer](docker-portainer.md)
* Proxy manager + reverse proxy
* Bitwarden in Docker
* PiHole + Unbound in Docker
* 

