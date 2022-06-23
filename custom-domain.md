# NAS Custom Subdomains + Reverse Proxy

* Namecheap DDNS resolves our domain to our router's IP. 
* Our router's DNS resolves our domain to the NAS and forwards the needed ports. 
* Synology DDNS enables the service on the NAS. It maps + tests the Namecheap DDNS connction. 
* Let's Encrypt SSL certificate lets us enforce https.
* Reverse proxy lets us expose interal services to the Internet without opening additional ports on our router. 


## Resources

* https://www.youtube.com/watch?v=daIelVuKlYQ&list=WL&index=1
* https://brettterpstra.com/2021/08/26/custom-urls-for-your-synology-with-namecheap/
* https://www.youtube.com/watch?v=iWvCN2j7xjo

## Examples

```
example.com = Domain registered with Namecheap
sub.example.com = Subdomain with A record on Namecheap
3x.xxx.xxx.xx = Fios router public IP
192.xxx.x.xxx = NAS internal static IP
```


## Namecheap DDNS

1. Namecheap > Domain > Manage > Advanced DNS
2. A Record @ 3x.xxx.xxx.xx
3. A Record sub 3x.xxx.xxx.xx
4. Dynamic DNS = Enable + copy password

## Fios G3100 Router

```
# DNS
# Advanced > Network > DNS
example.com 192.xxx.x.xxx

# Port forwarding
# Advanced > Security & Firewall > Port Forwarding
80   192.xxx.x.xxx 80   TCP
443  192.xxx.x.xxx 443  TCP

# Ultimately move to reverse proxy
6049 192.xxx.x.xxx 6050 TCP
6050 192.xxx.x.xxx 6050 TCP

# Confirm: https://www.portchecktool.com/
```

## namecheap_ddns.sh

Synology DDNS support doesn't include Namecheap, se we add it manually. This script lives on the NAS and updates Namescheap when the IP address of our Fios router changes. We're using this method because the Namecheap query cannot be built via External Access > DDNS > Customize Provider. 

1. DSM > File Station > Shared > Upload `namecheap_ddns.sh`.
   1. We'll be copying it from here: /volume1/Shared/namecheap_ddns.sh
   2. To here: /usr/local/bin/namecheap_ddns.sh

```
NAS
sudo -i
password

# Copy file we uploaded
cp /volume1/Shared/namecheap_ddns.sh /usr/local/bin/namecheap_ddns.sh

# Confirm file is where we think it is
ls /usr/local/bin

# Make file executable
sudo chmod a+x /usr/local/bin/namecheap_ddns.sh
```

`namecheap_ddns.sh`:  

```
#!/bin/bash

## Namecheap DDNS updater for Synology
## Brett Terpstra <https://brettterpstra.com>
## Save this to /usr/local/bin/namecheap_ddns.sh

PASSWORD="$2"
DOMAIN="$3"
IP="$4"

PARTS=$(echo $DOMAIN | awk 'BEGIN{FS="."} {print NF?NF-1:0}')
# If $DOMAIN has two parts (domain + tld), use wildcard for host
if [[ $PARTS == 1 ]]; then
    HOST='@'
    DOMAIN=$DOMAIN
# If $DOMAIN has a subdomain, separate for HOST and DOMAIN variables
elif [[ $PARTS == 2 ]]; then
    HOST=${DOMAIN%%.*}
    DOMAIN=${DOMAIN#*.}
fi

RES=$(curl -s "https://dynamicdns.park-your-domain.com/update?host=$HOST&domain=$DOMAIN&password=$PASSWORD&ip=$IP")
ERR=$(echo $RES | sed -n "s/.*<ErrCount>\(.*\)<\/ErrCount>.*/\1/p")

if [[ $ERR -gt 0 ]]; then
    echo "badauth"
else
    echo "good"
fi
```

## ddns_provider.conf

This step adds Namecheap to Synolgy's list of DDNS providers. 

```
NAS
sudo -i
password

# Confirm ddns_provider.conf exists
ls /etc.defaults

# Make a backup
cp /etc.defaults/ddns_provider.conf /etc.defaults/20220621_ddns_provider.conf

# Append - paste this entire block at one time

cat >> /etc.defaults/ddns_provider.conf << 'EOF'
[Namecheap]
        modulepath=/usr/local/bin/namecheap_ddns.sh
        queryurl=https://namecheap.com
        website=https://namecheap.com
EOF
```

## Synology Settings

* Control Panel > Login Portal > DSM
  * DSM port http = 6049
  * DSM port https = 6050
  * Customized Domain = blank
* Control Panel > Extrnal Access > Advanced
  * Hostename = example.com
  * DSM HTTP = 6049 (5000)
  * DSM HTTPS = 6050 (5001)
  
HTTP2 = True - Perfomance boost in browsers that support this protocol. 


## Synology Custom DDNS

1. DSM > Control Panel > External Access > DDNS > Add
2. Service Provider = Namecheap
3. Host = example.com
4. Username/Email = na
5. Password/Key = Namecheap Dynamic DNS password
6. External address = Auto
7. Test connection = Normal


## SSL Certificate

To access our services over HTTPS, we need to install an SSL certificate for our custom domain.

1. DSM > Control Panel > Security > Certificates
2. Add > Add a New Certificate
3. Description = example.com
4. Get a Certificate from Let's Encrypt
   1. Domain name = example.com
   2. Email = NAS account email
   3. Subject = see below
5. Once generated, Settings
   1. Update each service to use the new cert
   2. Set as default certificate = True

```
sub1.example.com;sub2.example.com
```

## Test Access

* example.com should take you to the secure DSM login page on port 6050 (5001). 
* Internal IP on 6049 + 6050 should also still work. 


## Synology Reverse Proxy

A reverse proxy lets us expose internal services to the Internet without opening additional ports on our router. 

* The NAS requires us to forward ports 80 + 443.
* This step allows us to close ports 6049 (5000) + 6050 (5001) on the Fios router. 

### Configure

Big idea: Currently, Fios is forwarding DSM login 6049 to 6050, and 6050 to 6050. We need to replicate that behavior here before closing these ports on the router. 

1. DSM > Control Panel > Login Portal > Advanced > Reverse Proxy > Create
2. 2. Description = Main HTTP
   1. Source
      1. Protocol = HTTP
      2. Hostname = example.com
      3. Port = 6049
   2. Enable HSTS = True if possible, False for now
   3. Destination
      1. Protocol = HTTPS
      2. Hostname = 192.xxx.x.xxx
      3. Port = 6050
   
3. Description = Main HTTPS
   1. Source
      1. Protocol = HTTPS 
      2. Hostname = example.com
      3. Port = 443
   2. Enable HSTS = True if possible, False for now
   3. Destination
      1. Protocol = HTTPS
      2. Hostname = 192.xxx.x.xxx
      3. Port = 6050

HSTS = False - Tempramental with subdomains - Sets a header that lets a site - ie Goggle.com - inform the web browser that, hey, never access me via http. An added security measure. 

### Certificate

If you set the new SSL cert as the NAS default, then each new service / subdomain will use that cert automatically and there is no step here. 

When managing multiple certificates, you need to manually map the service to the cert. 

1. Control Panel > Security > Certificates
2. Select a certificate. Settings button. 
3. Use the dropdowns to map. Save.

### Test 

1. Close ports 6049 and 6050 on router.
2. Confirm secure login works: https://example.com 
3. Confirm insecure login auto redirects: http://example.com

Here I'n mot sure what happened. Either I never set up forwarding on 6049 and 6050, or they were automatically deleted from Fios once added to Synology reverse proxy. Net result is that login works as expected. 

## Access Control Profile

Used in lieu of firewall rules to restrict a given reverse proxy to specific IP addresses. We aren't using this at this time. 

## Firewall

1. Control Panel > Security > Firewall
2. Enable firewall = True
3. Default profile > Edit Rules > Create
4. Ports > Select from buit in 
  1. Port 80
  2. Port 443
5. Action = Allow
6. Enabled = True
7. Save. Apply.
8. Test login. 

## Add Another Service

See [Docker + Portainer: Reverse Proxy](docker-portainer.md/#reverse-proxy) for an example of how to use subdomains with reverse proxy. 

