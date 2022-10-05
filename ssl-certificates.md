# SSL Certificates and Proxy Hosts

How to create secure URLs - like https://dsm.site.com - to access NAS services. 


## NAS SSL Certificate

This step obtains an SSL certificate for the NAS using the TLD.

```bash
# Router port forwarding to NAS
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443
```

1. DSM > Security > Certificate > Add
2. Add New Certificate > Next
3. Get a Certificate from Let's Encrypt > Next
4. Details
   1. Domain Name = site.com (TLD)
   2. Email = <email>
   3. Subject Alternative Name = www.site.com
5. Done
6. Once certificate has generated, highlight and click Action > Edit
   1. Set as Default Certificate = True
7. Highlight cert again and click Settings
   1. Switch all services to use new cert

Confirm DSM is available at https://site.com:7043 - URL displays HTTPS and lock.

All other services are still HTTP - for example, SearXNG is http://site.com:7780.


## Router Port Forwarding

For subdomains to work, change your router's port forwarding rules from the NAS to NGINX Proxy Manager. 

```bash
# Port forwarding to NGINX
80  TCP 192.168.1.209 7280
443 TCP 192.168.1.209 7243
```

## About SSL Certs + Proxy Hosts

There are 2 ways to obtain SSL certificates in NGINX Proxy Manager:

* A 2-step process where the SSL cert is obtained separate from creating the proxy host.
* A 1-step process where the SSL cert is obtained while creating the proxy host. 

Interestingly, all services can be configured using the 2-step process and some MUST be - ie NGINX and Pi-hole. I'm not sure why - perhaps because these use additional servers? 

The [Network Reference](network.md) has a running list of proxy hosts and their configuration. 


## NGINX SSL Certificate + Proxy Host

This step obtains an SSL Certificate for NPM.

1. NPM - http://192.168.1.209:7281
2. SSL Certificates > Add Certificate > Let's Encrypt
   1. Domain Names = proxy.site.com
   2. Test Server Availability
   3. Email = your@email.com
   4. Agree = True
   5. Save

Confirm https://proxy.site.com displays the secure NPM Congratulations screen.

This step creates a proxy host for the NPM web UI using the proxy.site.com certificate. 

1. NGINX > Dashboard > Proxy Hosts > Add Proxy Host
2. Details tab
   1. proxy.site.com http 192.168.1.209 7281
   2. Cache Assets = False
   3. Block Common Exploits = True
   4. Websockets Support = False
3. SSL tab
   1. Use dropdown to select the proxy.site.com certificate
   2. Force SSL = True
   3. Done

Confirm you can sign in to NPM at https://proxy.site.com.


## Pi-hole SSL Certificate + Proxy Host

Set up Pi-hole in the same way as NPM.

1. Obtain SSL certificate for pi.site.com
2. Add proxy host: pi.site.com http 192.168.1.209 7480
3. Attach SSL to proxy

Confirm you can sign in at https://pi.site.com/admin


## SSL + Proxy Host in a Single Step

With many services you can create the proxy host and obtain an SSL certificate in a single step. See [Network Reference](network.md) for running list of proxies that can be configured this way.

1. NGINX > Dashboard > Proxy Hosts > Add Proxy Host
2. Details tab
   1. Cache Assets = False (setting doesn't stick)
   2. Block Common Exploits = True
   3. Websockets Support = False
3. SSL tab  
   1. Use the dropdown to select Request New Certificate
   2. Force SSL = True
   3. Email = your@email.com
   4. Agree = True
   5. Done

Confirm you can access your subdomains as expected - [Network Reference](network.md) has a running list of URLs.

Confirm you can create a VaultWarden account.


## Cloudflare: Proxy Router IP

Once you have HTTPS access to all of your subdomains, it's time to hide your router's public IP address by enabling Cloudflare's proxy. 

Before starting, do a [domain lookup](https://mxtoolbox.com/DNSLookup.aspx) for your site.com - note it shows your router's IP address.

1. Log in to Cloudflare
2. Left menu > Websites > site.com
3. Left menu > DNS
4. Edit each record. Toggle Proxy on.

Do another domain lookup - the IP for site.com should now point to Cloudflare :)


