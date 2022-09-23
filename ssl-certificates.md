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


## xx Subdomain SSL via NGINX

Here are the instructions for obtaining SSL certificates for subdomains via NPM. This did not work for me  - generating the cert produces an 'Internal Error' with no on-screen explanation. 

If it had worked, this step would make DSM available at https://dsm.wcd.black.

1. NGINX > Proxy Hosts > Add Proxy Host
2. Details
   1. Domain Names = dsm.wcd.black
   2. Schema = https
   3. Forward IP = NAS static ip = 192.168.1.209
   4. Forward Port = NAS HTTPS = 6050
   5. Block Common Exploits = True
3. Save. Ensure Status = Online. 
4. Dot menu > Edit
5. SSL
   1. Dropdown > Request New Certificate
   2. Force SSL = True
   3. Email = already populated from TLD cert
   4. Agree = True
6. Save


