# Install NGINX Proxy Manager on Synology NAS


## Install

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volumes
mkdir -p nginx-proxy/data
mkdir -p nginx-proxy/lets-encrypt
mkdir -p nginx-mariadb

# Create .env file
cd nginx-proxy
nano .env

# Add this to file - set strong passwords!
MYSQL_USER="npm"
MYSQL_PASSWORD="changeme"
MYSQL_ROOT_PASSWORD="changemeroot"

# Get compose file
curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/nginx-proxy/docker-compose.yml -o docker-compose.yml

# Review compose file
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Sign In

1. Sign in at the NAS static IP on port 7281 - http://192.168.1.209:7281 
   1. UN default = admin@example.com
   2. PW default = changeme
2. Follow prompts to change credentials

## References

* https://nginxproxymanager.com/setup/#using-mysql-mariadb-database

