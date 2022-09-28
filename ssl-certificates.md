# SSL Certificates

While we will be installing NGINX Proxy Manager which can get SSL certificates for us, this feature did not work for me. Instead, I needed to generate my certs via DSM then import them into NGINX. 

## Router Port Forwarding

To obtain SSL certificates from DSM, forward ports to NAS. 

```bash
# Port forwarding to NAS
80  TCP 192.168.1.209 80
443 TCP 192.168.1.209 443
```

## NAS SSL Certificate

This step obtains an SSL certificate for NAS using the TLD.

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

Confirm DSM is available at https://site.com:6050 - URL displays HTTPS and lock.

