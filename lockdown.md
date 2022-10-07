# Lockdown: Final Steps


## NAS Firewall

See [Network Reference](network.md) for a list of final NAS firewall rules.


## Router Port Forwarding

```bash
# Port forwarding to NGINX
80  TCP 192.168.1.209 7280
443 TCP 192.168.1.209 7243
```

## Cloudflare: Proxy Router IP

Once you have HTTPS access to all of your subdomains, it's time to hide your router's public IP address by enabling Cloudflare's proxy. 

Before starting, do a [domain lookup](https://mxtoolbox.com/DNSLookup.aspx) for your site.com - note it shows your router's IP address.

1. Log in to Cloudflare
2. Left menu > Websites > site.com
3. Left menu > DNS
4. Edit each record. Toggle Proxy on.

Do another domain lookup - the IP for site.com should now point to Cloudflare :)

