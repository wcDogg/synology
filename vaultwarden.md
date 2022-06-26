# vaultwarden (bitwarden) Portainer Docker

* [dockerhub: vaultwarden](https://hub.docker.com/r/vaultwarden/server)
* [GitHub: vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
* [GitHub: vaultwarden Docker Compose](https://github.com/dani-garcia/vaultwarden/wiki/Using-Docker-Compose)
* https://www.youtube.com/watch?v=fQOqqJv1zCI


* https://www.youtube.com/watch?v=rvyzlmxloHY
* https://www.youtube.com/watch?v=MgFfrTzJ1ls
* https://www.wundertech.net/how-to-self-host-the-password-manager-bitwarden-on-a-synology-nas

## Prereqs

* [Custom subdomains](custom-domain.md)
* [Docker + Portainer](docker-portainer.md)

```
example.com = Domain registered with Namecheap
warden.example.com = Subdomain with A record on Namecheap
192.xxx.x.xxx = NAS internal static IP
/volume1/docker/vaultwarden/:/data/
-p 8080:80
```

## Install via Portainer Stack

1. File Station > docker > Add folder > vaultwarden
2. Portainer > Docker > Stacks > Add

```
version: '2'

services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      WEBSOCKET_ENABLED: "true"  # Enable WebSocket notifications.
    volumes:
      - /volume1/docker/vaultwarden:/data
    ports:
      - 8080:80
```
3. Keep defaults. Deploy stack.
4. Test: Stacks > vaultwarden > Published Ports > 8080:80 link
5. DO NOT create account yet - requires HTTPS, which requires reverse proxy. 

Notice this auto-creates a Docker bridge `vaultwarden` with the same settings as the `default` bridge.

## Install via Terminal

```
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v /volume1/docker/vaultwarden/:/data/ -p 8080:80 vaultwarden/server:latest
```

## Synology Reverse Proxy

1. DSM > Control Panel > Login Portal > Advanced > Reverse Proxy > Create
2. Description = Vaultwarden
3. Source
   1. Protocol = HTTPS
   2. Hostname = warden.example.com
   3. Port = 443
4. Enable HSTS = False
5. Destination
   1. Protocol = HTTP
   2. Hostname = 192.xxx.x.xxx
   3. Port = 8080
6. Test: https://warden.example.com
7. Create account.

