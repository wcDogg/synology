# Install NGINX Proxy Manager

**IMPORTANT** This should be the first container you create as only one network can use eth0 as parent???


## Install Docker

1. Install from DSM > Package Center
2. A `/volume1/docker` directory is auto-created


## Create Volumes

DSM > File Station > docker > Create Folder

```bash
# Proxy
/volume1/docker/nginx-proxy
/volume1/docker/nginx-proxy/data
/volume1/docker/nginx-proxy/lets-encrypt
# Database
/volume1/docker/nginx-mariadb
```

## config.json

1. Create a `config.json` file locally
2. `host` = NAS static IP
3. Customize name, user, password, and port
4. Upload via File Station to `/volume1/docker/nginx-proxy`

```json
{
  "database": {
    "engine": "mysql",
    "host": "192.168.1.209",
    "name": "nginx-mariadb",
    "user": "wcd",
    "password": "wcd",
    "port": "3306"
  }
}
```

## macvlan 

```bash
# SSH to NAS
# Locate the network name where
# inet = NAS static IP (usually eth0)
ip addr

# Create macvlan
# This is a network named npm_network with 1 IP address.
# The --subnet, --gateway, and --ip-range must be available.
# Check router and other Docker networks.
sudo docker network create -d macvlan -o parent=eth0 --subnet=192.168.15.0/24 --gateway=192.168.15.1 --ip-range=192.168.15.2/32 npm_network

# The result of this command is
npm_network       # Network name
192.168.15.0/24   # Subnet
192.168.15.2/32   # IP range (single IP)
192.168.15.1      # Gateway

# Confirm in Docker > Network
# npm_network should be listed
```

## Bridge Network

1. Launch Docker. On the Network screen select Add.
2. Enable IPv4
3. Use Manual Configuration

```bash
npm_bridge        # Network name
192.168.14.0/24   # Subnet
192.168.14.2/32   # IP range (single IP)
192.168.14.1      # Gateway
```

## MariaDB Container

1. Docker > Registry > MariaDB > Download latest
2. Images > double-click MariaDB to configure
3. Network > Use Selected = Bridge
4. General Settings
   1. Container Name = nginx-mariadb
   2. Enable Auto-Restart = True
5. General Settings > Advanced Settings > Environment
   
```bash
# Match config.json
MYSQL_PASSWORD        wcd
MYSQL_USER            wcd
MYSQL_DATABASE        nginx-mariadb
MYSQL_ROOT_PASSWORD   wcd
```
6. Port = 3306 3306 TCP (config.json)
7. Volume > Add Folder

```bash
docker/nginx-mariadb -> /var/lib/mysql
```
8. Review summary and click Done


## NPM Container

1. Docker > Images > jc21/nginx-proxy-manager > Download latest
2. Image > double-click to configure
3. Network > Use Selected
   1. Bridge = False
   2. npm_bridge = True
   3. npm_network = True
4. General 
   1. Container Name = nginx-proxy
   2. Enable Auto-Restart = True
5. Port
   
```bash
# Local - Container - Protocol
4443 443 TCP      # nginx-proxy HTTPS
8080 80 TCP       # nginx-proxy HTTP
8181 81 TCP       # nginx-proxy web UI
```
6. Volume > Add Folder + Add File
   
```bash
/volume1/docker/nginx-proxy/data -> /data
/volume1/docker/nginx-proxy/lets-encrypt -> /etc/letsencrypt
/volume1/docker/nginx-proxy/config.json -> /app/config/production.json
```
7.  Review Summary and click Done


## NAS Firewall

See [Initial Firewall Rules](network.md/#initial-firewall-rules)


## Log In

1. Wait a minute for container to be up
2. Log in at the NAS static IP on port 8181 - http://192.168.1.209:8181
3. Defaults 
   1. admin@example.com
   2. changeme
4. Follow prompts to change credentials


## References

* https://www.youtube.com/watch?v=X1jCLKKkYuQ&t=129s

