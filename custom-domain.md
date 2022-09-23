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


## NAS Firewall 

See [Initial Firewall Rules](network.md/#initial-firewall-rules)


## Cloudflare

1. Create and verify a [Cloudflare]() account
2. Navigate to the Websites screen and click Add Site
3. Site = site.com (your TLD)
4. Select the Free plan and Continue
5. Ignore the 'no records' warnings for now
6. In the DNS Management section, click Add Record
   1. Point your TLD at your router's public IPv4 address
   2. Do not proxy your address yet - comes later
   3. For now I am also including subdomains for DSM, NGINX, and Plex

```bash
A @     102.19.146.13  Proxy Status = Disabled 
A www   102.19.146.13  Proxy Status = Disabled 
A dsm   102.19.146.13  Proxy Status = Disabled
A proxy 102.19.146.13  Proxy Status = Disabled 
A plex  102.19.146.13  Proxy Status = Disabled 
```
7. Continue
8. Follow instructions to update the Nameservers with your domain registrar
   1. Namescheap > Domain List > Domain > scroll down to Nameservers section
9. Back in Cloudflare, click Done and wait for propagation


## Fios G3100 Router

```bash
# NAS static IP
192.168.1.209

# Point TLD at NAS
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

## Test HTTP Login with Domain

Once the DNS records have propagated and the router is configured, try logging in using your domain name. 

* http://site.com:6049
* http://site.com:8181


## NAS SSL Certificate

Big idea: The NAS is a server with it's own certificate for the TLD. All other servers and there certificates are managed via NGINX. This step is for the TLD cert on the NAS.

1. DSM > Security > Certificate > Add
2. Add New Certificate > Next
3. Get a Certificate from Let's Encrypt > Next
4. Details
   1. Domain Name = site.com (TLD)
   2. Email = <email>
   3. Subject Alternative Name = www.site.com
5. Done
6. Once certificate has generated, click the Settings button 
7. Switch all certificate to your new one and Save

At this point, you should be able to log in to DSM over HTTPS. Note NGINX and Plex aren't there yet :P

* https://site.com:6050





