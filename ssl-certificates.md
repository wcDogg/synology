# SSL Certificates


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


## Subdomain SSL via NGINX

I obtain a separate certificate for each subdomain - vs putting all on one certificate.

1. NGINX Dashboard > SSL Certificates > Add Certificate
2. Domain Names = dsm.site.com
3. Test Server Availability  = 
4. Email for Let's Encrypt = <email>
5. Use DNS Challenge = False
6. Agree = True
7. Save


## Issue

Test Server Availability gives this error:

```bash
dsm.site.com: Failed to check the reachability due to a communication error with site24x7.com
```

NPM log shows this:

```bash
sudo cat /var/log/nginx/error.log

2022/09/23 11:51:55 [crit] 17531#17531: *1432 SSL_do_handshake() failed (SSL: error:141CF06C:lib(20):func(463):reason(108)) while SSL handshaking, client: 107.178.200.196, server: 0.0.0.0:443
```





Search

```bash
nginx proxy manager SSL_do_handshake failed 108

```



## Scratch

* https://www.reddit.com/r/nginx/comments/ibevde/nginx_proxy_manager_https_not_working/