# Lockdown: Final Steps


## NAS Firewall

The only port that needs to remain open is for SSH to the NAS. 

```bash
7022 TCP    # NAS SSH 22
```

## Router Port Forwarding

The only port forwarding needed is to NGINX Proxy manager.

```bash
# Port forwarding to NGINX
80  TCP 192.168.1.209 7280
443 TCP 192.168.1.209 7243
```

## Test

Once the NAS firewall rules are disabled and the router forwards to NGINX, ensure you still have HTTPS access to all of your subdomains. 


## Cloudflare: Proxy Router IP

Do a [domain lookup](https://mxtoolbox.com/DNSLookup.aspx) for your site.com - note it shows your router's IP address.

1. Log in to Cloudflare
2. Left menu > Websites > site.com
3. Left menu > DNS
4. Edit each record. Toggle Proxy on.

Do another domain lookup - the IP for site.com should now point to Cloudflare :)

