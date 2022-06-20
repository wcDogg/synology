# Docker

DSM > Package Center: Docker

* https://www.youtube.com/watch?v=xzMhZoUs7uw
* https://www.wundertech.net/how-to-use-docker-on-a-synology-nas

All roads lead to using compose files over the Synology GUI. The 2 most recomended methods are:

* Use the NAS-native Docker Compose
* Use Portainer.io

For Docker Compose, updating is recomended. An explantaion of why this failed is given below. The result is we'll be using Portainer. Some key differences:

* Portainer handles the mounting
* Portainer handles the macLAN
* Portainer makes it easy to paste in config

## Portainer.io

Portainer runs inside your Docker install. It's a container creation & managment tool. We'll be using the open-source verstion.

* https://www.portainer.io/
* https://www.youtube.com/watch?v=bLHWxtrU8Tg
* https://www.wundertech.net/how-to-install-portainer-on-a-synology-nas

## Install Portaino

1. DSM > File Station > docker > Create Folder > portainer-ce
2. SSH as root and install - this step configures Portainer and mounts `portainer-ce`. 
   1. `volume1` is default, update if needed. 
   2. This sets Portaier's ports to 8000 + 9000. 
   
```
NAS
sudo -i
password

# volume1 is default, update if needed.

sudo docker run -p 8000:8000 -p 9000:9000 --detach --name=portainer-ce --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /volume1/docker/portainer-ce:/data portainer/portainer-ce

exit
```

3. DSM > Control Panel > Security > Firewall > Enable port 8000.
4. https://nasip:8000
5. Create Portaino username + password.
6. On the Quick Setup screen, select Proceed Using Local...
7. From here you can click on the local Docker instance and manage. 


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
