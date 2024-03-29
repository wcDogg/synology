# Custom Domain and Cloudflare Proxy

The goal is to access different services on the NAS from anywhere using secure URLs like https://dsm.site.

To keep the router's IP private, we use Cloudflare as a proxy. It maps site.com to the router's IP, but a DNS lookup of site.com will show a Cloudflare IP.


## Register a Domain

These steps assume you are using a TLD for your NAS - site.com - and sub domains for different services - proxy.site.com. 

1. Register a domain name with any provider
2. On the registrar's site, navigate to the domain's DNS settings
3. Delete exiting DNS records - usually 'parking' records


## Cloudflare DNS Records

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

**IMPORTANT** Set up the records, but do not proxy your IP until you have obtained SSL certificates.


## Cloudflare SSL/TLS

Prevents 'too many redirects' error once router's IP is proxied.

1. Left menu > Websites > site.com
2. Left menu > SSL/TLS
3. Encryption Mode = Full (strict)


## Test HTTP Login with Domain

Once the DNS records have propagated, test logging in using http:site.com:port

* See [Network Reference](network.md) for a running list of URLs

