# Install NGINX Proxy Manager


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

# Get compose file
cd nginx-proxy

curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/nginx-proxy/docker-compose.yml -o docker-compose.yml

# Review compose file
# Set strong passwords!!!
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Sign In

1. Sign in at the NAS static IP on port 8181 - http://192.168.1.209:7281
2. Defaults 
   1. admin@example.com
   2. changeme
3. Follow prompts to change credentials


## References

* https://nginxproxymanager.com/setup/#using-mysql-mariadb-database

