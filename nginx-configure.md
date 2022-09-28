# Configure NGINX Proxy Manager on Synology NAS


## NGINX Subdomain Proxy Hosts

See [Network Reference](network.md) for running list of proxies

1. NGINX > Dashboard > Proxy Hosts > Add Proxy Host
2. Details screen
   1. Cache Assets = False (setting doesn't stick)
   2. Block Common Exploits = True
   3. Websockets Support = False

All proxies should display Status = Online.


## Test HTTP Subdomains

For subdomains to work, change your router's port forwarding rules from the NAS to NPM. 

```bash
# Port forwarding to NGINX
80  TCP 192.168.1.209 7280
443 TCP 192.168.1.209 7243
```

You can now access your NAS using your subdomains. See [Network Reference](network.md) for running list of URLs.


## Add SSL Certificates

Once all subdomains are working, add SSL certificates.

1. NGINX > Dashboard > Proxy Hosts
2. Proxy Host > ... > Edit > SSL tab > 
3. Use the dropdown to select Request New Certificate
4. Force SSL = True
5. Email = <email>
6. Agree = True
7. Done


## Test HTTPS Access

You should now be able to access all of your subdomains using HTTPS. See [Network Reference] for a running list of URL in this project. 



## Cloudflare Proxy Router IP

Before starting, do a [domain lookup](https://mxtoolbox.com/DNSLookup.aspx) for your site.com - note it shows your router's IP address.

1. Log in to Cloudflare
2. Left menu > Websites > site.com
3. Left menu > DNS
4. Edit each record. Toggle Proxy on.

Do another domain lookup - the IP for site.com should now point to Cloudflare :)

