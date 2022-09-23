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
   1. See [Cloudflare DNS Records](network.md) for running list of records used in this project.
7. Continue
8. Follow instructions to update the Nameservers with your domain registrar
   1. Namescheap > Domain List > Domain > scroll down to Nameservers section
9. Back in Cloudflare, click Done and wait for propagation


## Test HTTP Login with Domain

Once the DNS records have propagated, try logging in using your domain name. 

* http://site.com:6049
* http://site.com:8181


## Router Port Forwarding

Update your router's port forwarding to send web traffic through NGINX.

```bash
# Initial port forwarding to NAS
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443

# New port forwarding to NGINX
80  TCP 192.168.1.209 8080
443 TCP 192.168.1.209 4443
```

## NGINX Subdomains

NGINX > Dashboard > Proxy Hosts > Add Proxy Host

```bash
proxy.site.com   http  192.168.1.209 8181
dsm.site.com     https 192.168.1.209 6050
plex.site.com    https 192.168.1.209 32400

# Cache Assets = False (setting doesn't stick)
# Block Common Exploits = True
# Websockets Support = False
```

All proxies should display Status = Online. Confirm access:

* http://proxy.site.com
* http://dsm.site.com
* http://plex.site.com
