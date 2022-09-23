# Remote Access using a Custom Domain

How to access your NAS remotely:

* Using a custom domain over HTTPS
* Using Cloudflare to proxy (hide) your home IP address
* Using Synology Proxy Server to limit open ports

With no:

* No VPN
* No Synology Quick Connect 
* No Synology hosted domain 
* No Dynamic DNS setup hassles 

## Register a Domain

These steps assume you are using a TLD for your NAS - site.com - and possibly sub domains for different services - proxy.site.com. 

1. Register a domain name with any provider
2. On the registrar's site, navigate to the domain's DNS settings
3. Delete exiting DNS records


## Cloudflare

1. Create and verify a [Cloudflare]() account
2. Navigate to the Websites screen and click Add Site
3. Site = site.com (your TLD)
4. Select the Free plan and Continue
5. Ignore the 'no records' warnings for now
6. In the DNS Management section, click Add Record
   1. Type = A Record
   2. Name = NAS
   3. IPv4 = Router IP
   4. Proxy Status = Disabled (for now)


## Temporary NAS Firewall Rules

Temporary rules until NGINX is in place.

1. DSM > Control Panel > Security > Firewall tab
2. Default Profile > Edit Rules
3. Create > Ports > Custom Port
   1. 443/TCP Allow
   2. 80/TCP Allow


## Fios G3100 Router

```bash
# NAS static IP
192.168.1.209

# Point domain at NAS
# Advanced > Network Settings > DNS Server > Add DNS Record
site.com        # Host Name
192.168.1.209   # IP Address

# Temporary port forwarding
# Advanced > Security & Firewall > Port Forwarding
80   192.168.1.209 80   TCP
443  192.168.1.209 443  TCP

# Permanent port forwarding
6049 192.168.1.209 6050 TCP
6050 192.168.1.209 6050 TCP

# Confirm: https://www.portchecktool.com/
```



