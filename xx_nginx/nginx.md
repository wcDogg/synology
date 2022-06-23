# Nginx Proxy Manager


* https://www.wundertech.net/nginx-proxy-manager-synology-nas-setup-instructions
* https://www.youtube.com/watch?v=X1jCLKKkYuQ&t=118s
* https://hub.docker.com/_/nginx

## Folders

DSM > File Station > docker

```
/volume1/docker/nginx-mariadb : /var/lib/mysql
/volume1/docker/nginx
/volume1/docker/nginx/nginx-config.json : /app/config/production.json
/volume1/docker/nginx/data : /data
/volume1/docker/nginx/letsencrypt : /etc/letsencrypt
```

## Nginx config.json

* `host` = NAS IP address.
* `name`, `user` + `password` become credentials for MariaDB.

```
{
  "database": {
  "engine": "mysql",
  "host": "192.168.1.209",
  "name": "npm",
  "user": "npm",
  "password": "npm",
  "port": 8795
 }
}
```

## MacLAN

Ultimately gives Nginx container its own IP address on the external network that the NAS is using. This prevents the container's IP + ports from conflicting with the NAS's IP + ports. The services run on the container can be access directly by clients on the network witout NAT translation or port forwarding. 

### NAS IP

```
NAS
ip address

# Locate adapter where inet = NAS IP = eth0
# inet 192.168.1.209/24
# The /24 tells us the subnet is 192.168.1
```

### Available IP

This part is fuzzy. Believe goal is to look at router and identify an available IP on the same subnet as the NAS. 

I have a Fios G3100 + very little knowledge. For this I looked at Advanced > Network Settings > DNS server. My assigned IPs go up to 209, so for the MacLAN I decided to use 192.168.1.217

### Create

You will know this step is successful if DSM > Docker > Network shows a new `npm_network`.

```
# subnet   = 192.168.1.0/24 
# gateway  = 192.168.1.1
# ip-range = 192.168.1.217/32 - 32 means entire address is a network
# npm_network = network name

NAS
sudo -i
password

sudo docker network create -d macvlan -o parent=eth0 --subnet=192.168.1.0/24 --gateway=192.168.1.1 --ip-range=192.168.1.217/32 npm_network

# Response is a network ID - a long alpha-numeric string
# 7478ecc8fc4fdd5de95a62f94d3b9344e274f08297c07dbb6c42d0aac04a639b
```

## Bridge Network

Allows the NAS and its services to access Nginx. This is necessary because the MacLAN doesn't allow direct access from the host itself.

### Create

Here we use a subnet not already in use on our router - `.10.`.

1. DSM > Docker > Network > Add
2. Network Name = npm_bridge
3. Enable IPv4 = True
4. Use Manual Configuration = True
5. Subnet =   192.168.10.0/24
6. IP Range = 192.168.10.2/32
7. Gateway =  192.168.10.1

### MariaDB Container

https://registry.hub.docker.com/_/mariadb/

The networking instructions for this container aren't clear, so I start by attaching to the default Docker bridge.

1. Docker > Registry > MariaDB > Download.
2. Docker > Image > double-click MariaDB image to launch wizard.
3. Network > Use the selected networks
   1. npm_netowrk = False
   2. npm_bridge = False
   3. bridge = True
4. General Settings 
   1. Container name = nginx-mariadb
   2. Enable Auto-Restart = True
5. General Settings > Advanced Settings > Environment
   1. See config.json
   2. MYSQL_PASSWORD npm
   3. MYSQL_USER npm
   4. MYSQL_DATABASE npm
   5. MYSQL_ROOT_PASSWORD npm
6. Port Settings - see config.json
   1. Local 8795 to container 3306 TCP
7. Volume Settings  
   1. /volume1/docker/nginx-mariadb : /var/lib/mysql
8. Review Summary > Done

### Second attempt

1. Network = Use same as Docker Host
2. Port settings do not apply = 3306


## Nginx Container

Check: Environment > Server IP = macvlan = 192.168.1.217

1. Docker > Registry > jc21/nginx-proxy-manager > Download.
2. Docker > Image double-click image to launch wizard.
3. Newtowrk > Use the selected networks
   1. npm_network = True 
   2. npm_bridge = True 
   3. bridge = False 
4. General Settings 
   1. Container name = nginx
   2. Enable Auto-Restart = True
5. Port Settings
   1. 8080 > 80 http
   2. 8081 > 81 web interface
   3. 4443 > 443 https
6. Volume Settings
   1. /volume1/docker/nginx/config.json : /app/config/production.json
   2. /volume1/docker/nginx/data : /data
   3. /volume1/docker/nginx/letsencrypt : /etc/letsencrypt


## Nginx Admin

1. Navigate to npm_network IP port 81
   1. http://192.168.1.217:81
2. Username = admin@example.com
3. Password = changeme
4. Follow prompts to update credentials.

## Check connections

The macvlan server should be reachable.

```
NAS
nslookup
> server

# Default server: 192.168.1.1
# Address: 192.168.1.1#53

nslookup
> server 192.168.1.217

# Default server: 192.168.1.217
# Address: 192.168.1.217#53
```

## BAD GATEWAY

```
EHOSTUNREACH 192.168.1.209:8795
```

### Settings

* Control Panel > Network > Genral > Advanced Settings > Reply to ARP = False








