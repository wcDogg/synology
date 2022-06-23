# Docker

DSM > Package Center: Docker

* https://www.youtube.com/watch?v=xzMhZoUs7uw
* https://www.wundertech.net/how-to-use-docker-on-a-synology-nas

All roads lead to using compose files over the Synology GUI. The 2 most recomended methods are:

* Use the NAS-native Docker Compose
* Use Portainer.io

For Docker Compose, updating is recomended. An explantaion of why this failed is given below. The result is we'll be using Portainer. 

## Examples

```
example.com = Domain registered with Namecheap
sub.example.com = Subdomain with A record on Namecheap
3x.xxx.xxx.xx = Fios router public IP
192.xxx.x.xxx = NAS internal static IP
```

## Portainer.io

Portainer runs inside your Docker install. It's a container creation & managment tool. We'll be using the open-source verstion.

* https://www.portainer.io/
* https://www.youtube.com/watch?v=bLHWxtrU8Tg
* https://www.wundertech.net/how-to-install-portainer-on-a-synology-nas

## Install Portaino

1. DSM > File Station > docker > Create Folder > portainer-ce
2. SSH as root and install - this step configures Portainer and mounts `portainer-ce`. 
   1. 8000:8000 = http port
   2. 9000:9000 = https port
   3. `volume1` is default, update if needed. 
   
```
NAS
sudo -i
password

sudo docker run -p 8000:8000 -p 9000:9000 --detach --name=portainer-ce --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /volume1/docker/portainer-ce:/data portainer/portainer-ce

exit
```

### Firewall Rule

1. Control Panel > Security > Firewall > Defualt Profile > Edit Rules > Add Rule.
2. Port > Select from list > Portainer 8000, 9000

### Account

3. 192.xxx.x.xxx:9000
4. Create Portaino username + password.
5. On the Quick Setup screen, select Proceed Using Local...
6. From here you can click on the local Docker instance and manage. 

```
# Not found
192.xxx.x.xxx:8000
http://192.xxx.x.xxx:8000

# Found, not secure
192.xxx.x.xxx:9000
http://192.xxx.x.xxx:9000

# Secure connection failed
https://192.xxx.x.xxx:9000
```

### Container Ports

At this point, if you go to Portainer > Containers > portainer-ce > and click the 9000 port, the URL loads as 0.0.0.0. To fix this:

1. Portainer > Environments > local > Public IP = NAS IP = 192.xxx.x.xxx

## Reverse Proxy

See: [Custom Domains + Reverse Proxy](custom-domain.md#synology-reverse-proxy)

Noting this because the ports were confusing. You would think the destination would need to be HTTPS and 9000, but it's actually HTTP and 9000. I can't explain how this results in secure login, but it does.  

Also tried enforcing HTTPS via Portainer's settings. Once applied, no combination of protocol + IP + port allowed access. To fix, I needed to delete and reinstall Portainer. 

1. Description = Portainer HTTPS
   1. Source
      1. Protocol = HTTPS 
      2. Hostname = portainer.example.com
      3. Port = 443
   2. Enable HSTS = True if possible, False for now
   3. Destination
      1. Protocol = HTTP !!!
      2. Hostname = 192.xxx.x.xxx
      3. Port = 9000
   4. HSTS = False
2. Control Panel > Security > Firewall - Close ports 8000 + 9000
3. Control Panel > Security > Certificate - Map portainer.example.com to correct cert
4. Test https://portainer.example.com


## FAIL: Update Docker Compose

Could not update `docker-compose`. I've seen more than one post citing that Synology has buggy support for Docker Compose and suggesting [Portainer](https://www.portainer.io/). 

The first problem is that you can only upgrade from 1.28.5 to 1.29.2 in the standard way - version 2 is a move from Python to Golang and has an entirely different process that is beyond my skills. 

The second problem is that I can't get these excelent instructions to work: 

* https://www.youtube.com/watch?v=E0Q4xVn0gRc
* https://www.wundertech.net/how-to-update-docker-compose-on-a-synology-nas

```
# SSH to root and note current version - 1.28.5.
ssh to root
docker-compose --version

# Change directories and confirm `docker-compose` folder is present.
cd /var/packages/Docker/target/usr/bin
ls

# Backup by renameing. 
sudo mv docker-compose docker-compose-backup

# Update to the latest v1
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o docker-compose

# Update permissions and check version.
sudo chmod +x docker-compose
docker-compose --version
```

Wundertech notes that if things don't work, you can go back to the original.

```
sudo rm docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.28.5/docker-compose-`uname -s`-`uname -m` -o docker-compose
sudo chmod +x docker-compose
docker-compose --version
```

I couldn't get the update or restore to work. Instead, I had to manually delete + restore from backup.

```
sudo rm docker-compose
sudo mv docker-compose-backup docker-compose
sudo chmod +x docker-compose
docker-compose --version
```

Error: Saw more than one that I failed to nete here, but this was most common:

```
docker-compose: error while loading shared libraries: libz.so.1: failed to map segment from shared object
```
