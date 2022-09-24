# Configure NGINX Proxy Manager


## Import SSL Certificates to NGINX

Import the [certificates created via DSM](ssl-certificates.md). For each cert:

1. NPM > Certificates > Add SSL Certificate > Custom
2. Name = dsm (subdomain)
3. Certificate Key = privatekey.pem
4. Certificate = cert.pem
5. Intermediary Certificate = chain.pem


## NGINX Subdomain Proxy Hosts

1. NGINX > Dashboard > Proxy Hosts > Add Proxy Host
2. See [Network Reference](network.md) for running list of proxies

```bash
proxy.site.com   http  192.168.1.209 8181
dsm.site.com     https 192.168.1.209 6050
plex.site.com    https 192.168.1.209 32400
```
3. On the Details screen create the proxies above
   1. Cache Assets = False (setting doesn't stick)
   2. Block Common Exploits = True
   3. Websockets Support = False
4. On the SSL screen 
   1. Use the dropdown to select the imported cert
   2. Force SSL = True
5. Save


## Router Port Forwarding

For subdomains to work, route web traffic through NGINX.

```bash
# Port forwarding to NGINX
80  TCP 192.168.1.209 8080
443 TCP 192.168.1.209 4443
```

## Test HTTPS

All proxies should display Status = Online. Confirm access:

* https://proxy.site.com
* https://dsm.site.com
* https://plex.site.com


## Cloudflare Proxy Router IP

Before starting, do a [domain lookup](https://mxtoolbox.com/DNSLookup.aspx) for your site.com - note it shows your router's IP address.

1. Log in to Cloudflare
2. Left menu > Websites > site.com
3. Left menu > DNS
4. Edit each record. Toggle Proxy on.

Do another domain lookup - the IP for site.com should now point to Cloudflare :)


## FAIL: Subdomain SSL via NGINX

Normally, you can request SSL certificates for your subdomains from NPM. This did not work for me, so I created [SSL certs via DSM](ssl-certificates.md) and importing them as above.

1. NGINX Dashboard > SSL Certificates > Add Certificate
2. Domain Names = dsm.site.com
3. Test Server Availability  = 
4. Email for Let's Encrypt = <email>
5. Use DNS Challenge = False
6. Agree = True
7. Save

Test Server Availability gives this error:

```bash
dsm.site.com: Failed to check the reachability due to a communication error with site24x7.com
```
NPM log shows this:

```bash
sudo cat /var/log/nginx/error.log

2022/09/23 11:51:55 [crit] 17531#17531: *1432 SSL_do_handshake() failed (SSL: error:141CF06C:lib(20):func(463):reason(108)) while SSL handshaking, client: 107.178.200.196, server: 0.0.0.0:443
```


