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

# Create compose file
cd nginx-proxy
# TODO curl here

# Docker up
docker-compose up -d

# Exit sudo -i
exit
```

## Log In

1. Log in at the NAS static IP on port 8181 - http://192.168.1.209:8181
2. Defaults 
   1. admin@example.com
   2. changeme
3. Follow prompts to change credentials


## References

* https://nginxproxymanager.com/setup/#using-mysql-mariadb-database

