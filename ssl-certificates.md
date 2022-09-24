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

Confirm DSM is available at https://site.com:6050 - URL displays HTTPS and lock.


## Create SSL Certificates and Export

Using dsm.site.com as an example, for each subdomain, create a certificate:

1. DSM > Security > Certificate > Add
2. Add New Certificate > Next
3. Get a Certificate from Let's Encrypt > Next
4. Details
   1. Domain Name = dsm.site.com (sub domain)
   2. Email = <email>
   3. Subject Alternative Name = blank
5. Done

Export certificate:

1. On the Certificates screen, highlight the dsm.site.com certificate
2. Action > Export > Download zip to local computer
   1. privatekey.pem
   2. cert.pem
   3. chain.pem
3. You'll want to keep these organized in directories for management over time


## Import SSL Certificates to NGINX

For each subdomain, import the cert files: 

1. NPM > Certificates > Add SSL Certificate > Custom
2. Name = dsm
3. Certificate Key = privatekey.pem
4. Certificate = cert.pem
5. Intermediary Certificate = chain.pem


## Attach Cert to Proxy

1. NPM > Dashboard > 



## Subdomain SSL via NGINX

Normally, you can request SSL certificates for your subdomains from NPM. This did not work for me and I used the export/import/attach methods above. 

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


## Scratch

* https://www.reddit.com/r/nginx/comments/ibevde/nginx_proxy_manager_https_not_working/

