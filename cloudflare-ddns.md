# Cloudflare Dynamic DNS on Synology NAS

Most home routers are assigned a dynamic IP address - meaning it can change at any time. There are several options for automatically informing Cloudflare when the router's IP changes. I'm doing this by running a Docker container on the NAS.


## Cloudflare API Token

1. User menu > My Profile
2. Left menu > API tokens
3. Create Token > Select the Zone DNS template
4. Token Name = site-com-ddns
5. Permissions = 
   1. Zone - DNS - Edit
   2. Zone - Zone - Read
   3. Zone - Zone Settings - Read
6. Zone Resources = Include - All Zones
7. Continue to Summary. Create Token.
8. Copy token to a password manager

Use the on-screen command to test the token. It looks like this where Bearer = token: 

```bash
curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" -H "Authorization: Bearer cfAPItokenHERE" -H "Content-Type:application/json"
```

## Install Cloudflare DDNS

Note there are no ports or a proxy host for this container.

```bash
# Escalate to root
sudo -i
password

# Go here
cd /volume1/docker

# Create volumes
mkdir -p cloudflare-ddns

# Create .env file
cd cloudflare-ddns
nano .env

# Add this to file
CF_API_TOKEN=cfAPItokenHERE
TOP_LEVEL_DOMAIN=site.com

# Get compose file
curl -f https://raw.githubusercontent.com/wcDogg/synology/main/docker/cloudflare-ddns/docker-compose.yml -o docker-compose.yml

# Review compose file
nano docker-compose.yml

# Docker up
docker-compose up -d
```

## Confirm

1. DSM > Docker > Containers
2. Highlight container and click the Details button
3. Review the Log tab


## References

* [Cloudflare: Use Dynamic IP Addresses](https://developers.cloudflare.com/dns/manage-dns-records/how-to/managing-dynamic-ip-addresses/)
* https://www.youtube.com/watch?v=Nf7m3h11y-s

